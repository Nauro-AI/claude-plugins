# Nauro — Claude Code plugin

The Claude Code plugin distribution for [Nauro](https://nauro.ai), the decision
system for AI coding agents. This plugin is an **additive front door for the
Claude surfaces**: it wires Nauro's MCP server into Claude Code and Cowork
(the desktop app's agent mode) through the marketplace, with version-pinned
updates.

It does not replace the CLI. `nauro setup all` remains the canonical installer
across Claude Code, Cursor, and Codex; this plugin covers the Claude Code and
Cowork surfaces only.

## Prerequisite

The plugin declares the Nauro MCP server (`nauro serve --stdio`), which runs the
`nauro` binary. Install it first:

```
uv tool install nauro
```

(or `pipx install nauro` if you already have Python 3.10+). If `nauro` is not on
your PATH when you enable the plugin, the MCP server will fail to connect until
the binary is installed and the session is restarted.

## Install

Add the marketplace and install the plugin:

```
/plugin marketplace add Nauro-AI/claude-plugins
/plugin install nauro@nauro-ai
```

Or persist it in your settings (`~/.claude/settings.json`, or a project
`.claude/settings.json`):

```json
{
  "extraKnownMarketplaces": {
    "nauro-ai": {
      "source": { "source": "github", "repo": "Nauro-AI/claude-plugins" }
    }
  }
}
```

## What it bundles

- The Nauro stdio MCP server (`.mcp.json`).
- The four `nauro-*` workflow subagents (`agents/`): `nauro-planner`,
  `nauro-executor`, `nauro-reviewer`, `nauro-tech-lead`.
- An advisory UserPromptSubmit hook (`scripts/prompt-hook-nauro.sh`) that
  surfaces decisions related to each prompt as non-blocking context. It runs
  locally against the project store, injects nothing when the repo has no Nauro
  project or when nothing clears the relevance floor, and never blocks a turn.
- A SessionStart preflight hook (`scripts/preflight-nauro.sh`) that, when the
  `nauro` CLI is missing from PATH, surfaces a `uv tool install nauro` message
  so the stdio MCP server's first-run `spawn nauro ENOENT` isn't silent. When
  the CLI is present but the session's repo has no Nauro project, it suggests
  `nauro adopt` instead.

Skills are installed by the CLI, not the plugin: `nauro-adopt` (always) plus the
opt-in `nauro-ship-task`, `nauro-handoff`, and `nauro-context` (via
`nauro adopt --with-skills`).

Install the plugin **or** run `nauro setup all --with-subagents`, not both: the
bundled agents are byte-identical either way, but having both makes the active
source ambiguous. The same applies to `nauro setup --with-hooks`: the plugin
already wires the advisory prompt hook, so adding it via setup as well surfaces
each related decision twice. For full control of agent and hook configuration,
use the CLI.

## Example prompts

Once installed, the bundled subagents and MCP server work from natural prompts:

- "Use @nauro-planner to plan adding rate limiting to our API." — the planner
  classifies doctrine risk and checks recorded decisions before proposing.
- "Have @nauro-reviewer review this diff against our recorded decisions." — it
  flags conflicts with established doctrine, not just code issues.
- "Before we adopt DynamoDB, check our decision log for anything that conflicts."
  — runs `check_decision` so the agent sees prior context before it acts.

## Versioning

`plugin.json`'s `version` tracks the published `nauro` CLI version one-to-one.
CI (`version-sync`) fails if they drift, so an installed plugin never lags a
released CLI.

If a released version is not showing up as an update, refresh the marketplace
clone first. Claude Code caches marketplace repos locally and does not always
re-fetch them before checking for updates:

```
/plugin marketplace update nauro-ai
/plugin update nauro@nauro-ai
```

(or the same subcommands under `claude plugin` in a terminal).

## Privacy & data

Nauro is local-first: your project context lives as Markdown in `~/.nauro/`, and
your source code never leaves your machine. This plugin's MCP server runs locally
(`nauro serve --stdio`) and works fully offline with no account. The `nauro` CLI
sends anonymous usage telemetry, which you can disable with `NAURO_TELEMETRY=0`
(or `nauro telemetry disable`). Optional hosted sync (separate and opt-in) stores
agent-authored project context — decisions, state, questions, snapshots — plus
your account email and an opaque account id; never your source code, file paths,
repository names, or conversation content.

Full privacy policy: https://nauro.ai/privacy
