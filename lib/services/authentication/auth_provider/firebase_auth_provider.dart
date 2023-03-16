import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/authentication/auth_provider.dart';
import 'package:mynotes/services/authentication/authentication.dart';
import 'package:mynotes/services/authentication/authentication_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Authentication> createUser(
      {required String username, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      return UsernameAndPasswordAuthentication(
        id: userCredential.user!.uid,
        username: username,
        isAuthenticated: false,
        isEmailVerified: false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw UserAlreadyExistsException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      }
      throw const AuthenticationException('Registration failure');
    }
  }

  @override
  Future<Authentication> login({
    required String username,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return AnonymousAuthentication();
      }
      return UsernameAndPasswordAuthentication(
        id: currentUser.uid,
        username: username,
        isAuthenticated: true,
        isEmailVerified: currentUser.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'user-disabled') {
        throw UserIsNotEnabledException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      }
      throw const AuthenticationException('Login Failure');
    }
  }

  @override
  Future<void> logout() async {
    final currentUser = _firebaseAuth.currentUser;
    log("current user is ${currentUser == null ? 'null' : 'not null'}");
    if (currentUser == null) {
      throw UserIsNotLoggedInException();
    }
    return await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw UserIsNotLoggedInException();
    }
    return await currentUser.sendEmailVerification();
  }
}
