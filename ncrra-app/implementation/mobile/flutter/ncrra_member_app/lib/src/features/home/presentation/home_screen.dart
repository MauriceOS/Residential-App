// NCRRA Trusted Member Utility: practical member home surface that opens the approved registration and ticket journeys.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

void _showPrototypeMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2)));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {required this.onOpenTickets,
      required this.onOpenOnboarding,
      required this.onOpenServices,
      required this.onOpenReportIssue,
      required this.onOpenBilling,
      required this.onOpenMembership,
      required this.onOpenUtility,
      required this.onNavigate,
      super.key});

  final VoidCallback onOpenTickets;
  final VoidCallback onOpenOnboarding;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenReportIssue;
  final VoidCallback onOpenBilling;
  final VoidCallback onOpenMembership;
  final ValueChanged<String> onOpenUtility;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: NcrraUtilityDrawer(
        onSelect: (label) {
          Navigator.of(context).pop();
          switch (label) {
            case 'Member ID & association':
            case 'Receipts & payment history':
            case 'Notifications & notices':
            case 'Data & privacy':
            case 'Security checkup':
            case 'Help centre':
            case 'Contact NCRRA':
              onOpenUtility(label);
            case 'Sign out':
              _showPrototypeMessage(context,
                  'Sign out is protected by the authentication session.');
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 24),
                children: [
                  _HomeHeader(
                      onMenu: () => scaffoldKey.currentState?.openDrawer(),
                      onNotifications: () => _showPrototypeMessage(
                          context, 'You have 2 member updates to review.')),
                  const SizedBox(height: 24),
                  Text('Good morning, Amina',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('Your member services, in one place.',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  _MembershipSummary(onOpenMembership: onOpenMembership),
                  const SizedBox(height: 24),
                  Text('Quick actions',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      _QuickAction(
                          icon: LucideIcons.circle_alert,
                          title: 'Report an issue',
                          body: 'Get help with a local service',
                          onTap: onOpenReportIssue),
                      const SizedBox(height: 8),
                      _QuickAction(
                          icon: LucideIcons.ticket,
                          title: 'My tickets',
                          body: 'Search and track requests',
                          onTap: onOpenTickets),
                      const SizedBox(height: 8),
                      _QuickAction(
                          icon: LucideIcons.wallet_cards,
                          title: 'Pay contribution',
                          body: 'Manage your annual contribution',
                          onTap: onOpenBilling),
                      const SizedBox(height: 8),
                      _QuickAction(
                          icon: LucideIcons.cable,
                          title: 'My connections',
                          body: 'Reuse verified service details',
                          onTap: onOpenServices),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Center(
                      child: TextButton(
                          onPressed: onOpenOnboarding,
                          child: const Text(
                              'New to NCRRA? Start member registration'))),
                ],
              ),
            ),
            RepaintBoundary(
              child: NcrraBottomNavigation(selected: 0, onTap: onNavigate),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onMenu, required this.onNotifications});
  final VoidCallback onMenu;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Open member menu',
          onPressed: onMenu,
          icon: const Icon(LucideIcons.menu, size: 24),
          color: NcrraColors.navy,
        ),
        const SizedBox(width: 2),
        const NcrraBrandMark(),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
                tooltip: 'Notifications',
                icon: const Icon(LucideIcons.bell,
                    size: 26, color: NcrraColors.navy),
                onPressed: onNotifications),
            Positioned(
              right: -2,
              top: -8,
              child: Text('2',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: NcrraColors.coral,
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ],
    );
  }
}

class _MembershipSummary extends StatefulWidget {
  const _MembershipSummary({required this.onOpenMembership});
  final VoidCallback onOpenMembership;

  @override
  State<_MembershipSummary> createState() => _MembershipSummaryState();
}

class _MembershipSummaryState extends State<_MembershipSummary> {
  bool _loading = false;

  Future<void> _openMembership() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    widget.onOpenMembership();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: NcrraColors.mintSurface,
        border: Border.fromBorderSide(BorderSide(color: Color(0xFFDCE9E5))),
        borderRadius: BorderRadius.all(NcrraRadius.card),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const NcrraIcon(icon: LucideIcons.heart_handshake),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NCRRA member · Active',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text('Member since 12 Jan 2023',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text('Membership ID: NCRRA-000784',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: _loading ? null : _openMembership,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: NcrraColors.teal))
                  : const Icon(LucideIcons.credit_card, size: 16),
              label: Text(_loading ? 'Opening membership…' : 'View membership',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center),
              style: OutlinedButton.styleFrom(
                foregroundColor: NcrraColors.teal,
                disabledForegroundColor: NcrraColors.teal,
                side: const BorderSide(color: NcrraColors.teal),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(NcrraRadius.control)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon,
      required this.title,
      required this.body,
      this.onTap});

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $body',
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(NcrraRadius.card),
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: const BoxDecoration(
            color: NcrraColors.white,
            border:
                Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
            borderRadius: BorderRadius.all(NcrraRadius.card),
          ),
          child: Row(
            children: [
              NcrraIcon(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 3),
                    Text(body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevron_right,
                  size: 18, color: NcrraColors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
