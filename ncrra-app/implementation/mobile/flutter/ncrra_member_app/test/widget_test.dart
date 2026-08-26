import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:ncrra_member_app/src/app.dart';
import 'package:ncrra_member_app/src/core/design/ncrra_components.dart';
import 'package:ncrra_member_app/src/core/design/ncrra_theme.dart';
import 'package:ncrra_member_app/src/features/home/presentation/home_screen.dart';
import 'package:ncrra_member_app/src/features/member_sections/presentation/member_section_screens.dart';
import 'package:ncrra_member_app/src/features/utilities/presentation/utility_screens.dart';

void main() {
  test('NCRRA design system retains the canonical service colours', () {
    expect(NcrraColors.teal.toARGB32(), 0xFF2C7D78);
    expect(NcrraColors.navy.toARGB32(), 0xFF0B1E3B);
  });
  testWidgets(
      'Home renders labeled membership and quick actions and routes taps',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final opened = <String>[];
    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: HomeScreen(
        onOpenTickets: () => opened.add('tickets'),
        onOpenOnboarding: () => opened.add('onboarding'),
        onOpenServices: () => opened.add('services'),
        onOpenReportIssue: () => opened.add('report'),
        onOpenBilling: () => opened.add('billing'),
        onOpenMembership: () => opened.add('membership'),
        onOpenUtility: (_) {},
        onNavigate: (index) => opened.add('tab-$index'),
      ),
    ));

    for (final label in <String>[
      'View membership',
      'Report an issue',
      'My tickets',
      'Pay contribution',
      'My connections'
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    final menuIcon = find.byIcon(LucideIcons.menu);
    expect(menuIcon, findsOneWidget);
    final menuTarget = find.ancestor(
      of: menuIcon,
      matching: find.byType(IconButton),
    );
    expect(tester.getSize(menuTarget.first).width, greaterThanOrEqualTo(44));
    expect(tester.getSize(menuTarget.first).height, greaterThanOrEqualTo(44));

    for (final label in <String>[
      'View membership',
      'Report an issue',
      'My tickets',
      'Pay contribution',
      'My connections'
    ]) {
      await tester.tap(find.text(label));
    }
    await tester.pump(const Duration(milliseconds: 300));

    expect(
        opened,
        containsAll(<String>[
          'membership',
          'report',
          'tickets',
          'billing',
          'services'
        ]));
  });

  testWidgets(
      'Primary buttons expose loading feedback without losing their label',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(),
        home: const NcrraPrimaryButton(
            label: 'Continue to M-PESA',
            loading: true,
            loadingLabel: 'Opening M-PESA…',
            onPressed: null)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Opening M-PESA…'), findsOneWidget);
  });

  testWidgets('View membership shows loading feedback on a compact phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var opened = false;
    await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(),
        home: HomeScreen(
            onOpenTickets: () {},
            onOpenOnboarding: () {},
            onOpenServices: () {},
            onOpenReportIssue: () {},
            onOpenBilling: () {},
            onOpenMembership: () => opened = true,
            onOpenUtility: (_) {},
            onNavigate: (_) {})));
    expect(find.text('View membership'), findsOneWidget);
    await tester.tap(find.text('View membership'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Opening membership…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 240));
    expect(opened, isTrue);
  });

  testWidgets('Transition buttons block repeat taps while loading',
      (tester) async {
    const cases = <({String label, String loadingLabel})>[
      (label: 'Return to payment', loadingLabel: 'Returning…'),
      (
        label: 'Try another payment method',
        loadingLabel: 'Returning to payment…'
      ),
      (label: 'Return to membership', loadingLabel: 'Returning…'),
      (label: 'Try again', loadingLabel: 'Refreshing membership…'),
    ];

    for (final item in cases) {
      var callbacks = 0;
      await tester.pumpWidget(MaterialApp(
          theme: ncrraTheme(),
          home: NcrraTransitionButton(
              label: item.label,
              loadingLabel: item.loadingLabel,
              onPressed: () => callbacks++)));
      await tester.tap(find.byType(ElevatedButton));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text(item.loadingLabel), findsOneWidget);
      expect(callbacks, 0);
      await tester.pump(const Duration(milliseconds: 220));
      expect(callbacks, 1);
    }
  });

  testWidgets('Home bottom navigation exposes all labeled destinations',
      (tester) async {
    final selected = <int>[];
    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: HomeScreen(
        onOpenTickets: () {},
        onOpenOnboarding: () {},
        onOpenServices: () {},
        onOpenReportIssue: () {},
        onOpenBilling: () {},
        onOpenMembership: () {},
        onOpenUtility: (_) {},
        onNavigate: selected.add,
      ),
    ));

    for (final label in <String>[
      'Home',
      'Services',
      'Community',
      'Benefits',
      'Account'
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Services'));
    await tester.tap(find.text('Community'));
    await tester.tap(find.text('Benefits'));
    await tester.tap(find.text('Account'));
    await tester.pump();

    expect(selected, <int>[1, 2, 3, 4]);
  });

  testWidgets(
      'icon semantics distinguish catalogue, connections and meter flows',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: MemberSectionScreen(
        section: MemberSection.services,
        onBack: () {},
        onNavigate: (_) {},
        onOpenReportIssue: () {},
      ),
    ));
    await tester.pump();
    expect(find.text('Kenya Power · Meter ending 7842'), findsOneWidget);
    expect(find.byIcon(LucideIcons.gauge), findsWidgets);
    expect(find.byIcon(LucideIcons.cable), findsNothing);
    expect(find.byIcon(LucideIcons.zap), findsNothing);

    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: MemberSectionScreen(
        section: MemberSection.community,
        onBack: () {},
        onNavigate: (_) {},
      ),
    ));
    await tester.pump();
    expect(find.text('Stay close to what is happening'), findsOneWidget);
    expect(find.text('NCRRA COMMUNITY'), findsNothing);

    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: MemberSectionScreen(
        section: MemberSection.benefits,
        onBack: () {},
        onNavigate: (_) {},
      ),
    ));
    await tester.pump();
    expect(find.text('Useful offers for NCRRA members'), findsOneWidget);
    expect(find.text('MEMBER BENEFITS'), findsNothing);
  });

  testWidgets('NCRRA app routes primary tabs, membership and billing actions',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NcrraApp());
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    await tester.tap(find.text('View membership'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.text('Membership').first, findsOneWidget);
    expect(find.text('Membership details'), findsOneWidget);
    expect(find.text('Renewal is due'), findsOneWidget);
    expect(find.text('Payment history'), findsOneWidget);
    expect(find.text('2025 annual contribution'), findsOneWidget);
    expect(find.text('KES 6,000'), findsWidgets);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Pay contribution'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.text('Continue to M-PESA'), findsOneWidget);
    await tester.tap(find.text('Continue to M-PESA'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Payment request received'), findsOneWidget);
    expect(find.textContaining('Confirm the M-PESA prompt on your phone.'),
        findsOneWidget);
  });

  testWidgets(
      'Member sections expose actionable service, benefit and account controls',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pumpSection(MemberSection section) async {
      await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(),
        home: MemberSectionScreen(
          section: section,
          onBack: () {},
          onNavigate: (_) {},
          onOpenReportIssue: () {},
        ),
      ));
      await tester.pump();
    }

    await pumpSection(MemberSection.services);
    expect(find.text('What do you need help with?'), findsOneWidget);
    await tester.tap(find.text('Add another connection'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    await pumpSection(MemberSection.community);
    expect(find.text('Stay close to what is happening'), findsOneWidget);
    await tester.tap(find.text('Annual general meeting'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    await pumpSection(MemberSection.benefits);
    expect(find.text('Useful offers for NCRRA members'), findsOneWidget);
    await tester.tap(find.text('15% off partner travel'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    await pumpSection(MemberSection.account);
    expect(find.text('Security'), findsOneWidget);
    await tester.tap(find.text('Active devices'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    await pumpSection(MemberSection.billing);
    expect(find.text('Renew your NCRRA membership'), findsOneWidget);
    await tester.tap(find.text('Debit or credit card'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Card payment is unavailable'), findsOneWidget);
    await tester.tap(find.text('Try another payment method'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Returning to payment…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Continue to M-PESA'), findsOneWidget);
    await tester.tap(find.text('Continue to M-PESA'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Payment request received'), findsOneWidget);
    await tester.tap(find.text('Return to payment'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Returning…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Renew your NCRRA membership'), findsOneWidget);
    await tester.tap(find.text('Check contribution status'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('No contribution due'), findsOneWidget);
    await tester.tap(find.text('Return to payment'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Returning…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Renew your NCRRA membership'), findsOneWidget);

    await pumpSection(MemberSection.membership);
    expect(find.text('Membership details'), findsOneWidget);
    await tester.tap(find.text('View receipts'));
    await tester.pumpAndSettle();
    expect(find.text('No receipts yet'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Membership details'), findsOneWidget);
    await tester.tap(find.text('Update member details'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Saving details…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Details saved securely'), findsOneWidget);
    await tester.tap(find.text('Return to membership'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Returning…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Membership details'), findsOneWidget);
    await tester.tap(find.byTooltip('Refresh membership'));
    await tester.pump();
    expect(find.text('Membership details unavailable'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump(const Duration(milliseconds: 80));
    expect(find.text('Refreshing membership…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Membership details'), findsOneWidget);
  });

  testWidgets(
      'Compact phone keeps primary labels visible in billing and membership',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(),
        home: MemberSectionScreen(
            section: MemberSection.billing,
            onBack: () {},
            onNavigate: (_) {})));
    await tester.pump();
    expect(find.text('Continue to M-PESA'), findsOneWidget);
    expect(find.text('Check contribution status'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -800));
    await tester.pump();
    await tester.tap(find.text('Continue to M-PESA'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Payment request received'), findsOneWidget);
  });

  testWidgets(
      'Visual primitives keep icons standalone and action labels visible',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(), home: const NcrraIcon(icon: LucideIcons.search)));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(DecoratedBox), findsNothing);

    await tester.pumpWidget(MaterialApp(
        theme: ncrraTheme(),
        home: const NcrraPrimaryButton(label: 'Continue', onPressed: null)));
    final label = tester.widget<Text>(find.text('Continue'));
    expect(label.style?.color, NcrraColors.white);
    expect(() => NcrraPrimaryButton(label: '', onPressed: null),
        throwsAssertionError);
    expect(() => NcrraTransitionButton(label: '', onPressed: _noop),
        throwsAssertionError);
  });

  testWidgets(
      'Utility drawer exposes contextual utilities without duplicating primary navigation',
      (tester) async {
    final opened = <String>[];
    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: HomeScreen(
        onOpenTickets: () => opened.add('tickets'),
        onOpenOnboarding: () => opened.add('onboarding'),
        onOpenServices: () => opened.add('services'),
        onOpenReportIssue: () => opened.add('report'),
        onOpenBilling: () => opened.add('billing'),
        onOpenMembership: () => opened.add('membership'),
        onOpenUtility: (label) => opened.add('utility:$label'),
        onNavigate: (_) {},
      ),
    ));

    await tester.tap(find.byTooltip('Open member menu'));
    await tester.pumpAndSettle();
    expect(find.text('Member record'), findsOneWidget);
    expect(find.text('Receipts & payment history'), findsOneWidget);
    expect(find.text('Updates & choices'), findsOneWidget);
    expect(find.text('Help & account safety'), findsOneWidget);
    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Benefits'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    final drawer = find.byType(Drawer);
    for (final duplicate in <String>[
      'My membership',
      'My receipts',
      'My connections',
      'Saved provider details',
      'My tickets',
      'Member benefits',
    ]) {
      expect(find.descendant(of: drawer, matching: find.text(duplicate)),
          findsNothing,
          reason: '$duplicate must remain outside the utility drawer');
    }

    await tester.tap(find.descendant(
        of: drawer, matching: find.text('Receipts & payment history')));
    await tester.pumpAndSettle();
    expect(opened, contains('utility:Receipts & payment history'));
  });

  testWidgets('Drawer trigger is contextual to Home', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: HomeScreen(
        onOpenTickets: () {},
        onOpenOnboarding: () {},
        onOpenServices: () {},
        onOpenReportIssue: () {},
        onOpenBilling: () {},
        onOpenMembership: () {},
        onOpenUtility: (_) {},
        onNavigate: (_) {},
      ),
    ));
    expect(find.byTooltip('Open member menu'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      theme: ncrraTheme(),
      home: UtilityScreen(
        destination: NcrraUtilityDestination.security,
        onBack: () {},
      ),
    ));
    expect(find.byTooltip('Open member menu'), findsNothing);
    expect(find.byTooltip('Back'), findsOneWidget);
  });
}

void _noop() {}
