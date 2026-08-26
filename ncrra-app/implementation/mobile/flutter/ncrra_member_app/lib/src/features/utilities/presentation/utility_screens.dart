import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

enum NcrraUtilityDestination {
  memberRecord,
  receipts,
  notifications,
  privacy,
  security,
  helpCentre,
  contact,
}

String ncrraUtilityLabel(NcrraUtilityDestination destination) =>
    switch (destination) {
      NcrraUtilityDestination.memberRecord => 'Member ID & association',
      NcrraUtilityDestination.receipts => 'Receipts & payment history',
      NcrraUtilityDestination.notifications => 'Notifications & notices',
      NcrraUtilityDestination.privacy => 'Data & privacy',
      NcrraUtilityDestination.security => 'Security checkup',
      NcrraUtilityDestination.helpCentre => 'Help centre',
      NcrraUtilityDestination.contact => 'Contact NCRRA',
    };

class UtilityScreen extends StatelessWidget {
  const UtilityScreen(
      {required this.destination, required this.onBack, super.key});

  final NcrraUtilityDestination destination;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              NcrraTopBar(title: _title, onBack: onBack),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                      NcrraSpacing.gutter, 0, NcrraSpacing.gutter, 32),
                  children: [
                    _intro(context),
                    const SizedBox(height: 20),
                    _content(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  String get _title => switch (destination) {
        NcrraUtilityDestination.memberRecord => 'Member record',
        NcrraUtilityDestination.receipts => 'Receipts & history',
        NcrraUtilityDestination.notifications => 'Notifications & notices',
        NcrraUtilityDestination.privacy => 'Data & privacy',
        NcrraUtilityDestination.security => 'Security checkup',
        NcrraUtilityDestination.helpCentre => 'Help centre',
        NcrraUtilityDestination.contact => 'Contact NCRRA',
      };

  Widget _intro(BuildContext context) => Text(
        switch (destination) {
          NcrraUtilityDestination.memberRecord =>
            'Your association identity is kept separate from service-provider records.',
          NcrraUtilityDestination.receipts =>
            'Keep contribution confirmations in one place for your own records.',
          NcrraUtilityDestination.notifications =>
            'Review announcements and member notices without leaving your current task.',
          NcrraUtilityDestination.privacy =>
            'Review the choices that control how NCRRA uses your member data.',
          NcrraUtilityDestination.security =>
            'Check the protections around your member account and sign-in session.',
          NcrraUtilityDestination.helpCentre =>
            'Find guidance for member services before contacting support.',
          NcrraUtilityDestination.contact =>
            'Choose the support route that matches your request. Provider credentials are never requested here.',
        },
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget _content(BuildContext context) => switch (destination) {
        NcrraUtilityDestination.memberRecord => const _UtilityList(items: [
            _UtilityItem('Member ID', 'NCRRA-000784', LucideIcons.badge_check),
            _UtilityItem(
                'Association', 'NCRRA · Nairobi chapter', LucideIcons.landmark),
            _UtilityItem(
                'Member since', '12 January 2023', LucideIcons.calendar_days),
          ]),
        NcrraUtilityDestination.receipts => const _UtilityList(items: [
            _UtilityItem('2025 annual contribution',
                'Paid 30 June 2025 · KES 6,000', LucideIcons.receipt_text),
            _UtilityItem('2024 annual contribution',
                'Paid 28 June 2024 · KES 6,000', LucideIcons.receipt_text),
          ]),
        NcrraUtilityDestination.notifications => const _UtilityList(items: [
            _UtilityItem('Association update',
                'Two member notices are waiting for review.', LucideIcons.bell),
            _UtilityItem(
                'Service status',
                'Provider updates will appear against the relevant request.',
                LucideIcons.radio),
          ]),
        NcrraUtilityDestination.privacy => const _UtilityList(items: [
            _UtilityItem('Membership administration',
                'Required for member services', LucideIcons.badge_check),
            _UtilityItem(
                'Provider routing',
                'Shared only for a requested service action',
                LucideIcons.route),
            _UtilityItem('Association updates',
                'Announcements and activity notices', LucideIcons.megaphone),
          ]),
        NcrraUtilityDestination.security => const _UtilityList(items: [
            _UtilityItem('Sign-in protection',
                'OIDC authorization code with PKCE', LucideIcons.shield_check),
            _UtilityItem('Biometric login', 'Available on supported devices',
                LucideIcons.smartphone),
            _UtilityItem(
                'Active sessions', '1 trusted device', LucideIcons.smartphone),
          ]),
        NcrraUtilityDestination.helpCentre => const _UtilityList(items: [
            _UtilityItem(
                'How service requests work',
                'NCRRA routes a request to the approved provider.',
                LucideIcons.circle_question_mark),
            _UtilityItem(
                'How contributions work',
                'Review your annual contribution and receipt.',
                LucideIcons.wallet_cards),
            _UtilityItem(
                'How to protect your account',
                'Use only the official app and sign out of shared devices.',
                LucideIcons.lock_keyhole),
          ]),
        NcrraUtilityDestination.contact => const _UtilityList(items: [
            _UtilityItem(
                'Member support',
                'Membership, contributions or notices',
                LucideIcons.message_circle),
            _UtilityItem('Association office',
                'Association administration matters', LucideIcons.building_2),
          ]),
      };
}

class _UtilityItem {
  const _UtilityItem(this.title, this.subtitle, this.icon);

  final String title;
  final String subtitle;
  final IconData icon;
}

class _UtilityList extends StatelessWidget {
  const _UtilityList({required this.items});

  final List<_UtilityItem> items;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: NcrraColors.white,
            border: Border.all(color: NcrraColors.border),
            borderRadius: const BorderRadius.all(NcrraRadius.card)),
        child: Column(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              _UtilityListTile(item: items[index]),
              if (index < items.length - 1)
                const Divider(height: 1, indent: 56, endIndent: 16),
            ],
          ],
        ),
      );
}

class _UtilityListTile extends StatelessWidget {
  const _UtilityListTile({required this.item});

  final _UtilityItem item;

  @override
  Widget build(BuildContext context) => Material(
        color: NcrraColors.white,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: NcrraIcon(icon: item.icon, tone: NcrraStatusTone.slate),
          title:
              Text(item.title, style: Theme.of(context).textTheme.labelLarge),
          subtitle:
              Text(item.subtitle, style: Theme.of(context).textTheme.bodySmall),
          trailing: const Icon(LucideIcons.chevron_right, size: 18),
          onTap: () => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text('${item.title} is ready for the member release.'),
                behavior: SnackBarBehavior.floating)),
        ),
      );
}
