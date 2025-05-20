import '../entity/app_user.dart';

abstract class UserRepository {
  Future<AppUser?> getUserById(String uid);

  Future<void> saveUserToDatabase(AppUser user);
}
