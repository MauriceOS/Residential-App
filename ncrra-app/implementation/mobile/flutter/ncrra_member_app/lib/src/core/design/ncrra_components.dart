// NCRRA Trusted Member Utility: reusable visual primitives for exact screen fidelity.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import 'ncrra_theme.dart';

enum NcrraStatusTone { teal, amber, slate, coral }

class NcrraBrandMark extends StatelessWidget {
  const NcrraBrandMark({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/brand/ncrra_mark.png',
              width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Text('NCRRA', style: Theme.of(context).textTheme.headlineSmall),
        ],
      );
}

class NcrraPrimaryButton extends StatelessWidget {
  const NcrraPrimaryButton(
      {required this.label,
      required this.onPressed,
      super.key,
      this.enabled = true,
      this.icon,
      this.loading = false,
      this.loadingLabel})
      : assert(label != '', 'Primary action labels must not be empty.');
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;
  final bool loading;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    final visibleLabel = loading ? (loadingLabel ?? 'Working…') : label;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Semantics(
        button: true,
        enabled: enabled && !loading,
        label: visibleLabel,
        child: ElevatedButton(
          onPressed: enabled && !loading ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: NcrraColors.actionNavy,
            foregroundColor: NcrraColors.white,
            disabledForegroundColor: NcrraColors.white,
            disabledBackgroundColor: const Color(0xFF8D99A8),
            elevation: enabled ? 1 : 0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.padded,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(NcrraRadius.control)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading) ...[
                const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: NcrraColors.white)),
                const SizedBox(width: 8)
              ] else if (icon != null) ...[
                Icon(icon, size: 16),
                const SizedBox(width: 8)
              ],
              Flexible(
                  child: Text(visibleLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: NcrraColors.white)))
            ],
          ),
        ),
      ),
    );
  }
}

class NcrraTransitionButton extends StatefulWidget {
  const NcrraTransitionButton(
      {required this.label,
      required this.onPressed,
      super.key,
      this.loadingLabel})
      : assert(label != '', 'Transition action labels must not be empty.');
  final String label;
  final VoidCallback onPressed;
  final String? loadingLabel;

  @override
  State<NcrraTransitionButton> createState() => _NcrraTransitionButtonState();
}

class _NcrraTransitionButtonState extends State<NcrraTransitionButton> {
  bool _loading = false;

  Future<void> _handlePressed() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    if (!mounted) return;
    setState(() => _loading = false);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) => NcrraPrimaryButton(
      label: widget.label,
      loading: _loading,
      loadingLabel: widget.loadingLabel ?? 'Working…',
      onPressed: _handlePressed);
}

class NcrraIcon extends StatelessWidget {
  const NcrraIcon(
      {required this.icon,
      super.key,
      this.tone = NcrraStatusTone.teal,
      this.color,
      this.size = 22});
  final IconData icon;
  final NcrraStatusTone tone;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final toneColor = switch (tone) {
      NcrraStatusTone.amber => NcrraColors.amberText,
      NcrraStatusTone.coral => NcrraColors.coral,
      NcrraStatusTone.slate => NcrraColors.mutedText,
      _ => NcrraColors.dustyBlue,
    };
    return SizedBox(
        width: 32,
        height: 32,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(icon, size: size, color: color ?? toneColor)));
  }
}

class NcrraStatusBadge extends StatelessWidget {
  const NcrraStatusBadge(
      {required this.label, super.key, this.tone = NcrraStatusTone.teal});
  final String label;
  final NcrraStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      NcrraStatusTone.amber => (
          NcrraColors.amberSurface,
          NcrraColors.amberText
        ),
      NcrraStatusTone.coral => (const Color(0xFFFFF0EC), NcrraColors.coral),
      NcrraStatusTone.slate => (
          NcrraColors.slateSurface,
          const Color(0xFF475569)
        ),
      _ => (NcrraColors.mintBadge, NcrraColors.dustyBlue),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(NcrraRadius.pill)),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: foreground)),
    );
  }
}

