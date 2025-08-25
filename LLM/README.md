# Artificial Intelligence

## Large Language Models

ARC offers Large Language Models (LLMs) for research. There are three main ways researchers can use LLMs in ARC:

- [https://llm.arc.vt.edu](https://llm.arc.vt.edu) offers a no-effort web interface for a LLM. Users can use this tool for casual queries. Researchers should not use this tool for [high-risk data](https://it.vt.edu/content/dam/it_vt_edu/policies/Virginia-Tech-Risk-Classifications.pdf). It does not offer API access. ARC will continously update it to run the best performing model publicly available from [Hugging Face](https://huggingface.co/). The inference runs on GPUs within the ARC infrastructure. No data is sent to any 3rd party outside of the university. Data, prompts, and logs are preserved within the user's space. Access is restricted through the VT network or VPN. It does not require to have an account with ARC.

- [https://ood.arc.vt.edu](https://ood.arc.vt.edu) offers a dedicated LLM via Open OnDemand. Users can use this tool for intensive queries. It offers web and API access secured via tokens using the OpenAI API. Users can select their preferred model to run from a list of models publicly available on [Hugging Face](https://huggingface.co/). The inference runs on GPUs within the ARC infrastructure. No data is sent to any 3rd party outside of the university. Data, prompts, and logs are preserved within the user's space. Access is restricted through the VT network or VPN. It requires to have an account with ARC and a compute allocation.

- Advanced custom development via personalized Slurm scripts. Users can download any software to their user directory or run centrally-installed software (e.g. vLLM and Ollama) combined with custom Slurm scripts. Models downloaded from [Hugging Face](https://huggingface.co/) are available at ```/common/data/models/```. Access is restricted through the VT network or VPN. It requires to have an account with ARC and a compute allocation. An example is provided below.

### Running your own LLM using vLLM

The following example includes a Slurm script launches a vLLM instance running the model `Qwen3-32B` using 2 NVIDIA L40s GPUs on the Falcon cluster. Specifications include a job duration limited to 1 day, the model listens on port `8000`, and the OpenAI API endpoint key is `a3b91d38-6c74-4e56-b89f-3b2cfd728d1a`. You should adjust the settings to select the model, number of GPUs, context length, port, and API key you need. Additionally, before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

Run the following commands once you have logged into the Falcon cluster.
``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/LLM
sbatch myscript.sh
```

Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
Once the job runs, please allow a few minutes for the model to spin up. Once the endpoint is ready, the log file will indicate.

```
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

At this point, you can use the REST OpenAI API to submit queries. Please note the compute node where the instance is running (see `squeue`). In this example, the node is `fal036`, the port is `8000`, and the API key is `a3b91d38-6c74-4e56-b89f-3b2cfd728d1a`. Therefore, the following query will work from anywhere within the Falcon cluster.

```
curl -v http://fal036:8000/v1/completions   -H "Content-Type: application/json"   -H  "Authorization: Bearer a3b91d38-6c74-4e56-b89f-3b2cfd728d1a"   -d '{
    "prompt": "This is a cake recipe:\n\n1.",
    "max_tokens": 200,
    "temperature": 1,
    "top_p": 0.9,
    "seed": 10
  }'
```

If you wish to connect sofware running on your computer to the LLM running on the compute node of the cluster, you must run SSH port forwarding to redirect the network traffic from your computer to the compute node via the login node. For example:

```
ssh -N -L 8000:fal036:8000 user@falcon2.arc.vt.edu
```

At this point, you can use the REST OpenAI API to submit queries via `localhost` on your computer.

```
curl -v http://localhost:8000/v1/completions   -H "Content-Type: application/json"   -H  "Authorization: Bearer a3b91d38-6c74-4e56-b89f-3b2cfd728d1a"   -d '{
    "prompt": "This is a cake recipe:\n\n1.",
    "max_tokens": 200,
    "temperature": 1,
    "top_p": 0.9,
    "seed": 10
  }'
```
