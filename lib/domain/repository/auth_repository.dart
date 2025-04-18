import '../models/enums.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  void logout();
  Stream<AuthStatus> get authStatus;
}