class NcrraUtilityDrawer extends StatelessWidget {
  const NcrraUtilityDrawer({
    required this.onSelect,
    super.key,
  });

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NcrraColors.ivory,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            Row(
              children: [
                const NcrraBrandMark(),
                const Spacer(),
                IconButton(
                  tooltip: 'Close menu',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x),
                  color: NcrraColors.navy,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Amina Wanjiku',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('NCRRA-000784 · Active',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 28),
            _NcrraDrawerGroup(
              title: 'Member record',
              items: const [
                _NcrraDrawerItem(
                    'Member ID & association', LucideIcons.badge_check),
                _NcrraDrawerItem(
                    'Receipts & payment history', LucideIcons.receipt_text),
              ],
              onSelect: onSelect,
            ),
            _NcrraDrawerGroup(
              title: 'Updates & choices',
              items: const [
                _NcrraDrawerItem('Notifications & notices', LucideIcons.bell),
                _NcrraDrawerItem('Data & privacy', LucideIcons.lock_keyhole),
              ],
              onSelect: onSelect,
            ),
            _NcrraDrawerGroup(
              title: 'Help & account safety',
              items: const [
                _NcrraDrawerItem('Security checkup', LucideIcons.shield_check),
                _NcrraDrawerItem(
                    'Help centre', LucideIcons.circle_question_mark),
                _NcrraDrawerItem('Contact NCRRA', LucideIcons.message_circle),
              ],
              onSelect: onSelect,
            ),
            const Divider(height: 28),
            Semantics(
              button: true,
              label: 'Sign out',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const NcrraIcon(
                    icon: LucideIcons.log_out, tone: NcrraStatusTone.coral),
                title: const Text('Sign out'),
                onTap: () => onSelect('Sign out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NcrraDrawerItem {
  const _NcrraDrawerItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _NcrraDrawerGroup extends StatelessWidget {
  const _NcrraDrawerGroup({
    required this.title,
    required this.items,
    required this.onSelect,
  });

  final String title;
  final List<_NcrraDrawerItem> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: NcrraColors.mutedText,
                      letterSpacing: 0.7,
                      fontWeight: FontWeight.w800,
                    )),
            const SizedBox(height: 4),
            ...items.map((item) => Semantics(
                  button: true,
                  label: item.label,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        NcrraIcon(icon: item.icon, tone: NcrraStatusTone.slate),
                    title: Text(item.label),
                    trailing: const Icon(LucideIcons.chevron_right, size: 18),
                    onTap: () => onSelect(item.label),
                  ),
                )),
          ],
        ),
      );
}

class NcrraTopBar extends StatelessWidget {
  const NcrraTopBar({required this.title, super.key, this.onBack, this.action});
  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
            NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 16),
        child: Row(children: [
          if (onBack != null) ...[
            IconButton(
                icon: const Icon(LucideIcons.arrow_left, size: 24),
                onPressed: onBack,
                color: NcrraColors.navy,
                tooltip: 'Back'),
            const SizedBox(width: 4),
          ],
          Expanded(
              child: Text(title,
                  style: Theme.of(context).textTheme.headlineSmall)),
          if (action != null) action!,
        ]),
      );
}

class NcrraProgress extends StatelessWidget {
  const NcrraProgress({required this.step, required this.label, super.key});
  final int step;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        NcrraStatusBadge(label: '$step of 3', tone: NcrraStatusTone.slate),
        const SizedBox(width: 8),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: NcrraColors.mutedText)),
      ]);
}

class NcrraConsentRow extends StatelessWidget {
  const NcrraConsentRow(
      {required this.title,
      required this.description,
      required this.value,
      required this.onChanged,
      super.key,
      this.required = false,
      this.optional = false});
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool required;
  final bool optional;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Checkbox(
                value: value,
                onChanged: (next) => onChanged(next ?? false),
                activeColor: NcrraColors.dustyBlue,
                side: const BorderSide(color: Color(0xFFB8C0C6))),
            const SizedBox(width: 4),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.labelLarge,
                          children: [
                        TextSpan(text: title),
                        if (required)
                          const TextSpan(
                              text: '  Required',
                              style: TextStyle(color: NcrraColors.coral)),
                        if (optional)
                          const TextSpan(
                              text: '  Optional',
                              style: TextStyle(
                                  color: NcrraColors.mutedText,
                                  fontWeight: FontWeight.w500))
                      ])),
                  const SizedBox(height: 5),
                  Text(description,
                      style: Theme.of(context).textTheme.bodySmall),
                ])),
          ]),
        ),
      );
}

class NcrraBottomNavigation extends StatelessWidget {
  const NcrraBottomNavigation(
      {required this.selected, required this.onTap, super.key});
  final int selected;
  final ValueChanged<int> onTap;

  static const _items = <({String label, IconData icon})>[
    (label: 'Home', icon: LucideIcons.house),
    (label: 'Services', icon: LucideIcons.list_checks),
    (label: 'Community', icon: LucideIcons.users_round),
    (label: 'Benefits', icon: LucideIcons.tag),
    (label: 'Account', icon: LucideIcons.user_round),
  ];

  @override
  Widget build(BuildContext context) => Container(
        height: 72,
        decoration: const BoxDecoration(
            color: Color(0xFFFDFCF9),
            border: Border(top: BorderSide(color: Color(0xFFE4E7E6)))),
        child: Row(
            children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = index == selected;
          return Expanded(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(index),
              child: Semantics(
                button: true,
                label: item.label,
                selected: isSelected,
                child: Stack(alignment: Alignment.center, children: [
                  if (isSelected)
                    Positioned(
                        top: 0,
                        child: Container(
                            width: 40,
                            height: 4,
                            decoration: const BoxDecoration(
                                color: NcrraColors.dustyBlue,
                                borderRadius:
                                    BorderRadius.all(NcrraRadius.pill)))),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon,
                            size: 20,
                            color: isSelected
                                ? NcrraColors.dustyBlue
                                : NcrraColors.mutedText),
                        const SizedBox(height: 4),
                        Text(item.label,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: isSelected
                                        ? NcrraColors.dustyBlue
                                        : NcrraColors.mutedText))
                      ]),
                ]),
              ),
            ),
          ));
        })),
      );
}
