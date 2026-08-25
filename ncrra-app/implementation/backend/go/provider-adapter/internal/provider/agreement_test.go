package provider

import (
	"testing"
	"time"
)

func TestAgreementRecordAllowsOnlyApprovedUnexpiredAction(t *testing.T) {
	now := time.Date(2026, 8, 25, 0, 0, 0, 0, time.UTC)
	expires := now.Add(24 * time.Hour)
	record := AgreementRecord{
		ProviderID: "sandbox-provider", AgreementReference: "AGR-TEST-001", ApprovalReference: "APR-TEST-001", ApprovedBy: "platform-integration-owner",
		RecordedAt: now, ExpiresAt: &expires, Status: AgreementApproved, PermittedActions: []string{"service_ticket_handoff"},
	}
	if err := record.ValidFor("service_ticket_handoff", now); err != nil { t.Fatalf("expected approved record to pass: %v", err) }
	if err := record.ValidFor("payment_collection", now); err == nil { t.Fatal("expected uncovered action to be denied") }
}

func TestAgreementRecordRejectsRevokedAndExpiredRecords(t *testing.T) {
	now := time.Date(2026, 8, 25, 0, 0, 0, 0, time.UTC)
	expired := now.Add(-time.Hour)
	record := AgreementRecord{ProviderID: "sandbox-provider", AgreementReference: "AGR-TEST-002", ApprovalReference: "APR-TEST-002", ApprovedBy: "platform-integration-owner", RecordedAt: now, ExpiresAt: &expired, Status: AgreementRevoked, PermittedActions: []string{"service_ticket_handoff"}}
	if err := record.ValidFor("service_ticket_handoff", now); err == nil { t.Fatal("expected revoked and expired record to be denied") }
}
