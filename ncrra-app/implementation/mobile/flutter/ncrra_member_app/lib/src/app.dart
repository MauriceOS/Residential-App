// NCRRA Trusted Member Utility: application shell that makes the React prototype the visual reference and Flutter the production mobile track.
import 'package:flutter/material.dart';

import 'core/design/ncrra_theme.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/member_sections/presentation/member_section_screens.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/tickets/presentation/ticket_dashboard_screen.dart';

enum _Route { home, onboarding, tickets, services, reportIssue, billing, community, benefits, account, membership }

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

  Widget _currentScreen() => KeyedSubtree(key: ValueKey(_route), child: switch (_route) {
        _Route.onboarding => OnboardingFlow(onComplete: () => setState(() => _route = _Route.home), onExit: () => setState(() => _route = _Route.home)),
        _Route.tickets => TicketDashboardScreen(onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _Route.services => MemberSectionScreen(section: MemberSection.services, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection, onOpenReportIssue: () => setState(() => _route = _Route.reportIssue)),
        _Route.reportIssue => MemberSectionScreen(section: MemberSection.reportIssue, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _Route.billing => MemberSectionScreen(section: MemberSection.billing, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _Route.community => MemberSectionScreen(section: MemberSection.community, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _Route.benefits => MemberSectionScreen(section: MemberSection.benefits, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _Route.account => MemberSectionScreen(section: MemberSection.account, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection, onOpenMembership: () => setState(() => _route = _Route.membership)),
        _Route.membership => MemberSectionScreen(section: MemberSection.membership, onBack: () => setState(() => _route = _Route.home), onNavigate: _openSection),
        _ => HomeScreen(
            onOpenTickets: () => setState(() => _route = _Route.tickets),
            onOpenOnboarding: () => setState(() => _route = _Route.onboarding),
            onOpenServices: () => setState(() => _route = _Route.services),
            onOpenReportIssue: () => setState(() => _route = _Route.reportIssue),
            onOpenBilling: () => setState(() => _route = _Route.billing),
            onOpenMembership: () => setState(() => _route = _Route.membership),
            onNavigate: _openSection,
          ),
      });

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NCRRA',
        theme: _theme,
        home: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          reverseDuration: const Duration(milliseconds: 160),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.025, 0), end: Offset.zero).animate(animation),
              child: child,
            ),
          ),
          child: _currentScreen(),
        ),
      );
}
