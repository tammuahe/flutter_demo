import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());
String getFirebaseAuthErrorMessage(String code) {
  switch (code) {
    case 'invalid-credential':
      return 'Thông tin đăng nhập không chính xác';
    case 'invalid-email':
      return 'Email không hợp lệ.';
    case 'user-disabled':
      return 'Tài khoản đã bị vô hiệu hóa.';
    case 'user-not-found':
      return 'Không tìm thấy người dùng.';
    case 'wrong-password':
      return 'Sai mật khẩu.';
    case 'email-already-in-use':
      return 'Email đã được sử dụng.';
    case 'weak-password':
      return 'Mật khẩu quá yếu.';
    case 'operation-not-allowed':
      return 'Chức năng đăng nhập chưa được bật.';
    default:
      return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }
}

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<(UserCredential?, String?)> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return (
        await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
        null,
      );
    } on FirebaseAuthException catch (e) {
      return (null, getFirebaseAuthErrorMessage(e.code));
    }
  }

  Future<(UserCredential?, String?)> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId:
            "1005316926305-5b59d83qofoea7petelmjnuof2skj5q4.apps.googleusercontent.com",
        serverClientId:
            "1005316926305-is9lb0c5v30uo8tbgq8ckpbp42srre8t.apps.googleusercontent.com",
      );
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return (
        await FirebaseAuth.instance.signInWithCredential(credential),
        null,
      );
    } on FirebaseAuthException catch (e) {
      return (null, getFirebaseAuthErrorMessage(e.code));
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
