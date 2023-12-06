import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:buxa/model/login_model.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockUserCredential extends Mock implements UserCredential {
  @override
  User get user => _mockUser;
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Itt visszaadjuk a mockolt UserCredential-t
    return MockUserCredential();
  }
}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late LoginModel loginFirebase;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    loginFirebase = LoginModel();
  });

  test("sign in", () async {
    // Sikeres bejelentkezés beállítása
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: "proba@gmail.com",
        password: "123456",
      ),
    ).thenAnswer((_) async {
      return MockUserCredential(); // Itt egy MockUserCredential objektummal válaszolunk
    });

    // A loginFirebase metódus hívása a megadott e-mail és jelszóval
    final result = await loginFirebase.loginFirebase(
      "proba@gmail.com",
      "123456",
    );

    // Várt eredmény: User objektummal sikeres bejelentkezés
    expect(result, isA<User>());

    // A signInWithEmailAndPassword tényleges hívásának ellenőrzése
    verify(
      mockFirebaseAuth.signInWithEmailAndPassword(
        email: "proba@gmail.com",
        password: "123456",
      ),
    ).called(1);
  });
}
