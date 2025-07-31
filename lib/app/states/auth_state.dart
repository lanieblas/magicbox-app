enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? accessToken;

  const AuthState._(this.status, this.accessToken);

  const AuthState.checking() : this._(AuthStatus.checking, null);

  const AuthState.authenticated(String accessToken) : this._(AuthStatus.authenticated, accessToken);

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated, null);
}