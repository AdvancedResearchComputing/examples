# Decision models with Slurm

Run a GGUF decision model with llama.cpp on one ARC GPU. The job reads `request.json`, saves the answers, and stops the server.

## When to use a decision model

Use a System One decision model when you need a structured judgment about an input: a category, a yes/no probability, or a score. Common uses are:

- Labeling research abstracts, survey responses, or other datasets.
- Filtering documents for relevance before further analysis.
- Routing messages or screening content in an automated workflow.

You define the possible answers; the model returns decisions and probabilities rather than a written response. Check accuracy on representative examples before automating decisions.

**Try ARC's hosted API first** if you want to use a decision model without managing a GPU job. See the [decision-model overview](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html#decision-models), [API limits](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html#decisions), [example request](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html#decisions-example), and [dataset-labeling example](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html#labeling-a-dataset-with-a-decision-model).

Use the Slurm example below when you need to run your own compatible GGUF model or control its GPU resources and server settings. The hosted API requires your API key; this Slurm example does not.

## 1. Get a model

You can a download GGUF in any directory or better use this example below (/models), this example uses D3-mini Q8_0 (about 5.16 GB) from hugging face.

```bash
ssh falcon2.arc.vt.edu
cd ~/decision-models
mkdir -p models
curl -fL --retry 3 -o models/d3-mini.gguf \
  https://huggingface.co/ggml-org/vllm-d3-mini-GGUF/resolve/main/vllm-d3-mini-Q8_0.gguf
```

Follow the model's terms, and compare `sha256sum models/d3-mini.gguf` with the current checksum on the [Hugging Face file page](https://huggingface.co/ggml-org/vllm-d3-mini-GGUF/blob/main/vllm-d3-mini-Q8_0.gguf).

## 2. Submit on Falcon

Keep these files together, and submit from their directory:

```text
decision-models/
├── README.md
├── run.sh
├── request.json
└── models/
    └── d3-mini.gguf
```

From a Falcon login session:

```bash
cd ~/decision-models
sbatch -A <slurm_allocation_name> run.sh "$PWD/models/d3-mini.gguf"
```

Replace `<slurm_allocation_name>` with your Slurm allocation account. `run.sh` selects A30 and loads the CUDA 12 module automatically. Pass a different GGUF's full path to change models. The example is text only, with a 4096-token context and processing batch; D3's complete prompt, including questions and options, must fit.

## 3. Check results

With your job ID , you check some info about the job:

```bash
squeue -j JOB_ID
sacct -j JOB_ID --format=JobID,State,ExitCode,Elapsed
cat results/JOB_ID/response.json
```

Look for `COMPLETED` and `0:0`. If the job fails, check `decision-JOB_ID.err` and `results/JOB_ID/server.log`.

## Change the questions

Edit `state` and `questions` in `request.json`; keep `model` as `local-decision`.

| Type | Returns |
|---|---|
| `choice` | One category and option probabilities |
| `noul` | Probability of yes, from 0 to 1 |
| `score` | A fractional, zero-based scale position; read its `legend` |

The synthetic research summary example should select `energy`, assign a high probability to `reports-results`, and score relevance near index `3`. These are expected results, not a verified run of this new request. Decisions can be incorrect; the model does not verify the study's claims.

See [ARC's llama.cpp guide](https://docs.arc.vt.edu/ai/031_llama.cpp.html) and the [official decision-model collection](https://huggingface.co/collections/ggml-org/decision-models).
