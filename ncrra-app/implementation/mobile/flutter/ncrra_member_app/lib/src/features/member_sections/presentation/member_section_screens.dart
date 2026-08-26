import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

part 'member_section_widgets.dart';

enum MemberSection {
  services,
  community,
  benefits,
  account,
  membership,
  billing,
  reportIssue
}

class MemberSectionScreen extends StatelessWidget {
  const MemberSectionScreen(
      {required this.section,
      required this.onBack,
      required this.onNavigate,
      this.onOpenReportIssue,
      this.onOpenMembership,
      super.key});

  final MemberSection section;
  final VoidCallback onBack;
  final ValueChanged<int> onNavigate;
  final VoidCallback? onOpenReportIssue;
  final VoidCallback? onOpenMembership;

  int get _selectedTab => switch (section) {
        MemberSection.services ||
        MemberSection.reportIssue ||
        MemberSection.billing =>
          1,
        MemberSection.community => 2,
        MemberSection.benefits => 3,
        MemberSection.account || MemberSection.membership => 4,
      };

  @override
  Widget build(BuildContext context) {
    final content = switch (section) {
      MemberSection.services =>
        _ServicesContent(onOpenReportIssue: onOpenReportIssue),
      MemberSection.reportIssue => _ReportIssueContent(onBack: onBack),
      MemberSection.billing => const _BillingContent(),
      MemberSection.community => const _CommunityContent(),
      MemberSection.benefits => const _BenefitsContent(),
      MemberSection.account =>
        _AccountContent(onOpenMembership: onOpenMembership),
      MemberSection.membership => _MembershipContent(onBack: onBack),
    };
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        Expanded(child: content),
        NcrraBottomNavigation(selected: _selectedTab, onTap: onNavigate)
      ])),
    );
  }
}

void _showPrototypeMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2)));
}

