import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petshop_app/model/user_model.dart';

class MockUser extends Mock implements FirebaseAuth {}

class MockAuthUser extends Mock implements UserModel {}

void main() {
  final MockUser mockUser = MockUser();
  final MockAuthUser authUser = MockAuthUser();

  setUp(() {});
  tearDown(() {});

  test("Criar uma nova conta", () async {
    when(authUser.signUp(email: "giani.braga@gmail.com", pass: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(
        authUser.signUp(
          email: "giani.braga@gmail.com",
          pass: "1234",
        ),
        authUser.signUp(
          email: "giani.braga@gmail.com",
          pass: "12345",
        ));
  });

  test("Logar com uma conta", () async {
    when(mockUser.signInWithEmailAndPassword(
            email: "giani.braga@gmail.com", password: "123456"))
        .thenAnswer((realInvocation) => null);

    expect(
        authUser.signIn(
          email: "giani.braga@gmail.com",
          pass: "123456",
        ),
        authUser.firebaseUser);
  });

  test("Fazer logout", () async {
    when(mockUser.signOut()).thenAnswer((realInvocation) => null);

    expect(authUser.signOut(), authUser.firebaseUser);
  });
}
