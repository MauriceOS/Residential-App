# NCRRA provider agreement readiness gate

This is a working implementation checklist, not a signed contract or legal advice. Every provider entry remains technically disabled until the platform owner records an approved agreement reference and a security owner validates the integration configuration.

| Gate | Evidence required before `enabled: true` | Technical outcome |
|---|---|---|
| Commercial and legal authority | Signed API, distribution or managed-operations agreement with the provider | Provider ID can be reviewed for activation |
| Permitted purpose | Agreed member purpose, action types, data fields, retention and deletion obligations | Adapter can validate an action purpose |
| Interface | Documented API/official webhook, sandbox and service limits; or an approved managed handoff procedure | Adapter mode may be `documented_api` or remain a managed/official handoff |
| Secrets and identity | Vault reference, credential rotation owner, IP/network requirements and webhook verification method | Runtime may resolve a secret reference; the secret is never committed |
| Operational ownership | Named NCRRA owner, escalation route, support model and reconciliation process | Adapter readiness may become healthy |
| Security validation | Threat model, log masking, retry/idempotency review, test evidence and approval | Enablement pull request can be approved |

No gate authorizes scraping, reverse engineering, hidden browser automation or reuse of a consumer mobile channel. KPLC begins in managed-operations mode; SGR and Jambojet remain official handoffs unless and until formal distribution or partner rights are confirmed.
