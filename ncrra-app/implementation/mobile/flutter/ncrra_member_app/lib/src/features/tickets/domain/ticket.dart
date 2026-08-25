// NCRRA Trusted Member Utility: member-ticket projection; tenant scope is server-derived, never passed by the app.
enum TicketStatus { awaitingProvider, inProgress, resolved, closed }
enum TicketService { electricity, water, property }

class TicketItem {
  const TicketItem({required this.id, required this.title, required this.service, required this.status, required this.updatedLabel, required this.order, required this.detail});
  final String id;
  final String title;
  final TicketService service;
  final TicketStatus status;
  final String updatedLabel;
  final int order;
  final String detail;
}

const previewTickets = <TicketItem>[
  TicketItem(id: 'NCRRA-2481', title: 'Power interruption follow-up', service: TicketService.electricity, status: TicketStatus.awaitingProvider, updatedLabel: 'Updated today · 11:20 AM', order: 4, detail: 'Power supply has not been restored since morning at the linked meter.'),
  TicketItem(id: 'NCRRA-2458', title: 'Intermittent water supply', service: TicketService.water, status: TicketStatus.inProgress, updatedLabel: 'Updated yesterday · 04:15 PM', order: 3, detail: 'Member reported low pressure at the saved water connection.'),
  TicketItem(id: 'NCRRA-2419', title: 'Estate streetlight repair', service: TicketService.property, status: TicketStatus.resolved, updatedLabel: 'Resolved 06 May 2025', order: 2, detail: 'The maintenance team confirmed that the streetlight was repaired.'),
  TicketItem(id: 'NCRRA-2397', title: 'Meter account detail correction', service: TicketService.electricity, status: TicketStatus.closed, updatedLabel: 'Closed 28 Apr 2025', order: 1, detail: 'The account correction request was completed and closed.'),
];
