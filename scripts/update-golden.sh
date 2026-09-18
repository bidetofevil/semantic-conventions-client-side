#!/usr/bin/env bash
# Refreshes the golden files that scripts/test-templates.sh compares against.
# Run this when a template change intentionally alters the generated output, then
# review the diff under templates_test/golden/ before committing it.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

GOLDEN_DIR="${REPO_ROOT}/templates_test/golden"

rm -rf "${GOLDEN_DIR}"
weaver registry generate \
  -r "${REPO_ROOT}/templates_test/fixture" \
  --v2 \
  --templates "${REPO_ROOT}/templates" \
  markdown \
  "${GOLDEN_DIR}"
echo "refreshed ${GOLDEN_DIR}"
