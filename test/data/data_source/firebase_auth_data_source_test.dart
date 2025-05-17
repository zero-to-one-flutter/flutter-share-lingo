import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/data/data_source/firebase_auth_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class FakeAuthCredential extends Fake implements AuthCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FirebaseAuthDataSourceImpl firebaseAuthDataSource;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignInAuthentication mockGoogleAuth;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    firebaseAuthDataSource = FirebaseAuthDataSourceImpl(mockFirebaseAuth);
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockGoogleAuth = MockGoogleSignInAuthentication();

    // Set up default mock behavior
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockGoogleAuth.accessToken).thenReturn('mock-access-token');
    when(() => mockGoogleAuth.idToken).thenReturn('mock-id-token');
  });

  group('FirebaseAuthDataSourceImpl', () {
    test('signInWithGoogle returns user when sign in succeeds', () async {
      // Arrange
      when(
        () => mockFirebaseAuth.signInWithCredential(any()),
      ).thenAnswer((_) async => mockUserCredential);

      // Act
      final result = await firebaseAuthDataSource.signInWithGoogle(
        mockGoogleAuth,
      );

      // Assert
      expect(result, equals(mockUser));
      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
    });

    test('signOut calls Firebase signOut', () async {
      // Arrange
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      await firebaseAuthDataSource.signOut();

      // Assert
      verify(() => mockFirebaseAuth.signOut()).called(1);
    });

    test('authStateChanges returns the auth state stream', () async {
      // Arrange
      final mockStream = Stream<User?>.fromIterable([mockUser, null]);
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => mockStream);

      // Act
      final result = firebaseAuthDataSource.authStateChanges();

      // Assert
      expect(result, equals(mockStream));
      verify(() => mockFirebaseAuth.authStateChanges()).called(1);
    });
  });
}
