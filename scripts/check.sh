#!/usr/bin/env bash
# Validates the registry model: schema validation, resolution of upstream
# dependencies, and the shared OpenTelemetry policy pack (naming conventions,
# attribute type rules, stability requirements) plus this repo's local policies.
# Requires network access to fetch the dependencies pinned in
# model/manifest.yaml and the policy pack pinned in versions.env.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

# Shared OTel policy pack (URL/ref pinned in versions.env). Weaver resolves the
# pinned remote itself and caches it under ~/.weaver.
weaver registry check \
  -r "${REPO_ROOT}/model" \
  --v2 \
  --policy "${POLICY_REPO_URL}@${POLICY_REPO_REF}[policies/check]" \
  --policy "${REPO_ROOT}/policies/check/public-attribute-groups"
