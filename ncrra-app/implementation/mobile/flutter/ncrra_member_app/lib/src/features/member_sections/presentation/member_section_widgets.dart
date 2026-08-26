part of 'member_section_screens.dart';

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow(
      {required this.period,
      required this.amount,
      required this.status,
      required this.detail});
  final String period;
  final String amount;
  final String status;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(period, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(detail, style: Theme.of(context).textTheme.bodySmall)
        ])),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amount, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 5),
          NcrraStatusBadge(label: status, tone: NcrraStatusTone.amber)
        ])
      ]));
}

class _CommunityContent extends StatelessWidget {
  const _CommunityContent();
  @override
  Widget build(BuildContext context) => _SimpleSection(
      title: 'Community',
      icon: LucideIcons.users_round,
      tabs: const ['Announcements', 'Activities', 'Events'],
      heading: 'Stay close to what is happening',
      body:
          'Read association announcements, activities and member updates in one trusted place.',
      items: const [
        (
          'Annual general meeting',
          'Saturday, 31 May 2025 · NCRRA Community Centre',
          LucideIcons.calendar_clock
        ),
        (
          'Neighbourhood clean-up',
          '22 Jun 2025 · 09:00 AM',
          LucideIcons.circle_alert
        ),
        ('Member notice', 'Updated 10 Jun 2025', LucideIcons.bell)
      ]);
}

class _BenefitsContent extends StatelessWidget {
  const _BenefitsContent();
  @override
  Widget build(BuildContext context) => _SimpleSection(
      title: 'Benefits',
      icon: LucideIcons.tag,
      tabs: const ['All', 'Travel', 'Home', 'Shopping'],
      heading: 'Useful offers for NCRRA members',
      body:
          'Access partner offers when they are available. Eligibility and terms are shown before you use an offer.',
      items: const [
        ('15% off partner travel', 'Travel · View terms', LucideIcons.tag),
        ('10% off home services', 'Home · View details', LucideIcons.house),
        (
          'Local transport partners',
          'Available offers · Explore',
          LucideIcons.ticket
        )
      ]);
}

class _AccountContent extends StatelessWidget {
  const _AccountContent({this.onOpenMembership});
  final VoidCallback? onOpenMembership;
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(
            title: 'Account',
            action: IconButton(
                tooltip: 'Notifications',
                icon: const Icon(LucideIcons.bell, color: NcrraColors.navy),
                onPressed: () => _showPrototypeMessage(
                    context, 'You have no new account alerts.'))),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child: Column(children: [
              const _ProfileRow(),
              const SizedBox(height: 20),
              _AccountGroup(
                  title: 'Membership',
                  items: const [
                    'My membership',
                    'Household and contacts',
                    'My receipts'
                  ],
                  onItemTap: (item) => item == 'My membership'
                      ? onOpenMembership?.call()
                      : _showPrototypeMessage(
                          context, '$item: this setting will open here.')),
              _AccountGroup(title: 'Security', items: const [
                'Biometric login',
                'Password and recovery',
                'Active devices'
              ]),
              _AccountGroup(title: 'Privacy', items: const [
                'Provider connections',
                'Consent and data access',
                'Notification preferences'
              ]),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                  onPressed: () => _showPrototypeMessage(context,
                      'Sign out is protected by confirmation in the production app.'),
                  icon: const Icon(LucideIcons.log_out, size: 17),
                  label: const Text('Sign out'))
            ]))
      ]);
}

class _SimpleSection extends StatelessWidget {
  const _SimpleSection(
      {required this.title,
      required this.icon,
      required this.tabs,
      required this.heading,
      required this.body,
      required this.items});
  final String title;
  final IconData icon;
  final List<String> tabs;
  final String heading;
  final String body;
  final List<(String, String, IconData)> items;
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        NcrraTopBar(
            title: title,
            action: IconButton(
                tooltip: 'Search $title',
                icon: const Icon(LucideIcons.search, color: NcrraColors.navy),
                onPressed: () =>
                    _showPrototypeMessage(context, 'Search $title below.'))),
        Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: NcrraColors.border))),
          padding: const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
          child: Row(
              children: List.generate(
                  tabs.length,
                  (index) => Expanded(
                        child: Column(children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(tabs[index],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                          color: index == 0
                                              ? NcrraColors.teal
                                              : NcrraColors.mutedText))),
                          Container(
                              height: 3,
                              color: index == 0
                                  ? NcrraColors.teal
                                  : Colors.transparent)
                        ]),
                      ))),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(heading, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ServiceRow(
                      icon: item.$3,
                      title: item.$1,
                      body: item.$2,
                      onTap: () => _showPrototypeMessage(
                          context, '${item.$1}: details will be shown here.'))))
            ]))
      ]);
}

class _ConnectionRow extends StatelessWidget {
  const _ConnectionRow({required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
          color: NcrraColors.white,
          border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
          borderRadius: BorderRadius.all(NcrraRadius.card)),
      child: Row(children: [
        NcrraIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 3),
          const NcrraStatusBadge(label: 'Verified')
        ]))
      ]));
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow(
      {required this.icon,
      required this.title,
      required this.body,
      this.onTap});
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
                border: Border.fromBorderSide(
                    BorderSide(color: NcrraColors.border)),
                borderRadius: BorderRadius.all(NcrraRadius.card),
              ),
              child: Row(
                children: [
                  NcrraIcon(icon: icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Text(body,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevron_right,
                      size: 20, color: NcrraColors.mutedText),
                ],
              ),
            ),
          ),
        ),
      );
}

class _SelectedService extends StatelessWidget {
  const _SelectedService(
      {required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
          color: NcrraColors.mintSurface,
          border: Border.fromBorderSide(
              BorderSide(color: NcrraColors.teal, width: 2)),
          borderRadius: BorderRadius.all(NcrraRadius.card)),
      child: Row(children: [
        NcrraIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(body, style: Theme.of(context).textTheme.bodySmall)
        ])),
        const Icon(LucideIcons.circle_check, size: 20, color: NcrraColors.teal)
      ]));
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: Text(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall)),
        const SizedBox(width: 12),
        Flexible(
            child: Text(value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelMedium))
      ]);
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow();
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
          color: NcrraColors.white,
          border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)),
          borderRadius: BorderRadius.all(NcrraRadius.card)),
      child: Row(children: [
        const NcrraIcon(icon: LucideIcons.user_round),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Amina Wanjiku', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text('amina@example.com',
              style: Theme.of(context).textTheme.bodySmall)
        ])),
        const SizedBox(width: 20)
      ]));
}

class _AccountGroup extends StatelessWidget {
  const _AccountGroup(
      {required this.title, required this.items, this.onItemTap});
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
                border: Border.fromBorderSide(
                    BorderSide(color: NcrraColors.border)),
                borderRadius: BorderRadius.all(NcrraRadius.card),
              ),
              child: Column(
                children: items
                    .map((item) => Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            title: Text(item,
                                style: Theme.of(context).textTheme.labelLarge),
                            trailing: const Icon(LucideIcons.chevron_right,
                                size: 19, color: NcrraColors.mutedText),
                            onTap: () => onItemTap != null
                                ? onItemTap!(item)
                                : _showPrototypeMessage(context,
                                    '$item: this setting will open here.'),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
