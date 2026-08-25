// Provider agreements are recorded by opaque references only. Legal documents and credentials remain in approved document/vault systems.
package provider

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"time"
)

type AgreementStatus string

const (
	AgreementApproved AgreementStatus = "approved"
	AgreementRevoked  AgreementStatus = "revoked"
)

type AgreementRecord struct {
	ProviderID         string          `json:"provider_id"`
	AgreementReference string          `json:"agreement_reference"`
	ApprovalReference  string          `json:"approval_reference"`
	ApprovedBy         string          `json:"approved_by"`
	RecordedAt         time.Time       `json:"recorded_at"`
	ExpiresAt          *time.Time      `json:"expires_at,omitempty"`
	Status             AgreementStatus `json:"status"`
	PermittedActions   []string        `json:"permitted_actions"`
}

func (record AgreementRecord) ValidFor(action string, now time.Time) error {
	if record.ProviderID == "" || record.AgreementReference == "" || record.ApprovalReference == "" || record.ApprovedBy == "" {
		return errors.New("provider agreement record is missing a required audit reference")
	}
	if record.Status != AgreementApproved { return fmt.Errorf("provider agreement status is %q", record.Status) }
	if record.ExpiresAt != nil && !record.ExpiresAt.After(now) { return errors.New("provider agreement has expired") }
	for _, permitted := range record.PermittedActions {
		if permitted == action { return nil }
	}
	return fmt.Errorf("action %q is not covered by the provider agreement", action)
}

func LoadAgreementLedger(path string) ([]AgreementRecord, error) {
	if path == "" { return nil, errors.New("provider agreement ledger path is not configured") }
	raw, err := os.ReadFile(path)
	if err != nil { return nil, fmt.Errorf("read provider agreement ledger: %w", err) }
	var records []AgreementRecord
	if err := json.Unmarshal(raw, &records); err != nil { return nil, fmt.Errorf("parse provider agreement ledger: %w", err) }
	return records, nil
}

func AgreementReadiness(path string, now time.Time) error {
	records, err := LoadAgreementLedger(path)
	if err != nil { return err }
	for _, record := range records {
		for _, action := range record.PermittedActions {
			if err := record.ValidFor(action, now); err == nil { return nil }
		}
	}
	return errors.New("no approved, unexpired provider agreement record is ready")
}
