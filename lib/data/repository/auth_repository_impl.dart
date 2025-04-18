import 'dart:async';

import '../../domain/models/enums.dart';
import '../../domain/repository/repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final StreamController<AuthStatus> _controller =
      StreamController<AuthStatus>();

  @override
  Stream<AuthStatus> get authStatus async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthStatus.unauthenticated;
    yield* _controller.stream;
  }

  @override
  Future<void> login(String email, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (password == 'admin') {
      _controller.add(AuthStatus.authenticated);
    }
  }

  @override
  void logout() {
    _controller.add(AuthStatus.unauthenticated);
  }
}
