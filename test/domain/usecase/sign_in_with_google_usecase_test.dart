import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/app_user.dart';
import 'package:share_lingo/domain/repository/auth_repository.dart';
import 'package:share_lingo/domain/usecase/sign_in_with_google_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInWithGoogleUseCase signInWithGoogleUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInWithGoogleUseCase = SignInWithGoogleUseCase(mockAuthRepository);
  });

  group('SignInWithGoogleUseCase', () {
    test('execute delegates to AuthRepository.signInWithGoogle', () async {
      // Arrange
      final testUser = AppUser(
        id: 'test-user-id',
        name: 'Test User',
        email: 'test@example.com',
      );

      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => testUser);

      // Act
      final result = await signInWithGoogleUseCase.execute();

      // Assert
      expect(result, equals(testUser));
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
    });

    test(
      'execute returns null when AuthRepository.signInWithGoogle returns null',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.signInWithGoogle(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await signInWithGoogleUseCase.execute();

        // Assert
        expect(result, isNull);
        verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      },
    );
  });
}
