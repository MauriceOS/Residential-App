import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

enum MemberSection { services, community, benefits, account, membership, billing, reportIssue }

class MemberSectionScreen extends StatelessWidget {
  const MemberSectionScreen({required this.section, required this.onBack, required this.onNavigate, this.onOpenReportIssue, this.onOpenMembership, super.key});

  final MemberSection section;
  final VoidCallback onBack;
  final ValueChanged<int> onNavigate;
  final VoidCallback? onOpenReportIssue;
  final VoidCallback? onOpenMembership;

  int get _selectedTab => switch (section) {
        MemberSection.services || MemberSection.reportIssue || MemberSection.billing => 1,
        MemberSection.community => 2,
        MemberSection.benefits => 3,
        MemberSection.account || MemberSection.membership => 4,
      };

  @override
  Widget build(BuildContext context) {
    final content = switch (section) {
      MemberSection.services => _ServicesContent(onOpenReportIssue: onOpenReportIssue),
      MemberSection.reportIssue => _ReportIssueContent(onBack: onBack),
      MemberSection.billing => const _BillingContent(),
      MemberSection.community => const _CommunityContent(),
      MemberSection.benefits => const _BenefitsContent(),
      MemberSection.account => _AccountContent(onOpenMembership: onOpenMembership),
      MemberSection.membership => _MembershipContent(onBack: onBack),
    };
    return Scaffold(
      body: SafeArea(child: Column(children: [Expanded(child: content), NcrraBottomNavigation(selected: _selectedTab, onTap: onNavigate)])),
    );
  }
}

void _showPrototypeMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent({this.onOpenReportIssue});
  final VoidCallback? onOpenReportIssue;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          NcrraTopBar(title: 'Services', action: IconButton(tooltip: 'Search services', icon: const Icon(LucideIcons.search, color: NcrraColors.navy), onPressed: () => _showPrototypeMessage(context, 'Search the service list below.'))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('What do you need help with?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const TextField(decoration: InputDecoration(prefixIcon: Icon(LucideIcons.search, size: 20), hintText: 'Search services')),
              const SizedBox(height: 24),
              Text('Your saved connections', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              const _ConnectionRow(icon: LucideIcons.zap, title: 'KPLC · Meter ending 7842'),
              const SizedBox(height: 8),
              const _ConnectionRow(icon: LucideIcons.droplets, title: 'Mowasco · Account ending 2910'),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () => _showPrototypeMessage(context, 'Connection setup will open here when provider verification is enabled.'), icon: const Icon(LucideIcons.plus, size: 17), label: const Text('Add another connection')),
              const SizedBox(height: 24),
              Text('Browse services', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              _ServiceRow(icon: LucideIcons.zap, title: 'Electricity', body: 'Report a power or meter issue', onTap: onOpenReportIssue),
              _ServiceRow(icon: LucideIcons.droplets, title: 'Water', body: 'Report supply or account issues', onTap: onOpenReportIssue),
              _ServiceRow(icon: LucideIcons.house, title: 'Property maintenance', body: 'Request help with shared areas', onTap: onOpenReportIssue),
              _ServiceRow(icon: LucideIcons.circle_question_mark, title: 'Other help', body: 'Ask NCRRA support a question', onTap: onOpenReportIssue),
            ]),
          ),
        ],
      );
}

