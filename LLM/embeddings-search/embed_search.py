#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["openai==2.15.0", "sqlite-vec==0.1.9"]
# ///
"""Semantic search over your own Markdown files with the ARC LLM API and sqlite-vec.

`index` splits every .md file under a directory into paragraphs, embeds them
with Qwen3-Embedding-4B, and stores the vectors in a single SQLite file.
`search` embeds a question and prints the closest paragraphs with the file they
came from. Only the question is sent at search time; the documents are embedded
once, during `index`.

  ./embed_search.py index sample/
  ./embed_search.py search "Why do stars shine?"
  ./embed_search.py search -k 5 --db notes.db "When did the Roman Empire fall?"

Requires LLM_ARC_API_KEY in the environment.
"""

from __future__ import annotations

import argparse
import os
import sqlite3
import sys
import time
from pathlib import Path

import sqlite_vec
from openai import OpenAI, RateLimitError

BASE_URL = "https://llm-api.arc.vt.edu/api/v1"
MODEL = "Qwen3-Embedding-4B"
DIMENSIONS = 2560
BATCH_SIZE = 32
# Qwen3-Embedding retrieves better when the query (not the documents) carries a
# one-line task description.
TASK = "Given a question, retrieve passages that answer it"


def connect(path: Path) -> sqlite3.Connection:
    db = sqlite3.connect(path)
    db.enable_load_extension(True)
    sqlite_vec.load(db)
    db.enable_load_extension(False)
    return db


def embed(client: OpenAI, texts: list[str]) -> list[list[float]]:
    """Embed texts in batches, waiting out the per-user rate limit when it is hit."""
    vectors = []
    for start in range(0, len(texts), BATCH_SIZE):
        batch = texts[start:start + BATCH_SIZE]
        while True:
            try:
                response = client.embeddings.create(model=MODEL, input=batch)
                break
            except RateLimitError as e:
                # The wait time is in the error body; there is no Retry-After header.
                error = e.body if isinstance(e.body, dict) else {}
                wait = error.get("retry_after_s", 5)
                print(f"rate limited ({error.get('reason')}), waiting {wait}s", file=sys.stderr)
                time.sleep(wait)
        vectors.extend(item.embedding for item in response.data)
        if len(texts) > 1:
            print(f"embedded {len(vectors)}/{len(texts)}", file=sys.stderr)
    return vectors


def paragraphs(path: Path) -> list[tuple[str, str]]:
    """Split a Markdown file into (heading, paragraph) pairs on blank lines."""
    heading = ""
    chunks = []
    for block in path.read_text(encoding="utf-8").split("\n\n"):
        block = block.strip()
        if not block:
            continue
        if block.startswith("#") and "\n" not in block:
            heading = block.lstrip("#").strip()
            continue
        chunks.append((heading, block))
    return chunks


def cmd_index(client: OpenAI, args: argparse.Namespace) -> None:
    files = sorted(args.directory.rglob("*.md"))
    if not files:
        raise SystemExit(f"no .md files under {args.directory}")

    rows = [(str(f.relative_to(args.directory)), heading, text)
            for f in files for heading, text in paragraphs(f)]
    print(f"{len(rows)} paragraphs from {len(files)} files", file=sys.stderr)
    vectors = embed(client, [text for _, _, text in rows])

    db = connect(args.db)
    db.execute("drop table if exists chunks")
    db.execute("drop table if exists vec_chunks")
    db.execute("create table chunks(id integer primary key, source text, heading text, text text)")
    db.execute(f"create virtual table vec_chunks using vec0(embedding float[{DIMENSIONS}] distance_metric=cosine)")
    for i, ((source, heading, text), vector) in enumerate(zip(rows, vectors)):
        db.execute("insert into chunks values (?, ?, ?, ?)", (i, source, heading, text))
        db.execute("insert into vec_chunks(rowid, embedding) values (?, ?)",
                   (i, sqlite_vec.serialize_float32(vector)))
    db.commit()
    db.close()
    print(f"wrote {len(rows)} paragraphs to {args.db}")


def cmd_search(client: OpenAI, args: argparse.Namespace) -> None:
    if not args.db.exists():
        raise SystemExit(f"{args.db} not found; run `index` first")
    query_vector = embed(client, [f"Instruct: {TASK}\nQuery: {args.question}"])[0]

    db = connect(args.db)
    results = db.execute(
        """
        select c.source, c.heading, c.text, v.distance
        from vec_chunks v join chunks c on c.id = v.rowid
        where v.embedding match ? and k = ?
        order by v.distance
        """,
        (sqlite_vec.serialize_float32(query_vector), args.k),
    ).fetchall()
    for source, heading, text, distance in results:
        location = f"{source} > {heading}" if heading else source
        print(f"{1 - distance:.3f}  {location}\n       {text}\n")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--db", type=Path, default=Path("embeddings.db"), help="SQLite file (default embeddings.db)")
    sub = ap.add_subparsers(dest="command", required=True)
    p_index = sub.add_parser("index", parents=[common], help="embed every .md file under a directory")
    p_index.add_argument("directory", type=Path)
    p_search = sub.add_parser("search", parents=[common], help="find the paragraphs closest to a question")
    p_search.add_argument("question")
    p_search.add_argument("-k", type=int, default=3, help="number of results (default 3)")
    args = ap.parse_args()

    api_key = os.environ.get("LLM_ARC_API_KEY", "")
    if not api_key:
        raise SystemExit("set LLM_ARC_API_KEY (llm.arc.vt.edu > Settings > Account > API keys)")
    client = OpenAI(api_key=api_key, base_url=BASE_URL, max_retries=0)

    if args.command == "index":
        cmd_index(client, args)
    else:
        cmd_search(client, args)


if __name__ == "__main__":
    main()
