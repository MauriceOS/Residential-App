import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ncrra_member_app/src/app.dart';
import 'package:ncrra_member_app/src/core/design/ncrra_theme.dart';
import 'package:ncrra_member_app/src/features/home/presentation/home_screen.dart';
import 'package:ncrra_member_app/src/features/member_sections/presentation/member_section_screens.dart';

void main() {
  test('NCRRA design system retains the canonical service colours', () {
    expect(NcrraColors.teal.toARGB32(), 0xFF2C7D78);
    expect(NcrraColors.navy.toARGB32(), 0xFF0B1E3B);
  });
  testWidgets('Home renders labeled membership and quick actions and routes taps', (tester) async {
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
        onNavigate: (index) => opened.add('tab-$index'),
      ),
    ));

    for (final label in <String>['View membership', 'Report an issue', 'My tickets', 'Pay contribution', 'My connections']) {
      expect(find.text(label), findsOneWidget);
    }

    for (final label in <String>['View membership', 'Report an issue', 'My tickets', 'Pay contribution', 'My connections']) {
      await tester.tap(find.text(label));
    }
    await tester.pump();

    expect(opened, containsAll(<String>['membership', 'report', 'tickets', 'billing', 'services']));
  });

  testWidgets('Home bottom navigation exposes all labeled destinations', (tester) async {
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
        onNavigate: selected.add,
      ),
    ));

    for (final label in <String>['Home', 'Services', 'Community', 'Benefits', 'Account']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Services'));
    await tester.tap(find.text('Community'));
    await tester.tap(find.text('Benefits'));
    await tester.tap(find.text('Account'));
    await tester.pump();

    expect(selected, <int>[1, 2, 3, 4]);
  });

  testWidgets('NCRRA app routes primary tabs, membership and billing actions', (tester) async {
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

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    await tester.tap(find.text('Pay contribution'));
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    expect(find.text('Continue to M-PESA'), findsOneWidget);
    await tester.tap(find.text('Continue to M-PESA'));
    await tester.pump();
    expect(find.text('Payment request received'), findsOneWidget);
    expect(find.textContaining('Confirm the M-PESA prompt on your phone.'), findsOneWidget);

  });

  testWidgets('Member sections expose actionable service, benefit and account controls', (tester) async {
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
    await tester.tap(find.text('Jambojet member offer'));
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
    await tester.pump();
    expect(find.text('Card payment is unavailable'), findsOneWidget);
    await tester.tap(find.text('Try another payment method'));
    await tester.pump();
    expect(find.text('Continue to M-PESA'), findsOneWidget);
    await tester.tap(find.text('Continue to M-PESA'));
    await tester.pump();
    expect(find.text('Payment request received'), findsOneWidget);
    await tester.tap(find.text('Return to payment'));
    await tester.pump();
    expect(find.text('Renew your NCRRA membership'), findsOneWidget);
    await tester.tap(find.text('Check contribution status'));
    await tester.pump();
    expect(find.text('No contribution due'), findsOneWidget);
    await tester.tap(find.text('Return to payment'));
    await tester.pump();
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
    await tester.pump();
    expect(find.text('Details saved securely'), findsOneWidget);
    await tester.tap(find.text('Return to membership'));
    await tester.pump();
    expect(find.text('Membership details'), findsOneWidget);
    await tester.tap(find.byTooltip('Refresh membership'));
    await tester.pump();
    expect(find.text('Membership details unavailable'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(find.text('Membership details'), findsOneWidget);
  });
}

