# NCRRA VPS-first DevSecOps baseline

This is the pilot deployment foundation for the approved Contabo/VPS-first direction. It is intentionally **not** a command to deploy production. Before deployment, run the Ansible hardening playbook on a newly provisioned host, configure DNS and TLS, provide approved secrets through OpenBao or SOPS+age, set offsite backup storage, and complete a security review.

The deployment uses Caddy as the only public HTTPS edge, PostgreSQL with separate service-owned databases, RabbitMQ for domain events and retry queues, Redis for bounded caching, Keycloak for OIDC, OpenTelemetry Collector for telemetry routing, Prometheus/Grafana/Loki for observability, and pgBackRest/Restic for backup. Internal services are not publicly exposed.

| Plane | Public exposure | Control |
|---|---|---|
| Caddy edge | TCP 80/443 only | TLS, request size limits, security headers, rate-limit policy at the API/BFF layer |
| API/BFF and services | Internal Docker network only | Verified OIDC identity, server-derived tenant scope, RBAC and purpose checks |
| PostgreSQL / RabbitMQ / Redis / Keycloak | Internal Docker network only | Separate service databases/users, credential rotation, backup, audit logs |
| Observability | WireGuard or private management access only | No public Grafana, Prometheus, Loki or Alertmanager endpoint |

The first deployment remains Docker Compose plus Ansible. The directories and service boundaries are intentionally portable to k3s, EKS or GKE later; no application code relies on host-local tenant state.
