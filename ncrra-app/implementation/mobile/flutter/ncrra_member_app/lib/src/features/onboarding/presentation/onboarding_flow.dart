// NCRRA Trusted Member Utility: explicit consent, plain-language data purpose and focused onboarding progression.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow(
      {required this.onComplete, required this.onExit, super.key});
  final VoidCallback onComplete;
  final VoidCallback onExit;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  final _name = TextEditingController(text: 'Amina Wanjiku');
  final _email = TextEditingController(text: 'amina@example.com');
  final _phone = TextEditingController(text: '0712 345 678');
  final _area = TextEditingController(text: 'Nairobi');
  bool _membership = false;
  bool _privacy = false;
  bool _communications = true;
  bool _busy = false;

  Future<void> _advanceTo(int step) async {
    if (_busy) return;
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (!mounted) return;
    setState(() {
      _step = step;
      _busy = false;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _area.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 140),
            reverseDuration: const Duration(milliseconds: 100),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeOut,
            child: switch (_step) {
              0 => _welcome(context),
              1 => _profile(context),
              2 => _consent(context),
              _ => _complete(context),
            },
          ),
        ),
      );

  Widget _welcome(BuildContext context) => Padding(
        key: const ValueKey('welcome'),
        padding: const EdgeInsets.fromLTRB(
            NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const NcrraBrandMark(),
          const Spacer(flex: 3),
          Text('NEW MEMBER REGISTRATION',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: NcrraColors.teal, letterSpacing: 1.3)),
          const SizedBox(height: 20),
          Text('Your association\nservices, in one\nplace.',
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
              'Set up your member account first. You can add service connections and manage your annual contribution afterwards.',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 28),
          const Divider(color: NcrraColors.border),
          const _WelcomePoint(
              icon: LucideIcons.user_round,
              title: 'Set up your member profile',
              body: 'Confirm how NCRRA can reach you.'),
          const _WelcomePoint(
              icon: LucideIcons.shield_check,
              title: 'Review data consent',
              body: 'See what data is used and why before you continue.'),
          const _WelcomePoint(
              icon: LucideIcons.heart_handshake,
              title: 'Access member services',
              body:
                  'Manage services, notices, benefits and annual contributions.'),
          const Divider(color: NcrraColors.border),
          const Spacer(),
          NcrraPrimaryButton(
              label: 'Start registration',
              loading: _busy,
              loadingLabel: 'Preparing registration…',
              onPressed: () => _advanceTo(1)),
          Center(
              child: TextButton(
                  onPressed: widget.onExit,
                  child: const Text('I already have an account'))),
        ]),
      );

  Widget _profile(BuildContext context) => SingleChildScrollView(
        key: const ValueKey('profile'),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NcrraTopBar(
              title: 'Set up profile', onBack: () => setState(() => _step = 0)),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NcrraProgress(step: 1, label: 'Member registration'),
                    const SizedBox(height: 18),
                    Text('A few details to get started',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                        'These details identify your NCRRA membership and let support respond to you.',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    _field('Full name', _name),
                    const SizedBox(height: 16),
                    _field('Email address', _email,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _field('Mobile number', _phone,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _field('Town or area', _area),
                    const SizedBox(height: 28),
                    NcrraPrimaryButton(
                        label: 'Continue',
                        loading: _busy,
                        loadingLabel: 'Saving profile…',
                        onPressed: () => _advanceTo(2)),
                  ])),
        ]),
      );

  Widget _consent(BuildContext context) => SingleChildScrollView(
        key: const ValueKey('consent'),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NcrraTopBar(
              title: 'Review consent', onBack: () => setState(() => _step = 1)),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: NcrraSpacing.gutter),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NcrraProgress(step: 2, label: 'Member registration'),
                    const SizedBox(height: 18),
                    Text('You decide how your data is used',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                        'NCRRA needs a limited set of details to manage membership. Provider references are not connected until you choose to add them.',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                          color: NcrraColors.white,
                          border: Border.fromBorderSide(
                              BorderSide(color: NcrraColors.border)),
                          borderRadius: BorderRadius.all(NcrraRadius.card)),
                      child: Column(children: [
                        NcrraConsentRow(
                            title: 'Membership administration',
                            description:
                                'Use my profile details to create and administer my NCRRA membership.',
                            value: _membership,
                            onChanged: (value) =>
                                setState(() => _membership = value),
                            required: true),
                        const Divider(height: 1, color: Color(0xFFE5E9E7)),
                        NcrraConsentRow(
                            title: 'Privacy notice',
                            description:
                                'I have reviewed how NCRRA safeguards membership data and handles support access.',
                            value: _privacy,
                            onChanged: (value) =>
                                setState(() => _privacy = value),
                            required: true),
                        const Divider(height: 1, color: Color(0xFFE5E9E7)),
                        NcrraConsentRow(
                            title: 'Association updates',
                            description:
                                'Send association announcements, activities and relevant member notices.',
                            value: _communications,
                            onChanged: (value) =>
                                setState(() => _communications = value),
                            optional: true),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            color: NcrraColors.mintSurface,
                            borderRadius:
                                BorderRadius.all(NcrraRadius.control)),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(LucideIcons.shield_check,
                                  size: 16, color: NcrraColors.teal),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                      'You can review or change optional communication choices later in Account. Service-provider data remains separate and is only shared for a requested service action.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: const Color(0xFF3C5558))))
                            ])),
                    const SizedBox(height: 24),
                    NcrraPrimaryButton(
                        label: 'Complete registration',
                        enabled: _membership && _privacy && !_busy,
                        loading: _busy,
                        loadingLabel: 'Completing registration…',
                        onPressed: () => _advanceTo(3)),
                  ])),
        ]),
      );

  Widget _complete(BuildContext context) => Padding(
        key: const ValueKey('complete'),
        padding: const EdgeInsets.fromLTRB(
            NcrraSpacing.gutter, 24, NcrraSpacing.gutter, 24),
        child: Column(children: [
          const Align(alignment: Alignment.centerLeft, child: NcrraBrandMark()),
          const Spacer(),
          const NcrraIcon(
              icon: LucideIcons.circle_check, tone: NcrraStatusTone.teal),
          const SizedBox(height: 20),
          const NcrraStatusBadge(label: 'Registration complete'),
          const SizedBox(height: 20),
          Text('Welcome, ${_name.text.split(' ').first}.',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
              'Your member account is ready. You can now save a service connection, review notices and manage your association contribution.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 28),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: NcrraColors.mintSurface,
                  border: Border.fromBorderSide(
                      BorderSide(color: Color(0xFFDCE9E5))),
                  borderRadius: BorderRadius.all(NcrraRadius.card)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NEXT RECOMMENDED STEP',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: NcrraColors.teal, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text('Add your first service connection',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 5),
                    Text(
                        'This is optional. A connection is saved only after you choose to add it.',
                        style: Theme.of(context).textTheme.bodySmall)
                  ])),
          const Spacer(),
          NcrraPrimaryButton(
              label: 'Enter member app',
              loading: _busy,
              loadingLabel: 'Opening member app…',
              onPressed: () async {
                await _advanceTo(0);
                if (mounted) widget.onComplete();
              }),
        ]),
      );

  Widget _field(String label, TextEditingController controller,
          {TextInputType? keyboardType}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextField(controller: controller, keyboardType: keyboardType)
      ]);
}

class _WelcomePoint extends StatelessWidget {
  const _WelcomePoint(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        NcrraIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(body, style: Theme.of(context).textTheme.bodySmall)
        ]))
      ]));
}
