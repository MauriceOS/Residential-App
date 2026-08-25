# NCRRA release and DevSecOps policy

The CI workflow is a minimum control, not the whole release process. A protected `main` branch requires successful web checks, contract validation, secret scanning, filesystem vulnerability scanning and human review. Release images must be created by CI, versioned immutably, scanned again after build, signed, and promoted by digest—not rebuilt ad hoc on the VPS.

| Stage | Required evidence | Block condition |
|---|---|---|
| Change | Reviewed pull request with linked ticket/decision | Missing review or undocumented boundary change |
| Verify | Type check, production build, OpenAPI/event schema parse | Test or contract failure |
| Secure | Secret scan, dependency/container scan, IaC configuration scan | Unresolved high/critical issue or exposed secret |
| Release | Immutable image digest, SBOM, signature and migration plan | Mutable tag-only image or unreviewed migration |
| Deploy | Backup confirmation, canary/smoke test, observability check | Failed health check or missing rollback plan |
| Operate | Alert response, audit review, restore exercise | Unowned alert or expired support access |

Before production, replace floating GitHub Action references with reviewed commit SHAs and store image signing identities, registries and deployment credentials in the managed secret system. No credential should enter source control, mobile binaries or build logs.
