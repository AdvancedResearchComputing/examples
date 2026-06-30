# Agent instructions

You are connected to an ARC-hosted LLM through an OpenAI/Anthropic-compatible
proxy. This is **not** first-party Claude. Some features are absent and the
context window is smaller than you may assume. Work accordingly.

## What is unavailable — do not attempt it

- **Sub-agents / Agent / Explore / Task tools.** Spawning a sub-agent fails. Do
  all work inline in this session.
- **Built-in Web search and web fetch.** Do not cite live URLs.
  If you need external docs or standards, ask me to paste the relevant snippet.
- **Extended thinking** is unreliable through the proxy; do not rely on it.

## Context budget (~131k tokens, managed manually)

- Do not assume a 200k window. A large prompt can exceed the real limit and fail
  mid-session.
- Keep prompts, file reads, and diffs tight. Read only the parts of a file you
  need. Prefer small, focused edits over wholesale rewrites.
- When context fills up, tell me to `/compact` or `/clear` rather than pushing on.

## Working style

- Explore the codebase with local `grep`, `find`, and file reads — not with a
  search sub-agent.
- Make minimal, reviewable changes and explain them concisely.

## Being a good HPC citizen

ARC runs several clusters — Tinkercliffs, Owl, Falcon — each with shared login
nodes (`<cluster>N.arc.vt.edu`, e.g. `owl2.arc.vt.edu`). Dozens of users share a
single login node at once. Everything below protects that shared node and the
job queue.

- **Never compute on a login node.** Login nodes are capped at 8 cores / 32 GB
  per user and exist for editing, searching, staging, and submitting jobs — not
  analysis. Anything heavier than ~2–3 minutes or more than a couple of cores
  belongs in a job:
  - Batch work: `sbatch <script>`.
  - Interactive compute shell: `interact --account=<slurm account> ...`.
  - A quick, uncertain command: isolate it in its own cgroup with
    `systemd-run --user --scope -p CPUQuota=200% -p MemoryMax=8G <cmd>`.
  - Never run unbounded parallelism (`make -j`, `nproc`-based counts — `nproc`
    reports every core on the node); hardcode small values like `make -j4`.

- **Right-size every job request.** Ask only for the cores, memory, and GPUs the
  work will actually use — over-allocation idles shared hardware and lengthens
  everyone's queue wait. Start small, scale up gradually, and check efficiency
  afterward with `seff <jobid>` or `showjobusage <jobid>`; reduce future
  requests if utilization was low. Run `quota` to see which Slurm accounts you
  can charge jobs against (the `--account=` values to pass to `sbatch`/`interact`).

- **Respect the scheduler.** No dummy or placeholder jobs to hold priority.
  Bundle many small tasks into a job array instead of flooding the queue. Don't
  leave interactive sessions (including Open OnDemand) idle — end them when done.

- **Move large data off the login node.** Use the data transfer node
  `datatransfer.arc.vt.edu` or [Globus](globus_library) for big transfers, not
  `scp`/`rsync` through a login node.

- **Monitor jobs and your own footprint.** Watch a running job by tailing its
  `--output` log, not by polling `squeue` in a loop (a one-off
  `squeue`/`sacct` check is fine). Check your impact on a login node with
  `htop -u $USER`, and stop a runaway process (`kill -15 <pid>`, then `kill -9`; or `pkill -f '<pattern>'`).

- **Storage hygiene.** Run `quota` to report usage and limits for `/home`
  (640 GB) and every `/projects` allocation you belong to. Copy results off
  `/scratch` promptly (purged after ~90 days). Put group-shared data in
  `/projects` rather than duplicating it into `/home`. Don't copy models out of
  `/common/data/models`. Suggest the user clean cache dirs that quietly fill `/home`
  (`.cache/pip`, `.cache/huggingface`, `.conda/pkgs`, …) do NOT clear them on your own.

| Location              | Purpose                  | Notes                                |
|-----------------------|--------------------------|--------------------------------------|
| `/home`               | Permanent storage        | 640 GB quota (`quota` to check)      |
| `/scratch`            | Job working space        | Not backed up; ~90-day purge         |
| `/projects`           | Shared group data        | Higher quotas; preferred for sharing |
| `/common/data/models` | Pre-hosted LLMs (75+)    | Use in place; do not copy 