# NCRRA Flutter member app foundation

This directory is the **production mobile track**. It reproduces the approved React prototype’s visual system in Flutter rather than replacing the existing React prototype. The core Flutter screens currently implemented in code are the Home, registration welcome, profile set-up, consent, registration completion and searchable, filterable ticket dashboard journeys.

The next screen modules should follow the same primitives in `lib/src/core/design`: service request, issue details, review request, ticket timeline full screen, membership, annual contribution, payment confirmation, receipt, community, benefits, notifications and account. The exact construction, names, icon mapping, frames and interaction requirements are in `../../../../figma_reproduction_prompt.md`.

## Setup after Flutter/Dart is available

Run `flutter pub get`, place the approved NCRRA mark at `assets/brand/ncrra_mark.png`, then run `flutter run`. The current sandbox does not include the Flutter/Dart SDK, so this handoff has not been compiled in this environment. It deliberately contains no provider API secret, tenant identifier or payment credential; authentication and tenant context must be issued server-side through the OIDC/BFF boundary.

## Guardrails

The client calls only platform APIs through `NcrraApiClient`. It never queries service-owned databases, derives tenant identity, stores payment PINs, or calls a provider adapter directly. The API layer must derive the actor and tenant from the verified access token and enforce field-, purpose- and workflow-aware authorization.