class _ServicesContent extends StatelessWidget {
  const _ServicesContent({this.onOpenReportIssue});
  final VoidCallback? onOpenReportIssue;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          NcrraTopBar(
              title: 'Services',
              action: IconButton(
                  tooltip: 'Search services',
                  icon: const Icon(LucideIcons.search, color: NcrraColors.navy),
                  onPressed: () => _showPrototypeMessage(
                      context, 'Search the service list below.'))),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('What do you need help with?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(LucideIcons.search, size: 20),
                      hintText: 'Search services')),
              const SizedBox(height: 24),
              Text('Your saved connections',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              const _ConnectionRow(
                  icon: LucideIcons.gauge,
                  title: 'Kenya Power · Meter ending 7842'),
              const SizedBox(height: 8),
              const _ConnectionRow(
                  icon: LucideIcons.droplets,
                  title: 'Mowasco · Account ending 2910'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                  onPressed: () => _showPrototypeMessage(context,
                      'Connection setup will open here when provider verification is enabled.'),
                  icon: const Icon(LucideIcons.plus, size: 17),
                  label: const Text('Add another connection')),
              const SizedBox(height: 24),
              Text('Browse services',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              _ServiceRow(
                  icon: LucideIcons.gauge,
                  title: 'Electricity',
                  body: 'Report a power or meter issue',
                  onTap: onOpenReportIssue),
              _ServiceRow(
                  icon: LucideIcons.droplets,
                  title: 'Water',
                  body: 'Report supply or account issues',
                  onTap: onOpenReportIssue),
              _ServiceRow(
                  icon: LucideIcons.house,
                  title: 'Property maintenance',
                  body: 'Request help with shared areas',
                  onTap: onOpenReportIssue),
              _ServiceRow(
                  icon: LucideIcons.circle_question_mark,
                  title: 'Other help',
                  body: 'Ask NCRRA support a question',
                  onTap: onOpenReportIssue),
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
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const NcrraProgress(step: 1, label: 'Service request'),
              const SizedBox(height: 18),
              Text('Which service needs attention?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              const _SelectedService(
                  title: 'Electricity',
                  body: 'Kenya Power · Meter ending 7842',
                  icon: LucideIcons.gauge),
              const SizedBox(height: 12),
              _ServiceRow(
                  icon: LucideIcons.droplets,
                  title: 'Water',
                  body: 'Mowasco · Account ending 2910',
                  onTap: () => _showPrototypeMessage(
                      context, 'Water service selected.')),
              _ServiceRow(
                  icon: LucideIcons.house,
                  title: 'Property maintenance',
                  body: 'Shared-area support',
                  onTap: () => _showPrototypeMessage(
                      context, 'Property maintenance selected.')),
              _ServiceRow(
                  icon: LucideIcons.circle_question_mark,
                  title: 'Other help',
                  body: 'Route a question to NCRRA support',
                  onTap: () =>
                      _showPrototypeMessage(context, 'Other help selected.')),
              const SizedBox(height: 24),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: NcrraColors.mintSurface,
                      borderRadius: BorderRadius.all(NcrraRadius.control)),
                  child: Row(children: [
                    const Icon(LucideIcons.shield_check,
                        size: 17, color: NcrraColors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            'We use this saved connection only to route your request.',
                            style: Theme.of(context).textTheme.bodySmall))
                  ])),
              const SizedBox(height: 24),
              NcrraPrimaryButton(
                  label: 'Continue',
                  icon: LucideIcons.arrow_right,
                  onPressed: () => _showPrototypeMessage(
                      context, 'Request details are ready for the next step.')),
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
  bool _loading = false;

  Future<void> _transitionTo(_BillingState next) async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;
    setState(() {
      _state = next;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _BillingState.success) {
      return _BillingSuccess(
          onDone: () => setState(() => _state = _BillingState.ready));
    }
    if (_state == _BillingState.error) {
      return _BillingError(
          onRetry: () => setState(() => _state = _BillingState.ready));
    }
    if (_state == _BillingState.empty) {
      return _BillingEmpty(
          onDone: () => setState(() => _state = _BillingState.ready));
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const NcrraTopBar(title: 'Pay contribution'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const NcrraProgress(step: 1, label: 'Secure payment'),
            const SizedBox(height: 18),
            Text('Renew your NCRRA membership',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Your annual contribution keeps member services available.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 18),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                    color: NcrraColors.white,
                    border: Border.fromBorderSide(
                        BorderSide(color: NcrraColors.border)),
                    borderRadius: BorderRadius.all(NcrraRadius.card)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ANNUAL CONTRIBUTION',
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: NcrraColors.teal,
                              letterSpacing: 1.1)),
                      const SizedBox(height: 8),
                      Text('KES 6,000',
                          style: Theme.of(context).textTheme.titleLarge),
                      const Divider(height: 24),
                      const _KeyValue(label: 'Member', value: 'NCRRA-000784'),
                      const SizedBox(height: 8),
                      const _KeyValue(label: 'Due date', value: '01 Jul 2025')
                    ])),
            const SizedBox(height: 16),
            Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                    color: NcrraColors.warmSand,
                    borderRadius: BorderRadius.all(NcrraRadius.control)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.calendar_clock,
                          size: 19, color: NcrraColors.amberText),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('Payment due 01 Jul 2025',
                                style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 3),
                            Text('Pay now to keep your membership active.',
                                style: Theme.of(context).textTheme.bodySmall)
                          ]))
                    ])),
            const SizedBox(height: 22),
            Text('Choose how to pay',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            const _SelectedService(
                title: 'M-PESA',
                body: 'Confirm securely on your phone',
                icon: LucideIcons.smartphone),
            const SizedBox(height: 8),
            _ServiceRow(
                icon: LucideIcons.credit_card,
                title: 'Debit or credit card',
                body: 'Use an approved card processor',
                onTap: () => _transitionTo(_BillingState.error)),
            const SizedBox(height: 20),
            Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    color: NcrraColors.mintSurface,
                    borderRadius: BorderRadius.all(NcrraRadius.control)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.shield_check,
                          size: 17, color: NcrraColors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'This prototype simulates payment. NCRRA does not store your payment PIN.',
                              style: Theme.of(context).textTheme.bodySmall))
                    ])),
            const SizedBox(height: 12),
            Text('Secure confirmation · NCRRA does not store your M-PESA PIN.',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 20),
            OutlinedButton.icon(
                onPressed:
                    _loading ? null : () => _transitionTo(_BillingState.empty),
                icon: const Icon(LucideIcons.search_check, size: 17),
                label: const Text('Check contribution status')),
            const SizedBox(height: 10),
            NcrraPrimaryButton(
                label: 'Continue to M-PESA',
                icon: LucideIcons.arrow_right,
                loading: _loading,
                loadingLabel: 'Opening M-PESA…',
                onPressed: () => _transitionTo(_BillingState.success)),
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
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(title: 'Payment status'),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const SizedBox(height: 54),
              const NcrraIcon(
                  icon: LucideIcons.circle_check, tone: NcrraStatusTone.teal),
              const SizedBox(height: 20),
              Text('Payment request received',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                  'Confirm the M-PESA prompt on your phone. Your membership will update after the provider confirms the payment.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 22),
              Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                      color: NcrraColors.mintSurface,
                      borderRadius: BorderRadius.all(NcrraRadius.control)),
                  child: const _KeyValue(
                      label: 'Reference', value: 'Awaiting confirmation')),
              const SizedBox(height: 24),
              NcrraTransitionButton(
                  label: 'Return to payment',
                  loadingLabel: 'Returning…',
                  onPressed: onDone)
            ]))
      ]);
}

