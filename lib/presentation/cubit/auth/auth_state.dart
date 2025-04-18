part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();

  factory AuthState.initial() {
    return const AuthInitial();
  }
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}
