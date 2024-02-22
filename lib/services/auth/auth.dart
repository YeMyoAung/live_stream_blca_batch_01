import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard(),
        _facebookAuth = FacebookAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> userChanges() => _auth.userChanges();

  Future<Result<UserCredential>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? result = await _googleSignIn.signIn();
      if (result == null) {
        return Result(
          error: GeneralError("Login Failed", StackTrace.current),
        );
      }
      final GoogleSignInAuthentication auth = await result.authentication;

      final credential = await _loginWithCredentail(
        GoogleAuthProvider.credential(accessToken: auth.accessToken),
      );
      await _googleSignIn.signOut();
      return credential;
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<Result<UserCredential>> loginWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status != LoginStatus.success) {
        return Result(
            error: GeneralError(
          result.message ?? "Login Failed",
          StackTrace.current,
        ));
      }
      final String? token = result.accessToken?.token;
      if (token == null) {
        return Result(error: GeneralError("Login Failed", StackTrace.current));
      }
      final credentail = await _loginWithCredentail(
        FacebookAuthProvider.credential(token),
      );

      await _facebookAuth.logOut();
      return credentail;
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<Result<UserCredential>> _loginWithCredentail(
      OAuthCredential credential) async {
    try {
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      return Result(data: result);
    } on FirebaseAuthException catch (e) {
      return Result(error: GeneralError(e.code, e.stackTrace));
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      ///
    }
  }
}