class _BillingError extends StatelessWidget {
  const _BillingError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(title: 'Payment status'),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const SizedBox(height: 54),
              const NcrraIcon(
                  icon: LucideIcons.circle_alert, tone: NcrraStatusTone.coral),
              const SizedBox(height: 20),
              Text('Card payment is unavailable',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                  'This prototype has no card processor enabled. Choose M-PESA or try again after an approved processor is connected.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              NcrraTransitionButton(
                  label: 'Try another payment method',
                  loadingLabel: 'Returning to payment…',
                  onPressed: onRetry)
            ]))
      ]);
}

enum _MembershipState { ready, updated, error }

class _BillingEmpty extends StatelessWidget {
  const _BillingEmpty({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(title: 'Payment status'),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const SizedBox(height: 54),
              const NcrraIcon(
                  icon: LucideIcons.file_search, tone: NcrraStatusTone.slate),
              const SizedBox(height: 20),
              Text('No contribution due',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                  'There is no payable contribution on this membership record right now. You can return later when a new annual charge is issued.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              NcrraTransitionButton(
                  label: 'Return to payment',
                  loadingLabel: 'Returning…',
                  onPressed: onDone)
            ]))
      ]);
}

class _MembershipContent extends StatefulWidget {
  const _MembershipContent({required this.onBack});
  final VoidCallback onBack;

  @override
  State<_MembershipContent> createState() => _MembershipContentState();
}

class _MembershipContentState extends State<_MembershipContent> {
  _MembershipState _state = _MembershipState.ready;
  bool _loading = false;