class _ReportIssueContent extends StatelessWidget {
  const _ReportIssueContent({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          NcrraTopBar(title: 'Report an issue', onBack: onBack),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const NcrraProgress(step: 1, label: 'Service request'),
              const SizedBox(height: 18),
              Text('Which service needs attention?', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              const _SelectedService(title: 'Electricity', body: 'KPLC · Meter ending 7842', icon: LucideIcons.zap),
              const SizedBox(height: 12),
              _ServiceRow(icon: LucideIcons.droplets, title: 'Water', body: 'Mowasco · Account ending 2910', onTap: () => _showPrototypeMessage(context, 'Water service selected.')),
              _ServiceRow(icon: LucideIcons.house, title: 'Property maintenance', body: 'Shared-area support', onTap: () => _showPrototypeMessage(context, 'Property maintenance selected.')),
              _ServiceRow(icon: LucideIcons.circle_question_mark, title: 'Other help', body: 'Route a question to NCRRA support', onTap: () => _showPrototypeMessage(context, 'Other help selected.')),
              const SizedBox(height: 24),
              Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: NcrraColors.mintSurface, borderRadius: BorderRadius.all(NcrraRadius.control)), child: Row(children: [const Icon(LucideIcons.shield_check, size: 17, color: NcrraColors.teal), const SizedBox(width: 8), Expanded(child: Text('We use this saved connection only to route your request.', style: Theme.of(context).textTheme.bodySmall))])),
              const SizedBox(height: 24),
              NcrraPrimaryButton(label: 'Continue', icon: LucideIcons.arrow_right, onPressed: () => _showPrototypeMessage(context, 'Request details are ready for the next step.')),
            ]),
          ),
        ],
      );
}

enum _BillingState { ready, success, error, empty }

class _BillingContent extends StatefulWidget {
  const _BillingContent();

  @override
  State<_BillingContent> createState() => _BillingContentState();
}

class _BillingContentState extends State<_BillingContent> {
  _BillingState _state = _BillingState.ready;

  @override
  Widget build(BuildContext context) {
    if (_state == _BillingState.success) {
      return _BillingSuccess(onDone: () => setState(() => _state = _BillingState.ready));
    }
    if (_state == _BillingState.error) {
      return _BillingError(onRetry: () => setState(() => _state = _BillingState.ready));
    }
    if (_state == _BillingState.empty) {
      return _BillingEmpty(onDone: () => setState(() => _state = _BillingState.ready));
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const NcrraTopBar(title: 'Pay contribution'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NcrraProgress(step: 1, label: 'Secure payment'),
            const SizedBox(height: 18),
            Text('Renew your NCRRA membership', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Your annual contribution keeps member services available.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: NcrraColors.white, border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)), borderRadius: BorderRadius.all(NcrraRadius.card)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ANNUAL CONTRIBUTION', style: TextStyle(fontFamily: 'Manrope', fontSize: 11, fontWeight: FontWeight.w800, color: NcrraColors.teal, letterSpacing: 1.1)), const SizedBox(height: 8), Text('KES 6,000', style: Theme.of(context).textTheme.titleLarge), const Divider(height: 24), const _KeyValue(label: 'Member', value: 'NCRRA-000784'), const SizedBox(height: 8), const _KeyValue(label: 'Due date', value: '01 Jul 2025')])) ,
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: NcrraColors.warmSand, borderRadius: BorderRadius.all(NcrraRadius.control)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(LucideIcons.calendar_clock, size: 19, color: NcrraColors.amberText), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Payment due 01 Jul 2025', style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 3), Text('Pay now to keep your membership active.', style: Theme.of(context).textTheme.bodySmall)]))])),
            const SizedBox(height: 22),
            Text('Choose how to pay', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            const _SelectedService(title: 'M-PESA', body: 'Confirm securely on your phone', icon: LucideIcons.smartphone),
            const SizedBox(height: 8),
            _ServiceRow(icon: LucideIcons.credit_card, title: 'Debit or credit card', body: 'Use an approved card processor', onTap: () => setState(() => _state = _BillingState.error)),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: NcrraColors.mintSurface, borderRadius: BorderRadius.all(NcrraRadius.control)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(LucideIcons.shield_check, size: 17, color: NcrraColors.teal), const SizedBox(width: 8), Expanded(child: Text('This prototype simulates payment. NCRRA does not store your payment PIN.', style: Theme.of(context).textTheme.bodySmall))])),
            const SizedBox(height: 12),
            Text('Secure confirmation · NCRRA does not store your M-PESA PIN.', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            OutlinedButton.icon(onPressed: () => setState(() => _state = _BillingState.empty), icon: const Icon(LucideIcons.search_check, size: 17), label: const Text('Check contribution status')),
            const SizedBox(height: 10),
            NcrraPrimaryButton(label: 'Continue to M-PESA', icon: LucideIcons.arrow_right, onPressed: () => setState(() => _state = _BillingState.success)),
          ]),
        ),
      ],
    );
  }
}

