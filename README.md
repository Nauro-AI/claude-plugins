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

The `nauro-*` workflow subagents are rendered from the CLI sources and added in
a later release. Skills (`nauro-adopt`, `nauro-ship-task`) are installed by the
CLI, not the plugin — standalone skills are auto-discovered and keep their short
names.

## Versioning

`plugin.json`'s `version` tracks the published `nauro` CLI version one-to-one.
CI (`version-sync`) fails if they drift, so an installed plugin never lags a
released CLI.
