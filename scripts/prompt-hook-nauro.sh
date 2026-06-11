#!/bin/sh
# Guard wrapper for the Nauro advisory UserPromptSubmit hook.
#
# `nauro hook user-prompt-submit` surfaces decisions related to the submitted
# prompt as non-blocking advisory context (hookSpecificOutput.additionalContext).
# It is fail-open end to end: it exits 0 with empty output when the repo has no
# Nauro project, when nothing clears the relevance floor, or on any internal
# error, so it never blocks a turn.
#
# This wrapper adds the one guard the CLI cannot provide for itself: when the
# `nauro` binary is missing from PATH, exit silently instead of failing the
# hook on every prompt. The SessionStart preflight already surfaces the install
# message once per session.

command -v nauro >/dev/null 2>&1 || exit 0
exec nauro hook user-prompt-submit
