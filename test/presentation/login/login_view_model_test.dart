import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share_lingo/domain/entity/app_user.dart';
import 'package:share_lingo/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:share_lingo/presentation/pages/login/login_view_model.dart';

// Create mock classes
class MockSignInWithGoogleUseCase extends Mock
    implements SignInWithGoogleUseCase {}

class FakeAppUser extends Fake implements AppUser {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late ProviderContainer container;
  late Listener<LoginState> listener;

  setUpAll(() {
    registerFallbackValue(FakeAppUser());
  });

  setUp(() {
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();

    container = ProviderContainer(
      overrides: [
        signInWithGoogleUseCaseProvider.overrideWithValue(
          mockSignInWithGoogleUseCase,
        ),
      ],
    );

    // Set up listener for state changes
    listener = Listener<LoginState>();
    container.listen<LoginState>(
      loginViewModelProvider,
      // ignore: implicit_call_tearoffs
      listener,
      fireImmediately: true,
    );

    // Clear any interactions from setup
    clearInteractions(listener);
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginViewModel', () {
    test('initial state has isLoading false and no error message', () {
      // Assert
      final state = container.read(loginViewModelProvider);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
    });

    test(
      'signIn sets isLoading to true during execution and false after completion',
      () async {
        // Setup mock to verify the loading state during execution
        when(() => mockSignInWithGoogleUseCase.execute()).thenAnswer((_) async {
          // Check the loading state during the async operation
          final loadingState = container.read(loginViewModelProvider);
          expect(loadingState.isLoading, isTrue);
          return AppUser(id: 'test-id', name: 'Test User');
        });

        // Act
        await container.read(loginViewModelProvider.notifier).signIn();

        // Verify final state
        final finalState = container.read(loginViewModelProvider);
        expect(finalState.isLoading, isFalse);
        expect(finalState.errorMessage, isNull);
      },
    );

    test(
      'signIn with successful login returns user and sets loading to false',
      () async {
        // Arrange
        final testUser = AppUser(id: 'test-id', name: 'Test User');
        when(
          () => mockSignInWithGoogleUseCase.execute(),
        ).thenAnswer((_) async => testUser);

        // Act
        final result =
            await container.read(loginViewModelProvider.notifier).signIn();

        // Assert
        verify(() => mockSignInWithGoogleUseCase.execute()).called(1);

        // Verify the user is returned
        expect(result, equals(testUser));

        // Verify login state
        final loginState = container.read(loginViewModelProvider);
        expect(loginState.isLoading, isFalse);
        expect(loginState.errorMessage, isNull);
      },
    );

    test('signIn with null result (canceled login) returns null', () async {
      // Arrange
      when(
        () => mockSignInWithGoogleUseCase.execute(),
      ).thenAnswer((_) async => null);

      // Act
      final result =
          await container.read(loginViewModelProvider.notifier).signIn();

      // Assert
      verify(() => mockSignInWithGoogleUseCase.execute()).called(1);

      // Verify null is returned
      expect(result, isNull);

      // Verify final state
      final state = container.read(loginViewModelProvider);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, isNull);
    });
  });
}
