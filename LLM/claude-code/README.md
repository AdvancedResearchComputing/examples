# Claude Code — ARC Examples

Examples and configuration files for using Claude Code locally with ARC's hosted LLMs.

## Contents

- `CLAUDE.md` — Agent instructions file for Claude Code. Drop this into your local project folder before starting a session. It tells the agent about ARC's context limits, unavailable proxy features, SSH safety rules, and ARC expectations.

## Usage

```bash
mkdir -p ~/my-arc-project
cd ~/my-arc-project
curl -o CLAUDE.md https://raw.githubusercontent.com/AdvancedResearchComputing/examples/master/LLM/claude-code/CLAUDE.md
claude --model Kimi-K2.6
```

## Further reading

- [ARC Coding Agents and IDEs documentation](https://docs.arc.vt.edu/ai/040_coding_agents.html)
- [ARC LLM API](https://docs.arc.vt.edu/ai/011_llm_api_arc_vt_edu.html)