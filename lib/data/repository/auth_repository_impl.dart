import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/enums.dart';
import '../../domain/repository/repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final StreamController<AuthStatus> _controller =
      StreamController<AuthStatus>();

  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Stream<AuthStatus> get authStatus async* {
    yield* _firebaseAuth.authStateChanges().map((User? user) {
      if (user != null) {
        return AuthStatus.authenticated;
      } else {
        return AuthStatus.unauthenticated;
      }
    });
  }

  @override
  Future<bool> login(String email, String password) async {
    late final User? user;

    final UserCredential credential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    user = credential.user;

    if (user == null) {
      return false;
    }

    return true;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  void logout() {
    _controller.add(AuthStatus.unauthenticated);
  }
}
