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
          Image.asset('assets/brand/ncrra_mark.png', width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(width: 10),
          Text('NCRRA', style: Theme.of(context).textTheme.headlineSmall),
        ],
      );
}

class NcrraPrimaryButton extends StatelessWidget {
  const NcrraPrimaryButton({required this.label, required this.onPressed, super.key, this.enabled = true, this.icon});
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: NcrraColors.actionNavy,
            foregroundColor: NcrraColors.white,
            disabledForegroundColor: NcrraColors.secondaryText,
            disabledBackgroundColor: const Color(0xFFC9CFD5),
            elevation: enabled ? 1 : 0,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(NcrraRadius.control)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 8)], Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: NcrraColors.white)))]),
        ),
      );
}

class NcrraIconOrb extends StatelessWidget {
  const NcrraIconOrb({required this.icon, super.key, this.tone = NcrraStatusTone.teal});
  final IconData icon;
  final NcrraStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      NcrraStatusTone.amber => (const Color(0xFFFFF4DD), NcrraColors.amberText),
      NcrraStatusTone.coral => (const Color(0xFFFFF0EC), NcrraColors.coral),
      _ => (NcrraColors.mintOrb, NcrraColors.dustyBlue),
    };
    return Container(width: 44, height: 44, decoration: BoxDecoration(color: background, shape: BoxShape.circle), child: Icon(icon, size: 20, color: foreground));
  }
}

class NcrraStatusBadge extends StatelessWidget {
  const NcrraStatusBadge({required this.label, super.key, this.tone = NcrraStatusTone.teal});
  final String label;
  final NcrraStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      NcrraStatusTone.amber => (NcrraColors.amberSurface, NcrraColors.amberText),
      NcrraStatusTone.coral => (const Color(0xFFFFF0EC), NcrraColors.coral),
      NcrraStatusTone.slate => (NcrraColors.slateSurface, const Color(0xFF475569)),
      _ => (NcrraColors.mintBadge, NcrraColors.dustyBlue),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: const BorderRadius.all(NcrraRadius.pill)),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground)),
    );
  }
}

class NcrraTopBar extends StatelessWidget {
  const NcrraTopBar({required this.title, super.key, this.onBack, this.action});
  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 16),
        child: Row(children: [
          if (onBack != null) ...[
            IconButton(icon: const Icon(LucideIcons.arrow_left, size: 24), onPressed: onBack, color: NcrraColors.navy, tooltip: 'Back'),
            const SizedBox(width: 4),
          ],
          Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
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
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: NcrraColors.mutedText)),
      ]);
}

class NcrraConsentRow extends StatelessWidget {
  const NcrraConsentRow({required this.title, required this.description, required this.value, required this.onChanged, super.key, this.required = false, this.optional = false});
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
            Checkbox(value: value, onChanged: (next) => onChanged(next ?? false), activeColor: NcrraColors.dustyBlue, side: const BorderSide(color: Color(0xFFB8C0C6))),
            const SizedBox(width: 4),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(text: TextSpan(style: Theme.of(context).textTheme.labelLarge, children: [TextSpan(text: title), if (required) const TextSpan(text: '  Required', style: TextStyle(color: NcrraColors.coral)), if (optional) const TextSpan(text: '  Optional', style: TextStyle(color: NcrraColors.mutedText, fontWeight: FontWeight.w500))])),
              const SizedBox(height: 5),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ])),
          ]),
        ),
      );
}

class NcrraBottomNavigation extends StatelessWidget {
  const NcrraBottomNavigation({required this.selected, required this.onTap, super.key});
  final int selected;
  final ValueChanged<int> onTap;

  static const _items = <({String label, IconData icon})>[
    (label: 'Home', icon: LucideIcons.house),
    (label: 'Services', icon: LucideIcons.menu),
    (label: 'Community', icon: LucideIcons.users_round),
    (label: 'Benefits', icon: LucideIcons.tag),
    (label: 'Account', icon: LucideIcons.user_round),
  ];

  @override
  Widget build(BuildContext context) => Container(
        height: 72,
        decoration: const BoxDecoration(color: Color(0xFFFDFCF9), border: Border(top: BorderSide(color: Color(0xFFE4E7E6)))),
        child: Row(children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = index == selected;
          return Expanded(child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(index),
              child: Semantics(
                button: true,
                label: item.label,
                selected: isSelected,
                child: Stack(alignment: Alignment.center, children: [
              if (isSelected) Positioned(top: 0, child: Container(width: 40, height: 4, decoration: const BoxDecoration(color: NcrraColors.dustyBlue, borderRadius: BorderRadius.all(NcrraRadius.pill)))),
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(item.icon, size: 20, color: isSelected ? NcrraColors.dustyBlue : NcrraColors.mutedText), const SizedBox(height: 4), Text(item.label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isSelected ? NcrraColors.dustyBlue : NcrraColors.mutedText))]),
                ]),
              ),
            ),
          ));
        })),
      );
}
