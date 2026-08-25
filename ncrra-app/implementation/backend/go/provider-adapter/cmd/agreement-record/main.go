// Records an approved provider agreement reference for the adapter ledger. It neither signs an agreement nor stores credentials.
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/ncrra/platform/provider-adapter/internal/provider"
)

func main() {
	providerID := flag.String("provider", "", "provider identifier")
	agreementRef := flag.String("agreement-reference", "", "approved agreement reference")
	approvalRef := flag.String("approval-reference", "", "internal approval reference")
	approvedBy := flag.String("approved-by", "", "authorised approval actor reference")
	actions := flag.String("actions", "", "comma-separated permitted actions")
	expiresAt := flag.String("expires-at", "", "optional RFC3339 expiry")
	output := flag.String("output", "", "ledger output path")
	flag.Parse()
	if *providerID == "" || *agreementRef == "" || *approvalRef == "" || *approvedBy == "" || *actions == "" || *output == "" {
		fmt.Fprintln(os.Stderr, "provider, agreement-reference, approval-reference, approved-by, actions and output are required")
		os.Exit(2)
	}
	var expiry *time.Time
	if *expiresAt != "" {
		parsed, err := time.Parse(time.RFC3339, *expiresAt); if err != nil { panic(err) }; expiry = &parsed
	}
	record := provider.AgreementRecord{ProviderID: *providerID, AgreementReference: *agreementRef, ApprovalReference: *approvalRef, ApprovedBy: *approvedBy, RecordedAt: time.Now().UTC(), ExpiresAt: expiry, Status: provider.AgreementApproved, PermittedActions: strings.Split(*actions, ",")}
	if err := record.ValidFor(record.PermittedActions[0], time.Now().UTC()); err != nil { panic(err) }
	raw, err := json.MarshalIndent([]provider.AgreementRecord{record}, "", "  "); if err != nil { panic(err) }
	if err := os.WriteFile(*output, raw, 0o600); err != nil { panic(err) }
}
