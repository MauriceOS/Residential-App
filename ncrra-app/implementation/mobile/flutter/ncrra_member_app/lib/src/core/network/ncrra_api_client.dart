// NCRRA member app boundary: access tokens, tenant identity and authorization are handled by OIDC; no tenant or provider secret is stored in the client.
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../features/tickets/domain/ticket.dart';

abstract interface class AccessTokenProvider {
  Future<String?> getAccessToken();
}

class NcrraApiClient {
  NcrraApiClient(
      {required this.baseUri,
      required this.tokenProvider,
      http.Client? httpClient})
      : _http = httpClient ?? http.Client();
  final Uri baseUri;
  final AccessTokenProvider tokenProvider;
  final http.Client _http;

  Future<http.Response> get(String path, {Map<String, String>? query}) async {
    final token = await tokenProvider.getAccessToken();
    final uri =
        baseUri.replace(path: '${baseUri.path}$path', queryParameters: query);
    return _http.get(uri, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
  }

  Future<List<TicketItem>> listTickets(
      {String? query,
      TicketStatus? status,
      TicketService? service,
      String sort = 'newest'}) async {
    final response = await get('/api/v1/tickets', query: {
      if (query != null && query.isNotEmpty) 'q': query,
      if (status != null) 'status': status.name,
      if (service != null) 'service': service.name,
      'sort': sort,
    });
    if (response.statusCode != 200) {
      throw StateError('Ticket request failed with ${response.statusCode}.');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final items = payload['items'] as List<dynamic>? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(_parseTicketListItem)
        .toList();
  }

  TicketItem _parseTicketListItem(Map<String, dynamic> json) {
    final updatedAt = DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    return TicketItem(
      id: json['id'] as String,
      title: json['title'] as String,
      service: TicketService.values.byName(json['service'] as String),
      status: TicketStatus.values.byName(json['status'] as String),
      updatedLabel: _formatUpdatedLabel(updatedAt),
      order: updatedAt.millisecondsSinceEpoch,
      detail: json['title'] as String,
    );
  }

  String _formatUpdatedLabel(DateTime updatedAt) {
    final local = updatedAt.toLocal();
    final date =
        '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
    final time =
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    return 'Updated $date · $time';
  }
}
