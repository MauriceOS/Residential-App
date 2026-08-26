// NCRRA Trusted Member Utility: application shell that makes the React prototype the visual reference and Flutter the production mobile track.
import 'package:flutter/material.dart';

import 'core/design/ncrra_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/member_sections/presentation/member_section_screens.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/tickets/presentation/ticket_dashboard_screen.dart';
import 'features/utilities/presentation/utility_screens.dart';

enum _Route {
  home,
  onboarding,
  tickets,
  services,
  reportIssue,
  billing,
  community,
  benefits,
  account,
  membership,
  memberRecord,
  receipts,
  notifications,
  privacy,
  security,
  helpCentre,
  contact
}

class NcrraApp extends StatefulWidget {
  const NcrraApp({super.key});

  @override
  State<NcrraApp> createState() => _NcrraAppState();
}

class _NcrraAppState extends State<NcrraApp> {
  _Route _route = _Route.home;
  late final ThemeData _theme = ncrraTheme();

  void _openSection(int index) {
    final next = switch (index) {
      0 => _Route.home,
      1 => _Route.services,
      2 => _Route.community,
      3 => _Route.benefits,
      _ => _Route.account,
    };
    if (_route != next) setState(() => _route = next);
  }

  void _openUtility(String label) {
    final next = switch (label) {
      'Member ID & association' => _Route.memberRecord,
      'Receipts & payment history' => _Route.receipts,
      'Notifications & notices' => _Route.notifications,
      'Data & privacy' => _Route.privacy,
      'Security checkup' => _Route.security,
      'Help centre' => _Route.helpCentre,
      'Contact NCRRA' => _Route.contact,
      _ => _Route.home,
    };
    if (_route != next) setState(() => _route = next);
  }

  Widget _currentScreen() => KeyedSubtree(
      key: ValueKey(_route),
      child: switch (_route) {
        _Route.onboarding => OnboardingFlow(
            onComplete: () => setState(() => _route = _Route.home),
            onExit: () => setState(() => _route = _Route.home)),
        _Route.tickets => TicketDashboardScreen(
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.services => MemberSectionScreen(
            section: MemberSection.services,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection,
            onOpenReportIssue: () =>
                setState(() => _route = _Route.reportIssue)),
        _Route.reportIssue => MemberSectionScreen(
            section: MemberSection.reportIssue,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.billing => MemberSectionScreen(
            section: MemberSection.billing,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.community => MemberSectionScreen(
            section: MemberSection.community,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.benefits => MemberSectionScreen(
            section: MemberSection.benefits,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.account => MemberSectionScreen(
            section: MemberSection.account,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection,
            onOpenMembership: () => setState(() => _route = _Route.membership)),
        _Route.membership => MemberSectionScreen(
            section: MemberSection.membership,
            onBack: () => setState(() => _route = _Route.home),
            onNavigate: _openSection),
        _Route.memberRecord => UtilityScreen(
            destination: NcrraUtilityDestination.memberRecord,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.receipts => UtilityScreen(
            destination: NcrraUtilityDestination.receipts,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.notifications => UtilityScreen(
            destination: NcrraUtilityDestination.notifications,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.privacy => UtilityScreen(
            destination: NcrraUtilityDestination.privacy,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.security => UtilityScreen(
            destination: NcrraUtilityDestination.security,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.helpCentre => UtilityScreen(
            destination: NcrraUtilityDestination.helpCentre,
            onBack: () => setState(() => _route = _Route.home)),
        _Route.contact => UtilityScreen(
            destination: NcrraUtilityDestination.contact,
            onBack: () => setState(() => _route = _Route.home)),
        _ => HomeScreen(
            onOpenTickets: () => setState(() => _route = _Route.tickets),
            onOpenOnboarding: () => setState(() => _route = _Route.onboarding),
            onOpenServices: () => setState(() => _route = _Route.services),
            onOpenReportIssue: () =>
                setState(() => _route = _Route.reportIssue),
            onOpenBilling: () => setState(() => _route = _Route.billing),
            onOpenMembership: () => setState(() => _route = _Route.membership),
            onOpenUtility: _openUtility,
            onNavigate: _openSection,
          ),
      });

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NCRRA',
        theme: _theme,
        home: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          reverseDuration: const Duration(milliseconds: 160),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0.025, 0), end: Offset.zero)
                      .animate(animation),
              child: child,
            ),
          ),
          child: _currentScreen(),
        ),
      );
}
