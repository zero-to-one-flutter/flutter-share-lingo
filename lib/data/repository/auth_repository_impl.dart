import '../../domain/entity/app_user.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/firebase_auth_data_source.dart';
import '../data_source/google_sign_in_data_source.dart';
import '../data_source/user_data_source.dart';
import '../dto/user_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignInDataSource _googleSignIn;
  final FirebaseAuthDataSource _firebaseAuth;
  final UserDataSource _userDataSource;

  AuthRepositoryImpl(
    this._googleSignIn,
    this._firebaseAuth,
    this._userDataSource,
  );

  @override
  Future<AppUser?> signInWithGoogle() async {
    final googleAuth = await _googleSignIn.signIn();
    if (googleAuth == null) return null;

    final firebaseUser = await _firebaseAuth.signInWithGoogle(googleAuth);
    if (firebaseUser == null) return null;

    final partialUser = AppUser(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      profileImage: firebaseUser.photoURL,
      email: firebaseUser.email,
    );

    final fullUserDto = await _userDataSource.getUserById(partialUser.id);
    if (fullUserDto != null) { // User exists in backend
      return fullUserDto.toEntity(); // Return existing user in backend
    } else { // User is new sign up. Add to backend
      await _userDataSource.saveUser(UserDto.fromEntity(partialUser));
      return partialUser; // Return newly added user
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Stream<String?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) => user?.uid);
  }
}
