# Client-Side Semantic Conventions for OpenTelemetry

A federated OpenTelemetry semantic convention registry for instrumentation that target
client-side applications running on mobile phones, browsers, desktop computers, or
any other end-user device.

This registry follows the federated model established by [OTEP 4815](https://github.com/open-telemetry/opentelemetry-specification/blob/main/oteps/4815-semantic-conventions-schema-v2.md) and augments
general OTel semantic conventions that are mostly defined with backend applications in
mind with ones that are unique to and common amongst client-side application platforms.

It contains YAMLs that defines the semantic conventions for namespaces that it owns
and the associated Markdown files for those conventions. It will host and publish
version-stamped schema URLs representing the public-facing surface of the manifest,
but it does not generate or publish language-specific binaries that make the hosted
conventions consumable in instrumentation.

## Structure

Semantic conventions owned by this registry are defined in YAML files under `/model`.
Using templates defined in `/templates`, Weaver-based tooling will crawl through all
the files in that directory and create the appropriate documentation in `/docs`.

The conventions by which the files and directories within `/model` are organized is
under discussion.

## Roadmap

We are still in the process of bootstrapping this repo. More details about the roadmap
will follow. If you are interested in participating, join the
[#otel-client-side-telemetry](https://cloud-native.slack.com/archives/C0239SYARD2)
Slack channel or attend the [Client Instrumentation SIG meeting](https://github.com/open-telemetry/community/blob/main/sigs.md#client-instrumentation).

## Maintainers

- [Hanson Ho](https://github.com/bidetofevil), Embrace (Palo Alto Networks)
- [Jared Freeze](https://github.com/overbalance), Embrace (Palo Alto Networks)
- [Martin Kuba](https://github.com/martinkuba), Grafana

For more information about the maintainer role, see the [community repository](https://github.com/open-telemetry/community/blob/main/guides/contributor/membership.md#maintainer).
