# NCRRA pilot backup and restore operating procedure

The pilot target is **RPO 15 minutes and RTO 4 hours for core member services**, subject to the signed operations runbook and evidence from restore exercises. pgBackRest should ship PostgreSQL WAL and scheduled full/differential backups to an encrypted offsite repository. Restic should separately back up Caddy state, Keycloak configuration exports, Git-managed deployment configuration and encrypted secret manifests. Do not place raw provider credentials, plaintext `.env` files or direct member exports in offsite backup paths.

| Cadence | Mechanism | Evidence to retain |
|---|---|---|
| Every 15 minutes | PostgreSQL WAL archive through pgBackRest | Successful archive log and offsite repository check |
| Daily | Differential PostgreSQL backup | Backup manifest and checksum verification |
| Weekly | Full PostgreSQL backup and Restic configuration backup | Backup job result, immutable offsite retention status |
| Monthly | Restore to isolated environment | Timed result, integrity check, application smoke test, remediation actions |
| Before material release | Database migration dry run and backup verification | Change record and rollback decision |

## Restore sequence

1. Declare the incident and freeze deployments.
2. Build a clean, hardened replacement host with the Ansible bootstrap playbook.
3. Restore encrypted deployment configuration and recreate secrets from OpenBao/SOPS-managed material.
4. Restore PostgreSQL to the approved recovery point, validate service-owned databases, then start Keycloak and internal services.
5. Run identity, member scope, ticket search, contribution and notification smoke checks using non-production test accounts.
6. Re-enable the Caddy edge only after the incident commander accepts the validation evidence.
