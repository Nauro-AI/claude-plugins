# Changelog

All notable changes to the Nauro Claude Code plugin distribution are documented
here. This tracks the **plugin packaging**, not the `nauro` CLI itself — see the
CLI's own release notes for runtime changes. The plugin's `version` in
`plugin.json` is pinned in lockstep to the published `nauro` CLI on PyPI (CI
gate: `version-sync`), so version numbers here mirror CLI releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.12.7]

### Added

- The advisory UserPromptSubmit hook (`nauro hook user-prompt-submit`) is now
  bundled by default via a guard wrapper (`scripts/prompt-hook-nauro.sh`):
  decisions related to each prompt surface as non-blocking context, with no
  agent invocation required. The wrapper exits silently when the `nauro`
  binary is missing; the hook itself injects nothing when the repo has no
  Nauro project or when nothing clears the relevance floor. On the CLI this
  hook remains opt-in (`nauro setup --with-hooks`); installing both duplicates
  the surfaced context, so use one or the other.
- The SessionStart preflight now also covers the second silent first-run gap:
  when the `nauro` CLI is present but the session's repo has no Nauro project,
  it suggests `nauro adopt` (previously it only handled the missing-binary
  case).

### Changed

- Pinned `plugin.json` to `nauro` 0.12.7 in lockstep with the CLI release. The
  bundled `nauro-*` agents byte-match the 0.12.7 render (`nauro render-plugin .
  --check` passes), so no agent change was needed.

## [0.12.5]

### Changed

- Pinned `plugin.json` to `nauro` 0.12.5 in lockstep with the CLI release. The
  bundled `nauro-*` agents byte-match the 0.12.5 render (`nauro render-plugin .
  --check` passes), so no agent change was needed.

## [0.12.4]

### Changed

- Install guidance now leads with `uv tool install nauro` (pipx/pip kept as a
  fallback) across the `marketplace.json` / `plugin.json` descriptions, the
  README prerequisite, and the `SessionStart` preflight hook's missing-binary
  message. `uv tool install` provisions its own Python, so the prerequisite no
  longer assumes a working Python 3.10+ already on the user's PATH.
- Pinned `plugin.json` to `nauro` 0.12.4 to clear the `version-sync` lockstep
  gate (the plugin had drifted behind the published CLI). The bundled `nauro-*`
  agents byte-match the 0.12.4 render, so no agent change was needed.

## [0.12.1]

### Changed

- Pinned `plugin.json` to `nauro` 0.12.1 to clear the `version-sync` lockstep
  gate (the plugin had drifted a release behind the published CLI). The bundled
  `nauro-*` agents are byte-identical to the 0.12.1 render, so no agent change
  was needed — only the version pin.
- CI (`version-sync`) now also runs `claude plugin validate . --strict`, gating
  the same check the community-directory review pipeline runs.

### Added

- Apache-2.0 `LICENSE` and a `license` field in `plugin.json`.
- Top-level `description` in `marketplace.json` (clears the strict-validator
  warning ahead of any directory submission).
- `SessionStart` preflight hook (`hooks/hooks.json` +
  `scripts/preflight-nauro.sh`): when the external `nauro` CLI is missing from
  PATH, it surfaces an actionable "run `pipx install nauro`" message instead of
  letting the MCP server fail silently with `spawn nauro ENOENT`.
- `.gitignore` to keep local dev artifacts out of the install cache (the
  marketplace entry uses `source: "./"`, which ships the whole repo root).
- README "Privacy & data" section linking the privacy policy
  (https://nauro.ai/privacy) and an "Example prompts" section — pre-submission
  requirements for the community directory (Software Directory Policy 3.A / 3.E).

## [0.11.1]

### Added

- The four `nauro-*` workflow subagents (`nauro-planner`, `nauro-executor`,
  `nauro-reviewer`, `nauro-tech-lead`), rendered from the canonical CLI sources
  and CI-verified byte-identical to the pinned published `nauro` render.

## [0.11.0]

### Added

- Initial plugin scaffold: `marketplace.json`, `plugin.json`, a static stdio
  `.mcp.json` wiring `nauro serve --stdio`, and the `version-sync` lockstep gate
  against the published `nauro` CLI on PyPI.
