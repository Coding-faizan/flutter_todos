import '../models/enums.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Stream<AuthStatus> get authStatus;
  Future<void> signOut();
}
