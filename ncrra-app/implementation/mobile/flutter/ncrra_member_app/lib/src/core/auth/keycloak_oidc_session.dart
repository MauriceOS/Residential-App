// NCRRA OIDC boundary: native Authorization Code + PKCE with protected device token storage.
import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/ncrra_api_client.dart';

class KeycloakOidcConfiguration {
  const KeycloakOidcConfiguration({
    required this.discoveryUrl,
    required this.clientId,
    required this.redirectUrl,
    this.scopes = const ['openid', 'profile', 'email', 'offline_access'],
  });

  final String discoveryUrl;
  final String clientId;
  final String redirectUrl;
  final List<String> scopes;
}

abstract interface class _TokenStore {
  Future<_StoredTokens?> read();
  Future<void> write(_StoredTokens tokens);
  Future<void> delete();
}

class _ProtectedTokenStore implements _TokenStore {
  _ProtectedTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(migrateWithBackup: true),
              iOptions: IOSOptions(
                  accessibility:
                      KeychainAccessibility.first_unlock_this_device),
            );

  static const _storageKey = 'ncrra.oidc.session.v1';
  final FlutterSecureStorage _storage;

  @override
  Future<_StoredTokens?> read() async {
    final raw = await _storage.read(key: _storageKey);
    return raw == null
        ? null
        : _StoredTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> write(_StoredTokens tokens) =>
      _storage.write(key: _storageKey, value: jsonEncode(tokens.toJson()));

  @override
  Future<void> delete() => _storage.delete(key: _storageKey);
}

class KeycloakOidcSession implements AccessTokenProvider {
  KeycloakOidcSession(
      {required KeycloakOidcConfiguration configuration,
      FlutterAppAuth? appAuth})
      : _configuration = configuration,
        _appAuth = appAuth ?? const FlutterAppAuth(),
        _tokenStore = _ProtectedTokenStore();

  final KeycloakOidcConfiguration _configuration;
  final FlutterAppAuth _appAuth;
  final _TokenStore _tokenStore;
  _StoredTokens? _tokens;

  Future<void> signIn() async {
    final response = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        _configuration.clientId,
        _configuration.redirectUrl,
        discoveryUrl: _configuration.discoveryUrl,
        scopes: _configuration.scopes,
        promptValues: const ['login'],
      ),
    );
    _tokens = _StoredTokens.fromResponse(response);
    await _tokenStore.write(_tokens!);
  }

  @override
  Future<String?> getAccessToken() async {
    final tokens = await _load();
    if (tokens == null) {
      return null;
    }
    if (tokens.expiresAt
            ?.isAfter(DateTime.now().add(const Duration(seconds: 60))) ??
        false) {
      return tokens.accessToken;
    }
    if (tokens.refreshToken == null) {
      return null;
    }
    final refreshed = await _appAuth.token(
      TokenRequest(
        _configuration.clientId,
        _configuration.redirectUrl,
        discoveryUrl: _configuration.discoveryUrl,
        refreshToken: tokens.refreshToken,
        scopes: _configuration.scopes,
      ),
    );
    _tokens = _StoredTokens.fromResponse(refreshed);
    await _tokenStore.write(_tokens!);
    return _tokens!.accessToken;
  }

  Future<void> signOut() async {
    final tokens = await _load();
    await _tokenStore.delete();
    _tokens = null;
    if (tokens?.idToken == null) return;
    await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: tokens!.idToken,
        postLogoutRedirectUrl: _configuration.redirectUrl,
        discoveryUrl: _configuration.discoveryUrl,
      ),
    );
  }

  Future<_StoredTokens?> _load() async => _tokens ??= await _tokenStore.read();
}

class _StoredTokens {
  const _StoredTokens(
      {required this.accessToken,
      this.refreshToken,
      this.idToken,
      this.expiresAt});

  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime? expiresAt;

  factory _StoredTokens.fromResponse(TokenResponse response) => _StoredTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        idToken: response.idToken,
        expiresAt: response.accessTokenExpirationDateTime,
      );

  factory _StoredTokens.fromJson(Map<String, dynamic> json) => _StoredTokens(
        accessToken: json['access_token'] as String?,
        refreshToken: json['refresh_token'] as String?,
        idToken: json['id_token'] as String?,
        expiresAt: json['expires_at'] == null
            ? null
            : DateTime.parse(json['expires_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'id_token': idToken,
        'expires_at': expiresAt?.toUtc().toIso8601String(),
      };
}
