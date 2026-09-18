# Thin wrapper over scripts/ so this registry answers to the same commands as the
# other OpenTelemetry semantic-convention registries (core, genai, mainframe).
# The scripts remain the implementation and are what CI runs directly; these
# targets exist so `make check-policies` / `make generate-all` work as expected.
#
# Weaver and OPA are pinned in versions.env — `make install-weaver` and
# `make install-opa` install those versions.

SHELL := /usr/bin/env bash

.PHONY: all check-policies generate-docs generate-all test test-templates \
	test-policies update-golden install-weaver install-opa clean help

# Default: validate, then regenerate everything this repo owns.
all: check-policies generate-all

# Validate the model: schema, dependency resolution, shared OTel policy pack and
# the local policies.
check-policies:
	scripts/check.sh

# Regenerate the committed markdown under docs/.
generate-docs:
	scripts/generate-docs.sh

# Every regeneration this repo owns. CI checks that committed output matches this.
generate-all: generate-docs

# Every test suite this repo owns: the tooling that turns the model into docs and
# validates it. Deliberately NOT part of `all`, which validates and regenerates
# the model -- a different job. CI runs these as their own gated jobs; run this
# before pushing to find out locally instead.
test: test-templates test-policies

# Regression test for the doc templates: generates from a fixture registry that
# imports from a dependency and compares against templates_test/golden/. This is
# the only thing that exercises the provenance filters -- the real model has no
# `imports` block, so a broken filter leaves docs/ byte-identical.
test-templates:
	scripts/test-templates.sh

# Unit-test the local rego policies. Pure OPA: no weaver, no network. The cases
# worth covering involve definitions inherited from a dependency, which the real
# model never produces because it declares no `imports` block.
test-policies:
	scripts/test-policies.sh

# Refresh templates_test/golden/ after an intentional template change.
update-golden:
	scripts/update-golden.sh

# Install the weaver version pinned in versions.env into ~/.local/bin.
install-weaver:
	.github/actions/setup-weaver/install-weaver.sh

# Install the OPA version pinned in versions.env into ~/.local/bin.
install-opa:
	.github/actions/setup-opa/install-opa.sh

# Remove build output only. docs/ is generated but committed, so it is left
# alone — regenerate it with `make generate-all` instead.
clean:
	rm -rf .build

help:
	@echo "check-policies  validate the model (schema + dependencies + policies)"
	@echo "generate-docs   regenerate committed markdown under docs/"
	@echo "generate-all    run every regeneration this repo owns"
	@echo "test            run every test suite (templates + policies)"
	@echo "test-templates  check the doc templates against the golden fixture output"
	@echo "test-policies   unit-test the local rego policies"
	@echo "update-golden   refresh the golden files after an intended template change"
	@echo "install-weaver  install the weaver version pinned in versions.env"
	@echo "install-opa     install the OPA version pinned in versions.env"
	@echo "clean           remove build output"
