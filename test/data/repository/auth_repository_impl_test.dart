import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/data/data_source/firebase_auth_data_source.dart';
import 'package:share_lingo/data/data_source/google_sign_in_data_source.dart';
import 'package:share_lingo/data/data_source/user_data_source.dart';
import 'package:share_lingo/data/dto/user_dto.dart';
import 'package:share_lingo/data/repository/auth_repository_impl.dart';
import 'package:share_lingo/domain/entity/app_user.dart';

class MockGoogleSignInDataSource extends Mock
    implements GoogleSignInDataSource {}

class MockFirebaseAuthDataSource extends Mock
    implements FirebaseAuthDataSource {}

class MockUserDataSource extends Mock implements UserDataSource {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class FakeUserDto extends Fake implements UserDto {}

class FakeGoogleSignInAuthentication extends Fake
    implements GoogleSignInAuthentication {}

class FakeStream<T> extends Fake implements Stream<T> {}

void main() {
  late MockGoogleSignInDataSource mockGoogleSignInDataSource;
  late MockFirebaseAuthDataSource mockFirebaseAuthDataSource;
  late MockUserDataSource mockUserDataSource;
  late AuthRepositoryImpl authRepository;
  late MockGoogleSignInAuthentication mockGoogleAuth;
  late MockFirebaseUser mockFirebaseUser;

  setUpAll(() {
    registerFallbackValue(FakeUserDto());
    registerFallbackValue(FakeGoogleSignInAuthentication());
  });

  setUp(() {
    mockGoogleSignInDataSource = MockGoogleSignInDataSource();
    mockFirebaseAuthDataSource = MockFirebaseAuthDataSource();
    mockUserDataSource = MockUserDataSource();
    authRepository = AuthRepositoryImpl(
      mockGoogleSignInDataSource,
      mockFirebaseAuthDataSource,
      mockUserDataSource,
    );
    mockGoogleAuth = MockGoogleSignInAuthentication();
    mockFirebaseUser = MockFirebaseUser();

    // Set up default mock behavior
    when(() => mockFirebaseUser.uid).thenReturn('test-user-id');
    when(() => mockFirebaseUser.displayName).thenReturn('Test User');
    when(
      () => mockFirebaseUser.photoURL,
    ).thenReturn('https://example.com/photo.jpg');
    when(() => mockFirebaseUser.email).thenReturn('test@example.com');

    // Set up mock behavior for void methods
    when(() => mockGoogleSignInDataSource.signOut()).thenAnswer((_) async {});
    when(() => mockFirebaseAuthDataSource.signOut()).thenAnswer((_) async {});

    // Set up mock behavior for Stream
    final mockStream = Stream<firebase_auth.User?>.fromIterable([
      mockFirebaseUser,
      null,
    ]);
    when(
      () => mockFirebaseAuthDataSource.authStateChanges(),
    ).thenAnswer((_) => mockStream);
  });

  group('AuthRepositoryImpl', () {
    test(
      'signInWithGoogle returns null when GoogleSignIn returns null',
      () async {
        // Arrange
        when(
          () => mockGoogleSignInDataSource.signIn(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.signInWithGoogle();

        // Assert
        expect(result, isNull);
        verify(() => mockGoogleSignInDataSource.signIn()).called(1);
        verifyNever(() => mockFirebaseAuthDataSource.signInWithGoogle(any()));
      },
    );

    test(
      'signInWithGoogle returns null when FirebaseAuth returns null',
      () async {
        // Arrange
        when(
          () => mockGoogleSignInDataSource.signIn(),
        ).thenAnswer((_) async => mockGoogleAuth);
        when(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authRepository.signInWithGoogle();

        // Assert
        expect(result, isNull);
        verify(() => mockGoogleSignInDataSource.signIn()).called(1);
        verify(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).called(1);
        verifyNever(() => mockUserDataSource.getUserById(any()));
      },
    );

    test(
      'signInWithGoogle returns existing user when user found in database',
      () async {
        // Arrange
        final existingUserDto = UserDto(
          id: 'test-user-id',
          name: 'Existing User',
          createdAt: Timestamp.now(),
          email: 'existing@example.com',
          nativeLanguage: 'English',
          targetLanguage: 'Korean',
        );

        when(
          () => mockGoogleSignInDataSource.signIn(),
        ).thenAnswer((_) async => mockGoogleAuth);
        when(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).thenAnswer((_) async => mockFirebaseUser);
        when(
          () => mockUserDataSource.getUserById('test-user-id'),
        ).thenAnswer((_) async => existingUserDto);

        // Act
        final result = await authRepository.signInWithGoogle();

        // Assert
        expect(result, isA<AppUser>());
        expect(result?.id, equals('test-user-id'));
        // Using the existing user data
        expect(result?.name, equals('Existing User'));
        expect(result?.email, equals('existing@example.com'));
        expect(result?.nativeLanguage, equals('English'));
        expect(result?.targetLanguage, equals('Korean'));

        verify(() => mockGoogleSignInDataSource.signIn()).called(1);
        verify(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).called(1);
        verify(() => mockUserDataSource.getUserById('test-user-id')).called(1);
        verifyNever(() => mockUserDataSource.saveUser(any()));
      },
    );

    test(
      'signInWithGoogle creates new user when not found in database',
      () async {
        // Arrange
        when(
          () => mockGoogleSignInDataSource.signIn(),
        ).thenAnswer((_) async => mockGoogleAuth);
        when(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).thenAnswer((_) async => mockFirebaseUser);
        when(
          () => mockUserDataSource.getUserById('test-user-id'),
        ).thenAnswer((_) async => null);
        when(() => mockUserDataSource.saveUser(any())).thenAnswer((_) async {});

        // Act
        final result = await authRepository.signInWithGoogle();

        // Assert
        expect(result, isA<AppUser>());
        expect(result?.id, equals('test-user-id'));
        // Using the Firebase user data
        expect(result?.name, equals('Test User'));
        expect(result?.email, equals('test@example.com'));
        expect(result?.profileImage, equals('https://example.com/photo.jpg'));

        verify(() => mockGoogleSignInDataSource.signIn()).called(1);
        verify(
          () => mockFirebaseAuthDataSource.signInWithGoogle(any()),
        ).called(1);
        verify(() => mockUserDataSource.getUserById('test-user-id')).called(1);
        verify(() => mockUserDataSource.saveUser(any())).called(1);
      },
    );

    test(
      'signOut calls both GoogleSignIn and FirebaseAuth signOut methods',
      () async {
        // Act
        await authRepository.signOut();

        // Assert
        verify(() => mockGoogleSignInDataSource.signOut()).called(1);
        verify(() => mockFirebaseAuthDataSource.signOut()).called(1);
      },
    );

    test('authStateChanges transforms Firebase User to userId', () async {
      // Act
      final result = authRepository.authStateChanges();

      // Assert
      expect(await result.first, equals('test-user-id'));
      verify(() => mockFirebaseAuthDataSource.authStateChanges()).called(1);
    });
  });
}