class _BillingSuccess extends StatelessWidget {
  const _BillingSuccess({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Payment status'), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const SizedBox(height: 54), const NcrraIconOrb(icon: LucideIcons.circle_check, tone: NcrraStatusTone.teal), const SizedBox(height: 20), Text('Payment request received', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('Confirm the M-PESA prompt on your phone. Your membership will update after the provider confirms the payment.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 22), Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: NcrraColors.mintSurface, borderRadius: BorderRadius.all(NcrraRadius.control)), child: const _KeyValue(label: 'Reference', value: 'Awaiting confirmation')), const SizedBox(height: 24), NcrraPrimaryButton(label: 'Return to payment', onPressed: onDone)]))]);
}

class _BillingError extends StatelessWidget {
  const _BillingError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Payment status'), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const SizedBox(height: 54), const NcrraIconOrb(icon: LucideIcons.circle_alert, tone: NcrraStatusTone.coral), const SizedBox(height: 20), Text('Card payment is unavailable', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('This prototype has no card processor enabled. Choose M-PESA or try again after an approved processor is connected.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24), NcrraPrimaryButton(label: 'Try another payment method', onPressed: onRetry)]))]);
}

enum _MembershipState { ready, updated, error }

class _BillingEmpty extends StatelessWidget {
  const _BillingEmpty({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Payment status'), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const SizedBox(height: 54), const NcrraIconOrb(icon: LucideIcons.file_search, tone: NcrraStatusTone.slate), const SizedBox(height: 20), Text('No contribution due', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('There is no payable contribution on this membership record right now. You can return later when a new annual charge is issued.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24), NcrraPrimaryButton(label: 'Return to payment', onPressed: onDone)]))]);
}

class _MembershipContent extends StatefulWidget {
  const _MembershipContent({required this.onBack});
  final VoidCallback onBack;

  @override
  State<_MembershipContent> createState() => _MembershipContentState();
}

class _MembershipContentState extends State<_MembershipContent> {
  _MembershipState _state = _MembershipState.ready;

  @override
  Widget build(BuildContext context) {
    if (_state == _MembershipState.updated) {
      return _MembershipUpdated(onDone: () => setState(() => _state = _MembershipState.ready));
    }
    if (_state == _MembershipState.error) {
      return _MembershipLoadError(onRetry: () => setState(() => _state = _MembershipState.ready));
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        NcrraTopBar(title: 'Membership', onBack: widget.onBack, action: IconButton(tooltip: 'Refresh membership', icon: const Icon(LucideIcons.refresh_cw, color: NcrraColors.navy), onPressed: () => setState(() => _state = _MembershipState.error))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: NcrraColors.navy, borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 38, height: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xFF315A86), shape: BoxShape.circle), child: const Icon(LucideIcons.heart_handshake, color: NcrraColors.white, size: 19)),
                  const Spacer(),
                  const NcrraStatusBadge(label: 'Active', tone: NcrraStatusTone.teal),
                ]),
                const SizedBox(height: 24),
                Text('NCRRA member', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: NcrraColors.white)),
                const SizedBox(height: 6),
                Text('NCRRA-000784', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFFD7E1EC), letterSpacing: 1.2)),
              ]),
            ),
            const SizedBox(height: 22),
            Text('Membership details', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(color: NcrraColors.white, border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)), borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(children: [
                const _KeyValue(label: 'Member since', value: '12 Jan 2023'),
                const Divider(height: 1),
                const _KeyValue(label: 'Annual contribution', value: 'KES 6,000'),
                const Divider(height: 1),
                const _KeyValue(label: 'Renewal date', value: '01 Jul 2025'),
              ].map((child) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: child)).toList()),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(color: NcrraColors.warmSand, borderRadius: BorderRadius.all(NcrraRadius.control)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(LucideIcons.calendar_clock, size: 19, color: NcrraColors.amberText),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Renewal is due', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 3),
                  Text('Keep your member services active by paying before 01 Jul 2025.', style: Theme.of(context).textTheme.bodySmall),
                ])),
              ]),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(onPressed: () => showModalBottomSheet<void>(context: context, showDragHandle: true, builder: (sheetContext) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 4, 20, 24), child: Column(mainAxisSize: MainAxisSize.min, children: [const NcrraIconOrb(icon: LucideIcons.receipt_text, tone: NcrraStatusTone.slate), const SizedBox(height: 14), Text('No receipts yet', style: Theme.of(sheetContext).textTheme.titleMedium), const SizedBox(height: 6), Text('Confirmed contribution receipts will appear here.', textAlign: TextAlign.center, style: Theme.of(sheetContext).textTheme.bodyMedium), const SizedBox(height: 16), NcrraPrimaryButton(label: 'Close', onPressed: () => Navigator.of(sheetContext).pop())])))), icon: const Icon(LucideIcons.receipt_text, size: 17), label: const Text('View receipts')),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: () => setState(() => _state = _MembershipState.updated), icon: const Icon(LucideIcons.pencil_line, size: 17), label: const Text('Update member details')),
          ]),
        ),
      ],
    );
  }
}

