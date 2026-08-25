// Package provider declares the only permitted provider boundary. Implement adapters only after an approved agreement and documented API/official handoff exist.
package provider

import "context"

type ServiceRequest struct {
	TenantID      string
	TicketID      string
	ConnectionRef string
	Purpose       string
}

type DispatchResult struct {
	ProviderReference string
	Accepted          bool
}

type Adapter interface {
	Name() string
	Dispatch(ctx context.Context, request ServiceRequest) (DispatchResult, error)
}
