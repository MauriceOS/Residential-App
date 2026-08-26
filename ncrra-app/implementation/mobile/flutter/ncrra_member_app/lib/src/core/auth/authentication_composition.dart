// Composition root for native mobile auth. Supply environment-specific public discovery and API URLs through CI/build configuration, never a client secret.
import '../network/ncrra_api_client.dart';
import 'keycloak_oidc_session.dart';

class AuthenticationComposition {
  AuthenticationComposition._({required this.session, required this.apiClient});

  factory AuthenticationComposition(
      {required String discoveryUrl, required String apiBaseUrl}) {
    final session = KeycloakOidcSession(
      configuration: KeycloakOidcConfiguration(
        discoveryUrl: discoveryUrl,
        clientId: 'ncrra-mobile-dev',
        redirectUrl: 'ncrra://auth/callback',
      ),
    );
    return AuthenticationComposition._(
      session: session,
      apiClient: NcrraApiClient(
          baseUri: Uri.parse(apiBaseUrl), tokenProvider: session),
    );
  }

  final KeycloakOidcSession session;
  final NcrraApiClient apiClient;
}
