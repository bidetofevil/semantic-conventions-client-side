#!/usr/bin/env bash
# Unit-tests the local rego policies under policies/ against policies_test/.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=../versions.env
source "${REPO_ROOT}/versions.env"
PINNED_OPA_VERSION="${OPA_VERSION#v}"

if ! command -v opa >/dev/null 2>&1; then
  echo "error: opa not found on PATH." >&2
  echo "Run .github/actions/setup-opa/install-opa.sh to install the pinned version," >&2
  echo "or 'make install-opa'." >&2
  exit 1
fi

INSTALLED_OPA_VERSION="$(opa version | awk '/^Version:/ { print $2 }')"
if [[ "${INSTALLED_OPA_VERSION}" != "${PINNED_OPA_VERSION}" ]]; then
  echo "warning: opa ${INSTALLED_OPA_VERSION} installed, but this repo pins ${PINNED_OPA_VERSION} (see versions.env)." >&2
fi

opa test --explain fails "${REPO_ROOT}/policies" "${REPO_ROOT}/policies_test"
