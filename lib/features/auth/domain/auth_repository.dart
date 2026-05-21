import 'user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity?> loginWithEmail(String email, String password);
  Future<UserEntity?> registerWithEmailAndPassword(String email, String password);
  Future<UserEntity?> loginWithGoogle();
  Future<void> logout();
}
