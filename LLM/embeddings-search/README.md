# Semantic Search with the ARC LLM API

This example demonstrates how to search your own documents by meaning, using
the ARC LLM API embeddings endpoint and [sqlite-vec](https://github.com/asg017/sqlite-vec).

The script:

1. Splits every Markdown (`.md`) file under a directory into paragraphs.
2. Embeds each paragraph with `Qwen3-Embedding-4B` through `/api/v1/embeddings`.
3. Stores the vectors in a single SQLite file with the sqlite-vec extension.
4. Embeds a question and returns the paragraphs closest to it in meaning.

The documents are embedded once, when you run `index`. Each search sends only
the question to the API.

## Requirements

- Python 3.11+
- [uv](https://docs.astral.sh/uv/)
- Access to `https://llm-api.arc.vt.edu`
- An ARC LLM API key

The script uses `uv` to install its Python dependencies (`openai` and
`sqlite-vec`) automatically.

## Quick start

1. Create a `.env` file in the same directory as the script and add your ARC
   LLM API key:

```bash
echo 'LLM_ARC_API_KEY="your-api-key"' > .env
```

2. Load the environment variables into your shell:

```bash
set -a
source .env
set +a
```

3. Index the sample notes in `sample/`:

```bash
uv run embed_search.py index sample/
```

```
18 paragraphs from 4 files
embedded 18/18
wrote 18 paragraphs to embeddings.db
```

4. Ask a question:

```bash
uv run embed_search.py search "When did the Roman Empire fall?"
```

```
0.693  history.md > Ancient Rome
       The Western Roman Empire is traditionally dated as ending in 476 CE, when Odoacer deposed the emperor Romulus Augustulus.

0.512  history.md > Ancient Rome
       The Colosseum in Rome was completed in 80 CE under the emperor Titus.

0.473  history.md > Modern Europe
       The Berlin Wall fell on 9 November 1989, and Germany was reunified the following year.
```

The number is the cosine similarity between the question and the paragraph;
higher is closer. The exact scores can vary slightly between runs.

5. Optional: index your own notes into a separate database and return more
   results:

```bash
uv run embed_search.py index --db notes.db ~/notes
uv run embed_search.py search --db notes.db -k 5 "What did we decide about the cluster upgrade?"
```

## Rate limits

Each user can embed up to 150,000 tokens per minute, with bursts up to 300,000,
and can have at most 4 embedding requests in flight. The script sends one batch
of 32 paragraphs at a time. When the API returns HTTP 429, the script waits for
the number of seconds given in the response body and retries. See the
[ARC LLM API documentation](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html)
for details.

## Notes

- Running `index` again rebuilds the database from scratch.
- Each paragraph must fit in 8,192 tokens, roughly 6,000 words of English.
- sqlite-vec is pre-1.0, so the script pins `sqlite-vec==0.1.9`. If you upgrade
  it, run `index` again rather than reusing a database built with the old
  version.
- The database file starts at about 10 MB, because sqlite-vec allocates space
  for 1,024 vectors at a time.