class _MembershipUpdated extends StatelessWidget {
  const _MembershipUpdated({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Membership'), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const SizedBox(height: 54), const NcrraIconOrb(icon: LucideIcons.circle_check, tone: NcrraStatusTone.teal), const SizedBox(height: 20), Text('Details saved securely', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('Your updated member details will be reviewed according to NCRRA consent controls.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24), NcrraPrimaryButton(label: 'Return to membership', onPressed: onDone)]))]);
}

class _MembershipLoadError extends StatelessWidget {
  const _MembershipLoadError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Membership'), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const SizedBox(height: 54), const NcrraIconOrb(icon: LucideIcons.circle_alert, tone: NcrraStatusTone.coral), const SizedBox(height: 20), Text('Membership details unavailable', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text('We could not refresh the member record. Your last known details remain protected; try again when the connection is available.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24), NcrraPrimaryButton(label: 'Try again', onPressed: onRetry)]))]);
}

class _CommunityContent extends StatelessWidget {
  const _CommunityContent();
  @override
  Widget build(BuildContext context) => _SimpleSection(title: 'Community', icon: LucideIcons.users_round, eyebrow: 'NCRRA COMMUNITY', heading: 'Stay close to what is happening', body: 'Read association announcements, activities and member updates in one trusted place.', items: const [('Annual general meeting', '18 Jun 2025 · Nairobi'), ('Neighbourhood clean-up', '22 Jun 2025 · 09:00 AM'), ('Member notice', 'Updated 10 Jun 2025')]);
}

class _BenefitsContent extends StatelessWidget {
  const _BenefitsContent();
  @override
  Widget build(BuildContext context) => _SimpleSection(title: 'Benefits', icon: LucideIcons.tag, eyebrow: 'MEMBER BENEFITS', heading: 'Useful offers for NCRRA members', body: 'Access partner offers when they are available. Eligibility and terms are shown before you use an offer.', items: const [('Jambojet member offer', 'Partner offer · View terms'), ('SGR travel information', 'Member guidance · View details'), ('Local transport partners', 'Available offers · Explore')]);
}

class _AccountContent extends StatelessWidget {
  const _AccountContent({this.onOpenMembership});
  final VoidCallback? onOpenMembership;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: 'Account', action: IconButton(tooltip: 'Notifications', icon: const Icon(LucideIcons.bell, color: NcrraColors.navy), onPressed: () => _showPrototypeMessage(context, 'You have no new account alerts.'))), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(children: [const _ProfileRow(), const SizedBox(height: 20), _AccountGroup(title: 'Membership', items: const ['My membership', 'Household and contacts', 'My receipts'], onItemTap: (item) => item == 'My membership' ? onOpenMembership?.call() : _showPrototypeMessage(context, '$item: this setting will open here.')), _AccountGroup(title: 'Security', items: const ['Biometric login', 'Password and recovery', 'Active devices']), _AccountGroup(title: 'Privacy', items: const ['Provider connections', 'Consent and data access', 'Notification preferences']), const SizedBox(height: 16), OutlinedButton.icon(onPressed: () => _showPrototypeMessage(context, 'Sign out is protected by confirmation in the production app.'), icon: const Icon(LucideIcons.log_out, size: 17), label: const Text('Sign out'))]))]);
}

