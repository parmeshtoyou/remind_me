import 'package:flutter_test/flutter_test.dart';
import 'package:remind_me/services/auth/auth_exceptions.dart';
import 'package:remind_me/services/auth/auth_provider.dart';
import 'package:remind_me/services/auth/auth_user.dart';

void main() {
  group('mock authentication', () {
    final provider = MockAuthProvider();

    test('should not be initialized to begin with',
        () => {expect(provider.isInitialized, false)});

    test(
      'cannot log out if not initialized',
      () => {
        expect(
          provider.logOut(),
          throwsA(
            const TypeMatcher<NotInitializedException>(),
          ),
        )
      },
    );

    test('should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user should delegate to logIn function', () async {
      await provider.initialize();
      final badEmailUser =
          provider.createUser(email: 'foo@bar.com', password: 'anypassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));

      final badPasswordUser =
          provider.createUser(email: 'seome@bar.com', password: 'foobar');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordException>()));

      final user = await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('login user should be able to get verified', () async {
      await provider.initialize();
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user?.isEmailVerified, true);
    });

    test('should be able to logout and login again', () async {
      await provider.initialize();
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();

    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw UserNotFoundException();
    if (password == 'foobar') throw WrongPasswordException();
    const user =
        AuthUser(isEmailVerified: false, email: 'foo@bar.com', id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser =
        AuthUser(isEmailVerified: true, email: 'foo@bar.com', id: 'my_id');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordRest({required String toEmail}) {
    // TODO: implement sendPasswordRest
    throw UnimplementedError();
  }
}
