# Nauro — Claude Code plugin

The Claude Code plugin distribution for [Nauro](https://nauro.ai), the decision
system for AI coding agents. This plugin is an **additive front door for the
Claude Code surface**: it wires Nauro's MCP server into Claude Code through the
marketplace, with version-pinned updates.

It does not replace the CLI. `nauro setup all` remains the canonical installer
across Claude Code, Cursor, and Codex; this plugin covers the Claude Code
surface only.

## Prerequisite

The plugin declares the Nauro MCP server (`nauro serve --stdio`), which runs the
`nauro` binary. Install it first:

```
pipx install nauro
```

If `nauro` is not on your PATH when you enable the plugin, the MCP server will
fail to connect until the binary is installed and the session is restarted.

## Install (pilot)

This marketplace is private during the pilot. Add it and install the plugin:

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
- A SessionStart preflight hook (`hooks/hooks.json` → `scripts/preflight-nauro.sh`)
  that, when the `nauro` CLI is missing from PATH, surfaces a `pipx install nauro`
  message so the stdio MCP server's first-run `spawn nauro ENOENT` isn't silent.

Skills are installed by the CLI, not the plugin: `nauro-adopt` (always) plus the
opt-in `nauro-ship-task`, `nauro-handoff`, and `nauro-context` (via
`nauro adopt --with-skills`).

Install the plugin **or** run `nauro setup all --with-subagents`, not both: the
bundled agents are byte-identical either way, but having both makes the active
source ambiguous. For full control of agent configuration, use the CLI.

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
