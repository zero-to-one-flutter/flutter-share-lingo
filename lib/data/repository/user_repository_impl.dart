import '../../domain/entity/app_user.dart';
import '../../domain/repository/user_repository.dart';
import '../data_source/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<AppUser?> getUserById(String uid) async {
    final dto = await dataSource.getUserById(uid);
    return dto?.toEntity();
  }
}