class _SimpleSection extends StatelessWidget {
  const _SimpleSection({required this.title, required this.icon, required this.eyebrow, required this.heading, required this.body, required this.items});
  final String title;
  final IconData icon;
  final String eyebrow;
  final String heading;
  final String body;
  final List<(String, String)> items;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [NcrraTopBar(title: title, action: IconButton(tooltip: '$title information', icon: Icon(icon, color: NcrraColors.navy), onPressed: () => _showPrototypeMessage(context, '$title information is shown below.'))), Padding(padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: NcrraColors.teal, letterSpacing: 1.1)), const SizedBox(height: 10), Text(heading, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 8), Text(body, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 24), ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _ServiceRow(icon: icon, title: item.$1, body: item.$2, onTap: () => _showPrototypeMessage(context, '${item.$1}: details will be shown here.')))) ]))]);
}

class _ConnectionRow extends StatelessWidget {
  const _ConnectionRow({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: NcrraColors.white, border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)), borderRadius: BorderRadius.all(NcrraRadius.card)), child: Row(children: [NcrraIconOrb(icon: icon), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 3), const NcrraStatusBadge(label: 'Verified')]))]));
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.icon, required this.title, required this.body, this.onTap});
  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: NcrraColors.white,
          borderRadius: const BorderRadius.all(NcrraRadius.card),
          child: InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.all(NcrraRadius.card),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
                borderRadius: BorderRadius.all(NcrraRadius.card),
              ),
              child: Row(
                children: [
                  NcrraIconOrb(icon: icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text(body, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevron_right, size: 20, color: NcrraColors.mutedText),
                ],
              ),
            ),
          ),
        ),
      );
}

class _SelectedService extends StatelessWidget {
  const _SelectedService({required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: NcrraColors.mintSurface, border: Border.fromBorderSide(BorderSide(color: NcrraColors.teal, width: 2)), borderRadius: BorderRadius.all(NcrraRadius.card)), child: Row(children: [NcrraIconOrb(icon: icon), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 4), Text(body, style: Theme.of(context).textTheme.bodySmall)])), const Icon(LucideIcons.circle_check, size: 20, color: NcrraColors.teal)]));
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(children: [Text(label, style: Theme.of(context).textTheme.bodySmall), const Spacer(), Text(value, style: Theme.of(context).textTheme.labelMedium)]);
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: const BoxDecoration(color: NcrraColors.white, border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)), borderRadius: BorderRadius.all(NcrraRadius.card)), child: Row(children: [const NcrraIconOrb(icon: LucideIcons.user_round), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Amina Wanjiku', style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 4), Text('amina@example.com', style: Theme.of(context).textTheme.bodySmall)])), const SizedBox(width: 20)]));
}

class _AccountGroup extends StatelessWidget {
  const _AccountGroup({required this.title, required this.items, this.onItemTap});
  final String title;
  final List<String> items;
  final ValueChanged<String>? onItemTap;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Container(
              decoration: const BoxDecoration(
                color: NcrraColors.white,
                border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
                borderRadius: BorderRadius.all(NcrraRadius.card),
              ),
              child: Column(
                children: items
                    .map((item) => Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                            title: Text(item, style: Theme.of(context).textTheme.labelLarge),
                            trailing: const Icon(LucideIcons.chevron_right, size: 19, color: NcrraColors.mutedText),
                            onTap: () => onItemTap != null ? onItemTap!(item) : _showPrototypeMessage(context, '$item: this setting will open here.'),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
