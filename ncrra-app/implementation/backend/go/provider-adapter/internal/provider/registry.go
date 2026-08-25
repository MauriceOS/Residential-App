// Provider enablement is agreement-gated. Registry records carry vault references only; no credential value enters the adapter configuration.
package provider

import (
	"context"
	"errors"
	"fmt"
)

type Mode string

const (
	ModeDocumentedAPI     Mode = "documented_api"
	ModeManagedOperations Mode = "managed_operations"
	ModeOfficialHandoff   Mode = "official_handoff"
)

var (
	ErrIntegrationDisabled = errors.New("provider integration is disabled pending agreement gate")
	ErrAgreementMissing    = errors.New("provider agreement reference is required")
	ErrCredentialMissing   = errors.New("provider credential reference is required for documented API mode")
	ErrUnsupportedMode     = errors.New("provider mode is not an automated API dispatch")
)

type Configuration struct {
	ID                  string
	Mode                Mode
	Enabled             bool
	AgreementReference  string
	CredentialReference string
	PermittedActions    map[string]struct{}
}

type Registry struct {
	configurations map[string]Configuration
	adapters       map[string]Adapter
}

func NewRegistry(configurations []Configuration, adapters []Adapter) Registry {
	registry := Registry{configurations: map[string]Configuration{}, adapters: map[string]Adapter{}}
	for _, configuration := range configurations { registry.configurations[configuration.ID] = configuration }
	for _, adapter := range adapters { registry.adapters[adapter.Name()] = adapter }
	return registry
}

func (registry Registry) Ready(providerID, action string) error {
	configuration, exists := registry.configurations[providerID]
	if !exists { return fmt.Errorf("provider %q is not registered", providerID) }
	if !configuration.Enabled { return ErrIntegrationDisabled }
	if configuration.AgreementReference == "" { return ErrAgreementMissing }
	if _, allowed := configuration.PermittedActions[action]; !allowed { return fmt.Errorf("action %q is not permitted for provider %q", action, providerID) }
	if configuration.Mode != ModeDocumentedAPI { return ErrUnsupportedMode }
	if configuration.CredentialReference == "" { return ErrCredentialMissing }
	if _, exists := registry.adapters[providerID]; !exists { return fmt.Errorf("no adapter is registered for provider %q", providerID) }
	return nil
}

func (registry Registry) Dispatch(ctx context.Context, providerID string, request ServiceRequest) (DispatchResult, error) {
	if err := registry.Ready(providerID, request.Purpose); err != nil { return DispatchResult{}, err }
	return registry.adapters[providerID].Dispatch(ctx, request)
}
