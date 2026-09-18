#!/usr/bin/env bash
# Regression test for the docs templates under templates/registry/markdown/.
#
# Requires network access to resolve the fixtures' dependencies.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

FIXTURE_DIR="${REPO_ROOT}/templates_test/fixture"
GOLDEN_DIR="${REPO_ROOT}/templates_test/golden"
ACTUAL_DIR="${REPO_ROOT}/.build/test-docs"
LOG_FILE="${REPO_ROOT}/.build/test-templates.log"

mkdir -p "${REPO_ROOT}/.build"
rm -rf "${ACTUAL_DIR}"

weaver registry generate \
  -r "${FIXTURE_DIR}" \
  --v2 \
  --templates "${REPO_ROOT}/templates" \
  markdown \
  "${ACTUAL_DIR}" 2>&1 | tee "${LOG_FILE}"

# An import that stops matching upstream would silently remove the only coverage
# these filters have, so treat it as a failure rather than a warning.
if grep -q "matched nothing" "${LOG_FILE}"; then
  echo "error: a fixture import no longer matches anything upstream." >&2
  echo "The provenance filters are no longer exercised. Update the wildcards in" >&2
  echo "templates_test/fixture/fixture/imports.yaml to groups the pinned dependency exports." >&2
  exit 1
fi

if ! git --no-pager diff --no-index --exit-code "${GOLDEN_DIR}" "${ACTUAL_DIR}"; then
  echo "" >&2
  echo "error: generated docs do not match the golden files." >&2
  echo "If the change is intended, refresh them with:" >&2
  echo "    make update-golden" >&2
  exit 1
fi

echo "templates OK: fixture output matches templates_test/golden"
