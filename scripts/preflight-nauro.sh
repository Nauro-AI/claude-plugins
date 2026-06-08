#!/bin/sh
# Preflight check for the Nauro plugin's MCP server dependency.
#
# The plugin's MCP server is `nauro serve --stdio`, which runs the external
# `nauro` CLI (installed separately via `uv tool install nauro`). When that binary
# is absent from PATH, the MCP server fails at spawn time with a bare
# "spawn nauro ENOENT" buried in /mcp and the /plugin Errors tab — a silent,
# non-actionable failure on first run.
#
# This is a SessionStart hook: its stdout is added to Claude's context, so when
# the binary is missing Claude can surface the fix to the user proactively. It
# prints nothing when `nauro` is present, to avoid per-session noise. The hook
# cannot (and does not try to) install anything or block the session.

if command -v nauro >/dev/null 2>&1; then
  exit 0
fi

cat <<'EOF'
[nauro plugin] The `nauro` CLI is not on PATH, so the Nauro MCP server
(`nauro serve --stdio`) cannot start. Tell the user to install it, then restart:

    uv tool install nauro

(`uv` fetches its own Python; or use `pipx install nauro` if Python 3.10+ is already set up.)

After installing, restart Claude Code (or run /reload-plugins). Docs: https://nauro.ai
EOF

exit 0
