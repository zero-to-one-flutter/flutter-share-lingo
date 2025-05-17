import '../entity/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> signInWithGoogle();

  Future<void> signOut();

  Stream<String?> authStateChanges(); // returns user ID or null
}