  Future<void> _saveDetails() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;
    setState(() {
      _state = _MembershipState.updated;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _MembershipState.updated) {
      return _MembershipUpdated(
          onDone: () => setState(() => _state = _MembershipState.ready));
    }
    if (_state == _MembershipState.error) {
      return _MembershipLoadError(
          onRetry: () => setState(() => _state = _MembershipState.ready));
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        NcrraTopBar(
            title: 'Membership',
            onBack: widget.onBack,
            action: IconButton(
                tooltip: 'Refresh membership',
                icon:
                    const Icon(LucideIcons.refresh_cw, color: NcrraColors.navy),
                onPressed: () =>
                    setState(() => _state = _MembershipState.error))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                  color: NcrraColors.navy,
                  borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const NcrraIcon(
                          icon: LucideIcons.heart_handshake,
                          color: NcrraColors.white,
                          size: 24),
                      const Spacer(),
                      const NcrraStatusBadge(
                          label: 'Active', tone: NcrraStatusTone.teal),
                    ]),
                    const SizedBox(height: 24),
                    Text('NCRRA member',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: NcrraColors.white)),
                    const SizedBox(height: 6),
                    Text('NCRRA-000784',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFD7E1EC),
                            letterSpacing: 1.2)),
                  ]),
            ),
            const SizedBox(height: 22),
            Text('Membership details',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                  color: NcrraColors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: NcrraColors.border)),
                  borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(
                  children: [
                const _KeyValue(label: 'Member since', value: '12 Jan 2023'),
                const Divider(height: 1),
                const _KeyValue(
                    label: 'Annual contribution', value: 'KES 6,000'),
                const Divider(height: 1),
                const _KeyValue(label: 'Renewal date', value: '01 Jul 2025'),
              ]
                      .map((child) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: child))
                      .toList()),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                  color: NcrraColors.warmSand,
                  borderRadius: BorderRadius.all(NcrraRadius.control)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(LucideIcons.calendar_clock,
                    size: 19, color: NcrraColors.amberText),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Renewal is due',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 3),
                      Text(
                          'Keep your member services active by paying before 01 Jul 2025.',
                          style: Theme.of(context).textTheme.bodySmall),
                    ])),
              ]),
            ),
            const SizedBox(height: 22),
            Text('Payment history',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Container(
              decoration: const BoxDecoration(
                  color: NcrraColors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: NcrraColors.border)),
                  borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(children: [
                const _PaymentHistoryRow(
                    period: '2025 annual contribution',
                    amount: 'KES 6,000',
                    status: 'Due',
                    detail: 'Due 01 Jul 2025'),
                const Divider(height: 1),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(LucideIcons.info,
                              size: 17, color: NcrraColors.mutedText),
                          const SizedBox(width: 9),
                          Expanded(
                              child: Text(
                                  'Completed payments will appear here after provider confirmation.',
                                  style: Theme.of(context).textTheme.bodySmall))
                        ])),
              ]),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (sheetContext) => SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const NcrraIcon(
                                      icon: LucideIcons.receipt_text,
                                      tone: NcrraStatusTone.slate),
                                  const SizedBox(height: 14),
                                  Text('No receipts yet',
                                      style: Theme.of(sheetContext)
                                          .textTheme
                                          .titleMedium),
                                  const SizedBox(height: 6),
                                  Text(
                                      'Confirmed contribution receipts will appear here.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(sheetContext)
                                          .textTheme
                                          .bodyMedium),
                                  const SizedBox(height: 16),
                                  NcrraPrimaryButton(
                                      label: 'Close',
                                      onPressed: () =>
                                          Navigator.of(sheetContext).pop())
                                ])))),
                icon: const Icon(LucideIcons.receipt_text, size: 17),
                label: const Text('View receipts')),
            const SizedBox(height: 8),
            NcrraPrimaryButton(
                label: 'Update member details',
                icon: LucideIcons.pencil_line,
                loading: _loading,
                loadingLabel: 'Saving details…',
                onPressed: _saveDetails),
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
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(title: 'Membership'),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const SizedBox(height: 54),
              const NcrraIcon(
                  icon: LucideIcons.circle_check, tone: NcrraStatusTone.teal),
              const SizedBox(height: 20),
              Text('Details saved securely',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                  'Your updated member details will be reviewed according to NCRRA consent controls.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              NcrraTransitionButton(
                  label: 'Return to membership',
                  loadingLabel: 'Returning…',
                  onPressed: onDone)
            ]))
      ]);
}

class _MembershipLoadError extends StatelessWidget {
  const _MembershipLoadError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(title: 'Membership'),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const SizedBox(height: 54),
              const NcrraIcon(
                  icon: LucideIcons.circle_alert, tone: NcrraStatusTone.coral),
              const SizedBox(height: 20),
              Text('Membership details unavailable',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                  'We could not refresh the member record. Your last known details remain protected; try again when the connection is available.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              NcrraTransitionButton(
                  label: 'Try again',
                  loadingLabel: 'Refreshing membership…',
                  onPressed: onRetry)
            ]))
      ]);
}
