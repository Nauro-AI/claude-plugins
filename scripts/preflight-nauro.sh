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
# the binary is missing Claude can surface the fix to the user proactively. The
# hook cannot (and does not try to) install anything or block the session.
#
# When the binary IS present, one more silent first-run gap remains: a git repo
# with no Nauro project, where the MCP tools error until `nauro adopt` runs.
# In that case the hook emits a one-line nudge for Claude to surface when
# relevant. Everywhere else (non-git directories, adopted repos, worktrees of
# adopted repos) it prints nothing, to avoid per-session noise.

if command -v nauro >/dev/null 2>&1; then
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  [ -n "$repo_root" ] || exit 0
  [ -f "$repo_root/.nauro/config.json" ] && exit 0

  registry="${NAURO_HOME:-$HOME/.nauro}/registry.json"
  if [ -f "$registry" ]; then
    grep -Fq "\"$repo_root\"" "$registry" && exit 0
    # Linked worktrees register under the main worktree's path.
    common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    if [ -n "$common_dir" ]; then
      main_root=$(dirname "$common_dir")
      [ -f "$main_root/.nauro/config.json" ] && exit 0
      grep -Fq "\"$main_root\"" "$registry" && exit 0
    fi
  fi

  cat <<'EOF'
[nauro plugin] The `nauro` CLI is installed but this repository has no Nauro
project, so the Nauro MCP tools will error here. If the user wants Nauro's
decision tracking in this repo, suggest running `nauro adopt` from the repo
root, then restarting the session.
EOF
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
