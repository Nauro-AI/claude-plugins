# Changelog

All notable changes to the Nauro Claude Code plugin distribution are documented
here. This tracks the **plugin packaging**, not the `nauro` CLI itself — see the
CLI's own release notes for runtime changes. The plugin's `version` in
`plugin.json` is pinned in lockstep to the published `nauro` CLI on PyPI (CI
gate: `version-sync`), so version numbers here mirror CLI releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.13.0]

### Changed

- Pinned `plugin.json` to `nauro` 1.13.0 in lockstep with the CLI release
  (fail-open post-commit handling and the shared identifier validators in
  nauro-core).
- Re-render under 1.13.0 is byte-identical: the release changes no agent
  guidance, so the four bundled agents are unchanged.

## [1.12.0]

### Changed

- Pinned `plugin.json` to `nauro` 1.12.0 in lockstep with the CLI release
  (which adds the `nauro repair` command and doctor's supersede-orphan
  detection).
- Re-render under 1.12.0 is byte-identical: the release changes no agent
  guidance, so the four bundled agents are unchanged.

## [1.11.0]

### Changed

- Pinned `plugin.json` to `nauro` 1.11.0 in lockstep with the CLI release,
  catching up from 1.2.0 across the CLI's 1.3–1.11 releases (the lockstep
  gate only runs on push, so the lag surfaced at the next sync rather than
  in CI).
- Re-rendered all four bundled agents to the 1.11.0 render. The visible
  changes land in `nauro-planner` and `nauro-tech-lead`: related-decision
  hits now arrive with inline triage headers (decision type, confidence,
  supersession links, and a lede), so the guidance drops the per-hit
  header-lookup step and directs full reads only at decisions the agent
  reasons about; the tech-lead keeps its read-everything mandate.

## [1.2.0]

### Changed

- Pinned `plugin.json` to `nauro` 1.2.0 in lockstep with the CLI release.
- Re-rendered the bundled `nauro-planner`, `nauro-executor`, and
  `nauro-reviewer` agents to match the 1.2.0 render: the PR-description
  guidance moved to the three-core-section template (Why / What changed /
  Test plan, with Risk and Deferred as conditional headings).

## [1.1.0]

### Changed

- Pinned `plugin.json` to `nauro` 1.1.0 in lockstep with the CLI release. The
  bundled `nauro-*` agents byte-match the 1.1.0 render (`nauro render-plugin .
  --check` passes), so no agent change was needed — only the version pin.

## [0.13.1]

### Fixed

- The bundled agents now grant the plugin MCP namespace
  (`mcp__plugin_nauro_nauro__*`) in their tools allowlists, mirroring the
  CLI-setup namespace. Before this, on a plugin-only install the agents could
  not reach the plugin's own MCP server: subagent allowlist mismatches drop
  tools silently, so the planner ran its doctrine triage with no
  `check_decision` available. Rendered from the 0.13.1 CLI sources
  (`nauro render-plugin . --check` passes).

## [0.13.0]

### Changed

- Pinned `plugin.json` to `nauro` 0.13.0 in lockstep with the CLI release.
- The bundled `nauro-*` agents now declare `model: inherit` instead of pinning
  Opus, so they run on the parent session's model (rendered from the 0.13.0
  CLI sources; `nauro render-plugin . --check` passes).
- Installs updating from a pre-hook 0.12.7 install also pick up the advisory
  UserPromptSubmit hook and the preflight `nauro adopt` nudge listed under
  0.12.7 below, which landed in the repo after that version's first installs.
- README and manifest descriptions now say the plugin covers Claude Code and
  Cowork: the desktop app installs the same marketplace artifact and runs the
  bundled agents and hooks in Cowork.

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
