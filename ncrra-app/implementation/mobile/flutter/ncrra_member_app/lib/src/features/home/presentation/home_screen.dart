// NCRRA Trusted Member Utility: practical member home surface that opens the approved registration and ticket journeys.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

void _showPrototypeMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.onOpenTickets, required this.onOpenOnboarding, required this.onOpenServices, required this.onOpenReportIssue, required this.onOpenBilling, required this.onOpenMembership, required this.onNavigate, super.key});

  final VoidCallback onOpenTickets;
  final VoidCallback onOpenOnboarding;
  final VoidCallback onOpenServices;
  final VoidCallback onOpenReportIssue;
  final VoidCallback onOpenBilling;
  final VoidCallback onOpenMembership;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 24),
                children: [
                  _HomeHeader(onNotifications: () => _showPrototypeMessage(context, 'You have 2 member updates to review.')),
                  const SizedBox(height: 24),
                  Text('Good morning, Amina', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('Your member services, in one place.', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 18),
                  _MembershipSummary(onOpenMembership: onOpenMembership),
                  const SizedBox(height: 24),
                  Text('Quick actions', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.08,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _QuickAction(icon: LucideIcons.circle_alert, title: 'Report an issue', body: 'Get help with a local service', onTap: onOpenReportIssue),
                      _QuickAction(icon: LucideIcons.ticket, title: 'My tickets', body: 'Search and track requests', onTap: onOpenTickets),
                      _QuickAction(icon: LucideIcons.wallet_cards, title: 'Pay contribution', body: 'Manage your annual contribution', onTap: onOpenBilling),
                      _QuickAction(icon: LucideIcons.plug_zap, title: 'My connections', body: 'Reuse verified service details', onTap: onOpenServices),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Center(child: TextButton(onPressed: onOpenOnboarding, child: const Text('New to NCRRA? Start member registration'))),
                ],
              ),
            ),
            NcrraBottomNavigation(selected: 0, onTap: onNavigate),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onNotifications});
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const NcrraBrandMark(),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(tooltip: 'Notifications', icon: const Icon(LucideIcons.bell, size: 26, color: NcrraColors.navy), onPressed: onNotifications),
            Positioned(
              right: -4,
              top: -5,
              child: Container(
                width: 16,
                height: 16,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFFFA6B60), shape: BoxShape.circle),
                child: Text('2', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: NcrraColors.white, fontSize: 9)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MembershipSummary extends StatelessWidget {
  const _MembershipSummary({required this.onOpenMembership});
  final VoidCallback onOpenMembership;

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
              const NcrraIconOrb(icon: LucideIcons.heart_handshake),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NCRRA member · Active', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text('Member since 12 Jan 2023', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text('Membership ID: NCRRA-000784', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onOpenMembership,
            icon: const Icon(LucideIcons.credit_card, size: 16),
            label: const Text('View membership'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: NcrraColors.teal,
              side: const BorderSide(color: NcrraColors.teal),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(NcrraRadius.control)),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.title, required this.body, this.onTap});

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(NcrraRadius.card),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          color: NcrraColors.white,
          border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
          borderRadius: BorderRadius.all(NcrraRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NcrraIconOrb(icon: icon),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(body, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
