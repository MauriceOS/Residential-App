# NCRRA service boundary rules

The mobile app does not define the backend shape. The mobile screens are clients of **bounded, independently deployable services**. An association tenant is determined from the verified access token at the platform edge, propagated as trusted server context, and constrained again at the database layer. It is never accepted from a mobile query parameter or UI-selected value.

| Service | Own data and migration boundary | Synchronous contract | Asynchronous contract | Must not do |
|---|---|---|---|---|
| Membership | members, household, membership status, consent revisions | `/api/v1/me/membership` | `membership.status.changed.v1` | Read ticket or billing tables |
| Ticketing | ticket, ticket status history, request attachment metadata | `/api/v1/tickets` | `ticket.created.v1`, `ticket.status.changed.v1` | Call providers or access member billing rows |
| Billing | contribution invoice, payment intent, receipt, ledger reference | `/api/v1/contributions` | `contribution.paid.v1` | Store M-PESA PINs/card data |
| Provider adapter | outbound action metadata, provider reference, retry state | Internal worker endpoint only | consumes ticket routing events | Scrape, reverse engineer or call an undocumented provider interface |
| Notifications | preference, delivery, notification read state | `/api/v1/notifications` | consumes membership/ticket/billing events | Become the source of workflow truth |

The first contract in this foundation is the ticket search endpoint because it serves the UI’s exact search, status filtering, service filtering and sorting controls. The platform edge must verify OIDC, map roles, validate a support-purpose grant where applicable, and hand a request context to the service. Each service should enforce the same context before constructing a query. PostgreSQL RLS may be added as an additional guard; it does not replace service authorization.
