# Thin wrapper over scripts/ so this registry answers to the same commands as the
# other OpenTelemetry semantic-convention registries (core, genai, mainframe).
# The scripts remain the implementation and are what CI runs directly; these
# targets exist so `make check-policies` works as expected.
#
# Weaver and OPA are pinned in versions.env — `make install-weaver` and
# `make install-opa` install those versions.

SHELL := /usr/bin/env bash

.PHONY: check-policies test test-policies install-weaver install-opa clean help

# Validate the model: schema, dependency resolution, shared OTel policy pack and
# the local policies.
check-policies:
	scripts/check.sh

# Every test suite this repo owns.
test: test-policies

# Unit-test the local rego policies. Pure OPA: no weaver, no network. The cases
# worth covering involve definitions inherited from a dependency, which the real
# model never produces because it declares no `imports` block.
test-policies:
	scripts/test-policies.sh

# Install the weaver version pinned in versions.env into ~/.local/bin.
install-weaver:
	.github/actions/setup-weaver/install-weaver.sh

# Install the OPA version pinned in versions.env into ~/.local/bin.
install-opa:
	.github/actions/setup-opa/install-opa.sh

# Remove build output only.
clean:
	rm -rf .build

help:
	@echo "check-policies  validate the model (schema + dependencies + policies)"
	@echo "test            run every test suite"
	@echo "test-policies   unit-test the local rego policies"
	@echo "install-weaver  install the weaver version pinned in versions.env"
	@echo "install-opa     install the OPA version pinned in versions.env"
	@echo "clean           remove build output"
