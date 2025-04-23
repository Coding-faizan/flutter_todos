import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/enums.dart';
import '../../../domain/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  late final StreamSubscription<AuthStatus> _authStatusStream;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    _authStatusStream = _authRepository.authStatus.listen((AuthStatus status) {
      if (status == AuthStatus.authenticated) {
        emit(const AuthAuthenticated());
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  void logout() {
    _authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authStatusStream.cancel();
    return super.close();
  }
}
