// NCRRA Trusted Member Utility: member-side ticket discovery, filtering, sorting and readable status tracking.
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../core/design/ncrra_components.dart';
import '../../../core/design/ncrra_theme.dart';
import '../domain/ticket.dart';

class TicketDashboardScreen extends StatefulWidget {
  const TicketDashboardScreen({required this.onBack, required this.onNavigate, super.key});

  final VoidCallback onBack;
  final ValueChanged<int> onNavigate;

  @override
  State<TicketDashboardScreen> createState() => _TicketDashboardScreenState();
}

class _TicketDashboardScreenState extends State<TicketDashboardScreen> {
  String _query = '';
  TicketStatus? _status;
  TicketService? _service;
  _TicketSort _sort = _TicketSort.newest;
  bool _filtersOpen = false;

  List<TicketItem> get _tickets {
    final query = _query.trim().toLowerCase();
    final result = previewTickets.where((ticket) {
      final statusMatches = _status == null || ticket.status == _status;
      final serviceMatches = _service == null || ticket.service == _service;
      final queryMatches = query.isEmpty || '${ticket.id} ${ticket.title} ${_serviceName(ticket.service)}'.toLowerCase().contains(query);
      return statusMatches && serviceMatches && queryMatches;
    }).toList();
    result.sort((a, b) {
      return switch (_sort) {
        _TicketSort.oldest => a.order.compareTo(b.order),
        _TicketSort.status => _statusName(a.status).compareTo(_statusName(b.status)),
        _ => b.order.compareTo(a.order),
      };
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final tickets = _tickets;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            NcrraTopBar(
              title: 'My tickets',
              onBack: widget.onBack,
              action: IconButton(
                onPressed: () => setState(() => _filtersOpen = !_filtersOpen),
                icon: Icon(_filtersOpen ? LucideIcons.x : LucideIcons.list_filter),
                color: _filtersOpen ? NcrraColors.teal : NcrraColors.navy,
                tooltip: 'Filter tickets',
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(NcrraSpacing.gutter, 0, NcrraSpacing.gutter, 24),
                children: [
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search ticket or service',
                      prefixIcon: const Icon(LucideIcons.search, size: 20),
                      suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(LucideIcons.x, size: 18), onPressed: () => setState(() => _query = '')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      _statusChip('All', null),
                      _statusChip('Awaiting provider', TicketStatus.awaitingProvider),
                      _statusChip('In progress', TicketStatus.inProgress),
                      _statusChip('Resolved', TicketStatus.resolved),
                    ]),
                  ),
                  if (_filtersOpen) ...[const SizedBox(height: 16), _filterPanel(context)],
                  const SizedBox(height: 24),
                  Row(children: [
                    Text('${tickets.length} ticket${tickets.length == 1 ? '' : 's'} found', style: Theme.of(context).textTheme.labelLarge),
                    const Spacer(),
                    const Icon(LucideIcons.arrow_down_up, size: 14, color: NcrraColors.mutedText),
                    const SizedBox(width: 4),
                    Text(_sort.label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: NcrraColors.mutedText)),
                  ]),
                  const SizedBox(height: 12),
                  if (tickets.isEmpty)
                    _emptyState(context)
                  else
                    ...tickets.map((ticket) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _TicketCard(ticket: ticket, onTap: () => _showDetail(ticket)))),
                ],
              ),
            ),
            NcrraBottomNavigation(selected: 1, onTap: widget.onNavigate),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String label, TicketStatus? value) {
    final selected = value == null ? _status == null : _status == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _status = value),
        selectedColor: NcrraColors.teal,
        backgroundColor: NcrraColors.white,
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: selected ? NcrraColors.white : NcrraColors.secondaryText),
        side: const BorderSide(color: Color(0xFFDCE3E1)),
        shape: const StadiumBorder(),
      ),
    );
  }

  Widget _filterPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: NcrraColors.mintSurface, border: Border.fromBorderSide(BorderSide(color: Color(0xFFDCE9E5))), borderRadius: BorderRadius.all(NcrraRadius.card)),
      child: Column(
        children: [
          Row(children: [
            Text('Filter and sort', style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            TextButton(onPressed: _reset, child: const Text('Reset')),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _serviceSelect(context)),
            const SizedBox(width: 12),
            Expanded(child: _sortSelect(context)),
          ]),
        ],
      ),
    );
  }

  Widget _serviceSelect(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Service', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: const Color(0xFF435166))),
      const SizedBox(height: 6),
      DropdownButtonFormField<TicketService?>(
        initialValue: _service,
        isExpanded: true,
        onChanged: (value) => setState(() => _service = value),
        items: const [
          DropdownMenuItem<TicketService?>(value: null, child: Text('All')),
          DropdownMenuItem<TicketService?>(value: TicketService.electricity, child: Text('Electricity')),
          DropdownMenuItem<TicketService?>(value: TicketService.water, child: Text('Water')),
          DropdownMenuItem<TicketService?>(value: TicketService.property, child: Text('Property')),
        ],
      ),
    ]);
  }

  Widget _sortSelect(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Sort', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: const Color(0xFF435166))),
      const SizedBox(height: 6),
      DropdownButtonFormField<_TicketSort>(
        initialValue: _sort,
        isExpanded: true,
        onChanged: (value) => setState(() => _sort = value ?? _TicketSort.newest),
        items: const [
          DropdownMenuItem(value: _TicketSort.newest, child: Text('Newest first')),
          DropdownMenuItem(value: _TicketSort.oldest, child: Text('Oldest first')),
          DropdownMenuItem(value: _TicketSort.status, child: Text('Status')),
        ],
      ),
    ]);
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 44),
      child: Center(
        child: Column(children: [
          Container(width: 48, height: 48, decoration: const BoxDecoration(color: NcrraColors.mintOrb, shape: BoxShape.circle), child: const Icon(LucideIcons.search, color: NcrraColors.teal)),
          const SizedBox(height: 12),
          Text('No matching tickets', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text('Try a different service, status or search term.', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          TextButton(onPressed: _reset, child: const Text('Clear filters')),
        ]),
      ),
    );
  }

  void _reset() => setState(() { _query = ''; _status = null; _service = null; _sort = _TicketSort.newest; });

  void _showDetail(TicketItem ticket) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: NcrraColors.ivory,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(NcrraSpacing.gutter),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(width: 40, height: 5, decoration: const BoxDecoration(color: Color(0xFFD7DCDB), borderRadius: BorderRadius.all(NcrraRadius.pill)))),
              const SizedBox(height: 20),
              NcrraStatusBadge(label: _statusName(ticket.status), tone: _tone(ticket.status)),
              const SizedBox(height: 12),
              Text(ticket.id, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(ticket.title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Text(ticket.detail, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              _timeline('Request submitted', 'NCRRA recorded your request.', true),
              _timeline('Current: ${_statusName(ticket.status)}', 'NCRRA will notify you when this changes.', false),
              _timeline('Member confirmation', 'You can review the outcome when the ticket closes.', false),
            ]),
          ),
        );
      },
    );
  }

  Widget _timeline(String title, String body, bool complete) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: complete ? NcrraColors.teal : NcrraColors.white, shape: BoxShape.circle, border: complete ? null : Border.all(color: NcrraColors.teal, width: 2)),
          child: Icon(complete ? LucideIcons.check : LucideIcons.circle, color: complete ? NcrraColors.white : NcrraColors.teal, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 3), Text(body, style: Theme.of(context).textTheme.bodySmall)])),
      ]),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final TicketItem ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(NcrraRadius.card),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: NcrraColors.white, border: Border.fromBorderSide(BorderSide(color: NcrraColors.border)), borderRadius: BorderRadius.all(NcrraRadius.card)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          NcrraIconOrb(icon: _icon(ticket.service), tone: ticket.status == TicketStatus.awaitingProvider ? NcrraStatusTone.amber : NcrraStatusTone.teal),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(ticket.id, style: Theme.of(context).textTheme.labelLarge)), NcrraStatusBadge(label: _statusName(ticket.status), tone: _tone(ticket.status))]),
            const SizedBox(height: 5),
            Text(ticket.title, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 5),
            Text('${_serviceName(ticket.service)} · ${ticket.updatedLabel}', style: Theme.of(context).textTheme.bodySmall),
          ])),
          const SizedBox(width: 8),
          const Padding(padding: EdgeInsets.only(top: 27), child: Icon(LucideIcons.chevron_right, size: 20, color: NcrraColors.mutedText)),
        ]),
      ),
    );
  }
}

enum _TicketSort { newest, oldest, status }

extension _TicketSortLabel on _TicketSort {
  String get label => switch (this) { _TicketSort.newest => 'Newest', _TicketSort.oldest => 'Oldest', _TicketSort.status => 'Status' };
}

String _statusName(TicketStatus status) => switch (status) { TicketStatus.awaitingProvider => 'Awaiting provider', TicketStatus.inProgress => 'In progress', TicketStatus.resolved => 'Resolved', TicketStatus.closed => 'Closed' };
String _serviceName(TicketService service) => switch (service) { TicketService.electricity => 'Electricity', TicketService.water => 'Water', TicketService.property => 'Property' };
IconData _icon(TicketService service) => switch (service) { TicketService.electricity => LucideIcons.zap, TicketService.water => LucideIcons.droplets, TicketService.property => LucideIcons.house };
NcrraStatusTone _tone(TicketStatus status) => switch (status) { TicketStatus.awaitingProvider => NcrraStatusTone.amber, TicketStatus.resolved => NcrraStatusTone.teal, _ => NcrraStatusTone.slate };
