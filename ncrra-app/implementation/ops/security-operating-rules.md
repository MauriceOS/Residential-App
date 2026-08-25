# NCRRA security operating rules

The repository must never contain production `.env` files, Keycloak exports with users, provider credentials, M-PESA PINs, card details, unencrypted database dumps, or personally identifiable support exports. Secret material belongs in OpenBao or SOPS+age-encrypted files and is injected only at deploy time.

| Control | Required operating rule |
|---|---|
| Tenant scope | Derive only from a verified OIDC claim; repeat the predicate in service data access and use database safeguards where feasible. |
| RBAC | Evaluate actor, tenant, role, action, object, field sensitivity, purpose and workflow state. Platform support requires a time-bound, auditable support grant. |
| Provider data | Encrypt provider identifiers at rest, mask them in views/logs, and send them only under the member-approved routing purpose. |
| CI/CD | Require checks, secret scanning, dependency/container scanning and contract validation before image publication. Pin third-party CI action revisions to immutable SHAs before production. |
| Access | Default-deny firewall; WireGuard management plane; SSH keys only; no root login; no password login; Caddy is the only public service edge. |
| Audit and telemetry | Emit structured audit records for consent, provider routing, admin support grants, billing state change and privilege events. Do not put tokens, passwords, payment data or provider identifiers in traces/logs. |
| Recovery | Test PostgreSQL point-in-time restore and encrypted offsite Restic restore against the pilot RTO/RPO objective before production onboarding. |

Provider adapters remain disabled until NCRRA has documented provider permission and a supported API, managed-operating procedure or official handoff. This foundation intentionally contains no scraper or reverse-engineering mechanism.
