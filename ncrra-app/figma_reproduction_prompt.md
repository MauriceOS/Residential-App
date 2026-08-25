# NCRRA Mobile App — Exact Figma Reproduction Prompt

Copy the prompt below into Figma Make, Figma AI, or give it directly to a product designer. The prompt reproduces the **implemented NCRRA prototype**, including its latest registration, consent and ticket-dashboard interactions. It describes a product concept only: payment and third-party provider behaviours remain simulated.

---

## Prompt to paste into Figma

```text
Create an editable, high-fidelity mobile application design file named “NCRRA Member App”. Reproduce a calm, premium civic-member service utility for NCRRA, an association platform. This must feel designed by a disciplined product team: warm, restrained, useful, secure and contemporary. Do not use generic AI-style purple gradients, illustrations, glassmorphism, excessive rounded cards or oversized floating elements. Make the app task-led and quiet.

Set up a Figma page called “01 · Mobile UI”. Use Android portrait frames at 390 × 844 px. Design the native mobile UI inside the frame; do not draw a phone hardware border. Use a 24 px top safe-area allowance, 20 px left/right content padding, and a sticky 72 px bottom navigation bar where specified.

BRAND AND VISUAL TOKENS
- Background: #F8F7F3 warm ivory.
- Primary / action teal: #007B78.
- Deep navy headings / high-emphasis text: #0B1E3B.
- Body secondary text: #5B6473.
- Muted text: #65707B.
- White surfaces: #FFFFFF.
- Standard border: #E3E6E5.
- Mint callout surface: #F1F8F6, mint badge surface #E8F5F2, mint icon surface #EDF7F5.
- Mint-callout border: #DCE9E5.
- Amber pending surface: #FFF3DA; amber text: #9A650F.
- Coral alert surface: #FFF0EC; coral text: #C9503C; notification badge: #FA6B60.
- Very pale neutral surface: #EEF0F3.
- Device/nav divider: #E4E7E6.
- Use 1 px borders in #E3E6E5 except selected option borders, which are 2 px #007B78.

TYPOGRAPHY
- Use Plus Jakarta Sans for display headings and Manrope for all body text and controls.
- Display heading weights are ExtraBold 800. Body headings and labels are ExtraBold 800. Body paragraphs are Regular 400 or Medium 500.
- App title / page title: Plus Jakarta Sans ExtraBold, 27 px, tracking -5.5%.
- Major onboarding heading: Plus Jakarta Sans ExtraBold, 34 px, line height 36 px, tracking -6.5%.
- Page section heading: Plus Jakarta Sans ExtraBold, 21 px, tracking -5%.
- Home greeting: Plus Jakarta Sans ExtraBold, 25 px, tracking -5.5%.
- Standard card title: Manrope ExtraBold, 14–15 px.
- Body copy: Manrope Regular, 14–15 px, 20–24 px line height.
- Metadata: Manrope Regular, 12 px, 18–20 px line height.
- Eyebrow / status metadata: Manrope ExtraBold, 11–12 px.

SHAPE, SPACING AND ELEVATION
- Use 16 px radius for full-width information surfaces and ticket cards. Use 12 px radius for text fields and primary buttons. Use 999 px radius only for badges, chips, pills and icon circles.
- Use 20 px frame gutters, 16 px vertical card padding, 12 px control gaps, 20–24 px section gaps and 28 px major section gaps.
- Keep shadows minimal. Only the primary teal CTA may use a soft shadow: 0 8 20 rgba(0,123,120,0.18). Most cards are flat white with a precise 1 px border.
- Use Lucide icons exactly, at 20 px inside 44 × 44 px circular icon containers. Use 16 px icons for compact buttons; use 24 px for top-bar actions.

BUILD REUSABLE COMPONENTS
1. `TopBar`: 24 px safe area, 56 px visual header, optional 36 × 36 back button, Plus Jakarta Sans 27 px title, optional action icon at right.
2. `Primary CTA`: 48 px tall, 12 px radius, #007B78 fill, white Manrope ExtraBold 14 px text, 20 px horizontal padding.
3. `Icon Orb`: 44 × 44 px circle, #EDF7F5 fill, teal Lucide line icon at 20 px. Provide amber and coral variants.
4. `Status Badge`: 11 px Manrope ExtraBold text with 10 px horizontal and 4 px vertical padding. Create teal, amber, coral and slate variants.
5. `Ticket Card`: white, 16 px radius, 1 px #E3E6E5 border, 16 px padding, 44 px left icon orb, status badge top right, chevron-right on far right.
6. `Bottom Nav`: 72 px height, white with 95% opacity, top border #E4E7E6. Five equal columns: Home, Services, Community, Benefits, Account. Use Lucide Home, Menu, UsersRound, Tag and UserRound. Selected state is #007B78 with a 40 × 4 px teal indicator along the top edge.
7. `Consent Row`: 20 × 20 px checkbox, title, required/optional inline label and 12 px supporting description; rows separated by 1 px #E5E9E7 dividers.

USE THESE EXACT LUCIDE ICONS
- NCRRA app: use the supplied NCRRA mark in a 40 × 40 px container. Pair it with the text “NCRRA”.
- Home: Home; Services: Menu; Community: UsersRound; Benefits: Tag; Account: UserRound.
- Back: ArrowLeft; notifications: Bell; ticket: Ticket; search: Search; filters: ListFilter; sort: ArrowDownUp; clear / close: X.
- Electricity: Zap; water: Droplets; property: House; connection: PlugZap; support: CircleHelp; issue: CircleAlert; approved / complete: CircleCheck and Check; secure / consent: ShieldCheck and LockKeyhole; member: HeartHandshake; payment: WalletCards, Smartphone and CreditCard; receipt: ReceiptText; user: UserRound; event: CalendarDays; location: MapPin.

CREATE THESE FRAMES IN THIS ORDER

FRAME 01 — `Onboarding · Welcome`
- Top left brand row: NCRRA mark 40 px, “NCRRA” in Plus Jakarta Sans ExtraBold 27 px.
- At y≈183, show teal-on-mint badge “New member registration”.
- Major heading: “Your association\nservices, in one\nplace.”
- Body: “Set up your member account first. You can add service connections and manage your annual contribution afterwards.”
- Add a 1 px top and bottom divider group with three items: UserRound “Set up your member profile” / “Confirm how NCRRA can reach you.”; ShieldCheck “Review data consent” / “See what data is used and why before you continue.”; HeartHandshake “Access member services” / “Manage services, notices, benefits and annual contributions.”
- Anchor the 48 px primary CTA “Start registration” close to the bottom. Below it, a text button: “I already have an account”.

FRAME 02 — `Onboarding · Set up profile`
- TopBar: back icon + “Set up profile”.
- Progress row: slate badge “1 of 3”, label “Member registration”.
- Heading: “A few details to get started”. Body: “These details identify your NCRRA membership and let support respond to you.”
- Four 48 px outlined text fields, with bold labels above: Full name = “Amina Wanjiku”; Email address = “amina@example.com”; Mobile number = “0712 345 678”; Town or area = “Nairobi”.
- Bottom CTA: “Continue”.

FRAME 03 — `Onboarding · Review consent`
- TopBar: back icon + “Review consent”.
- Progress row: slate badge “2 of 3”, label “Member registration”.
- Heading: “You decide how your data is used”. Body: “NCRRA needs a limited set of details to manage membership. Provider references are not connected until you choose to add them.”
- A white 16 px radius consent group with three rows: unchecked “Membership administration” with inline coral “Required”; description “Use my profile details to create and administer my NCRRA membership.” Unchecked “Privacy notice” with inline coral “Required”; description “I have reviewed how NCRRA safeguards membership data and handles support access.” Checked teal “Association updates” with inline muted “Optional”; description “Send association announcements, activities and relevant member notices.”
- Add a mint information panel with ShieldCheck: “You can review or change optional communication choices later in Account. Service-provider data remains separate and is only shared for a requested service action.”
- Bottom primary CTA: “Complete registration”. It is disabled muted teal-grey until the two required checkboxes are checked; show the enabled teal state in a second component variant.

FRAME 04 — `Onboarding · Registration complete`
- Brand row at top.
- Center vertically: 80 × 80 mint circle with CircleCheck teal icon. Teal badge “Registration complete”. Heading “Welcome, Amina.” Body: “Your member account is ready. You can now save a service connection, review notices and manage your association contribution.”
- Add mint bordered surface: eyebrow “NEXT RECOMMENDED STEP”, title “Add your first service connection”, description “This is optional. A connection is saved only after you choose to add it.”
- Bottom primary CTA: “Enter member app”.

FRAME 05 — `Home · Active member`
- Brand row at top left and Bell at right with coral badge “2”.
- Heading “Good morning, Amina”; supporting text “Your member services, in one place.”
- Mint membership panel: HeartHandshake orb, “NCRRA member · Active”, “Member since 12 Jan 2023”, “Membership ID: NCRRA-000784”, outlined CTA “View membership” with CreditCard icon.
- Section “Quick actions”, 2-column grid of four white cards: CircleAlert “Report an issue” / “Get help with a local service”; Ticket “My tickets” / “Search and track requests”; WalletCards “Pay contribution” / “Manage your annual contribution”; PlugZap “My connections” / “Reuse verified service details”.
- Link: “New to NCRRA? Start member registration”.
- Section “My open ticket” with “View all”; one Ticket Card for NCRRA-2481, amber “Awaiting provider”, “Power interruption follow-up”, “Reported 10 May 2025 · 09:15 AM”. Include Bottom Nav with Home selected.

FRAME 06 — `Tickets · My tickets`
- TopBar: back + “My tickets”, ListFilter on right.
- Search input 48 px: Search icon and placeholder “Search ticket or service”; clear X when text exists.
- Horizontally scrolling status chips: All selected teal; Awaiting provider; In progress; Resolved. Use white with muted outline for unselected chips.
- Row: “4 tickets found” at left. ArrowDownUp and “Newest” at right.
- Four Ticket Cards, exactly:
  1. NCRRA-2481, amber “Awaiting provider”, Power interruption follow-up, Electricity · Updated today · 11:20 AM, Zap icon.
  2. NCRRA-2458, slate “In progress”, Intermittent water supply, Water · Updated yesterday · 04:15 PM, Droplets icon.
  3. NCRRA-2419, teal “Resolved”, Estate streetlight repair, Property · Resolved 06 May 2025, House icon.
  4. NCRRA-2397, slate “Closed”, Meter account detail correction, Electricity · Closed 28 Apr 2025, Zap icon.
- Include Bottom Nav with Services selected.

FRAME 07 — `Tickets · Filter and sort expanded`
- Same as Frame 06, but the filter action becomes an X inside a mint circle.
- Insert a mint filter panel immediately below status chips. Header “Filter and sort” with “Reset” text action.
- Two equal controls: Service dropdown showing “All” with options All, Electricity, Water, Property; Sort dropdown showing “Newest first” with options Newest first, Oldest first, Status.
- Use 40 px white select controls with #CDDFDB borders. The ticket count and cards update below.

FRAME 08 — `Tickets · No search results`
- Same header and search control as Frame 06; show an intentionally unmatched query.
- Empty state centered in content: 48 px mint circular Search icon; title “No matching tickets”; helper “Try a different service, status or search term.”; teal text action “Clear filters”.

FRAME 09 — `Ticket · Details`
- TopBar back + “Ticket details”.
- Ticket card header for currently selected NCRRA-2481. Amber Zap orb, amber status badge “Awaiting provider”, ticket number, title, “Electricity · Updated today · 11:20 AM”.
- Neutral ivory detail panel: “Power supply has not been restored since morning at the linked meter.”
- Vertical progress: teal completed circle with Check: “Request submitted” / “NCRRA recorded your request.”; teal outlined active circle: “Current: Awaiting provider” / “NCRRA will notify you when this changes.”; grey 3 circle: “Member confirmation” / “You can review the outcome when the ticket closes.”
- Mint notification row with Bell: “You will receive updates here” and ChevronRight.

FRAME 10 — `Service · Choose service`
- TopBar back + “Report a service issue”.
- Progress row: “1 of 3” and “Service request”.
- Heading “Which service needs attention?”
- Mint saved connection panel: PlugZap orb, “KPLC · Meter ending 7842”, “Verified connection”, text action “Change”.
- List of four service choices. Electricity is selected with 2 px teal border, mint fill, Zap icon and CircleCheck. Other rows: Water / Droplets, Property maintenance / House, Other help / CircleHelp. Bottom helper: “We use this connection only to route your request.”

FRAME 11 — `Service · Describe issue`
- TopBar back + “Describe the issue”; progress “2 of 3”.
- Mint compact selection card: eyebrow “ELECTRICITY”, “Meter ending 7842”.
- Label “What happened?”, teal badge “Power interruption”. Label “Tell us more”, 112 px textarea with “No supply since this morning.”
- Dashed upload row: Paperclip, “Add a photo or document”, “Optional evidence for NCRRA support”.
- Checked consent line: “Share this meter reference with NCRRA support so the request can be routed correctly.”
- Bottom CTA “Review request”.

FRAME 12 — `Service · Review request`
- TopBar back + “Review request”; progress “3 of 3”.
- Heading “Check before sending”. White review card: Zap orb, “Power interruption”, “KPLC · Meter ending 7842”; divider; eyebrow “DESCRIPTION”; text “No supply since this morning.”; divider; key-value Routing / NCRRA Support and Response target / 1 business day.
- Helper: “Submitting creates a service ticket and permits NCRRA to route the saved service reference only to the responsible support party.”
- Bottom CTA “Submit request”.

FRAME 13 — `Membership`
- TopBar back + “My membership”.
- Mint membership-card: HeartHandshake orb, “NCRRA”, teal “● Active member”, Member ID / NCRRA-000784 and Valid until / 31 Dec 2025. Include an 80 × 80 simple dark navy QR-style grid.
- Section “Annual contribution”; white card with amber WalletCards orb, “KES 6,000”, amber badge “Due 01 Jul 2025”, primary CTA “Pay contribution”, text action “View receipts”.

FRAME 14 — `Billing · Pay contribution`
- TopBar back + “Pay contribution”.
- White annual contribution summary card: eyebrow “ANNUAL CONTRIBUTION”, “KES 6,000”, divider, Member / NCRRA-000784, Due date / 01 Jul 2025.
- Section “Payment method”. M-PESA option selected: 2 px teal border, pale mint fill, Smartphone orb, title M-PESA, “Confirm securely on your phone”, CircleCheck. Card option unselected with CreditCard orb, “Use a debit or credit card”.
- Mint security callout with ShieldCheck: “Payments are processed by an approved provider. NCRRA does not store your payment PIN.”
- Bottom CTA “Continue to M-PESA”.

FRAME 15 — `Billing · Confirmation sheet`
- Reuse Frame 14 and add a bottom sheet with 28 px top corner radius, top handle, heading “Confirm payment”, body “A secure M-PESA prompt would open next. This prototype simulates a successful payment.” Primary CTA “Simulate successful payment” and text action “Cancel”.

FRAME 16 — `Billing · Contribution received`
- TopBar back + “Contribution received”. Centered 64 px mint check circle. Heading “KES 6,000 paid successfully”. Body “Your annual NCRRA contribution is recorded.”
- White receipt card with Reference / NCRRA-2025-00681, Payment method / M-PESA, Date / 18 Jun 2025, Membership status / Active teal.
- Primary CTA “View receipt” with ReceiptText. Text action “Back to home”.

FRAME 17 — `Services`
- TopBar title “Services” with Search. Text “What do you need help with?” and 48 px search field “Search services”.
- Section “Your saved connections”: KPLC · Meter ending 7842 / Verified teal badge and Mowasco · Account ending 2910 / Verified teal badge. Dashed outlined action “Add another connection”.
- Section “Browse services”: Electricity, Water, Property maintenance, Other help; each as list row with appropriate icon and chevron.

FRAME 18 — `Account`
- TopBar title “Account” and Bell with coral badge 2.
- Profile row: UserRound orb, Amina Wanjiku, amina@example.com, ChevronRight.
- Sections Membership, Security, Privacy, all in rounded white list groups. Membership entries: My membership, Household and contacts, My receipts. Security: Biometric login with enabled teal switch, Password and recovery, Active devices. Privacy: Provider connections, Consent and data access, Notification preferences.
- Full outlined CTA: UserRound + “Preview new member registration”. Red text action “Sign out”.

INTERACTION PROTOTYPE
- Connect Onboarding Welcome > Start registration > Set up profile. Continue > Review consent. Required checkboxes must be selected before Complete registration enables. Complete registration > Registration complete. Enter member app > Home.
- From Home: Report an issue > Choose service > Describe issue > Review request > Ticket details. My tickets and View all > Tickets dashboard. Pay contribution > Pay contribution screen > Confirmation sheet > Contribution received. View membership > Membership.
- Ticket dashboard: status chips filter the four tickets; Search filters by ticket ID, title and service; ListFilter opens Frame 07; Service filter supports All/Electricity/Water/Property; Sort supports Newest first/Oldest first/Status; Reset restores defaults; unmatched state shows Frame 08; tapping a ticket opens Ticket details.
- Use 160 ms press feedback with scale to 97.5% on buttons, 240 ms ease-out crossfade/8 px upward transition between full screens, and respect reduced-motion settings. Do not introduce decorative animation.

ACCESSIBILITY
- Ensure all normal text has at least 4.5:1 contrast on the rendered surface. Use 44 × 44 px minimum icon/touch targets. Make input labels persistent above fields; never rely on placeholder text alone. All selected states must use both color and a checkmark/indicator. Required consent labels must remain readable without relying only on coral color.

DELIVERABLE EXPECTATIONS
- Use auto layout throughout. Create editable color styles, text styles, components and variants. Name frames and layers exactly as written. Do not convert text to outlines. Maintain the warm ivory / navy / teal visual hierarchy across every screen. Do not add third-party provider logos, device chrome, fake testimonials, or claims of live payment/provider integrations.
```

## Design-implementation note

The prompt describes the **current prototype**, including example data such as tickets, member names and contribution amounts. Those are interface demonstrations and should be replaced with approved NCRRA content before production design sign-off.
