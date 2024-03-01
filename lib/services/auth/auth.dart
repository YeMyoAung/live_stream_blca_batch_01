import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  final ImagePicker _imagePicker;
  final FirebaseStorage _storage;

  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard(),
        _facebookAuth = FacebookAuth.instance,
        _imagePicker = locator<ImagePicker>(),
        _storage = locator<FirebaseStorage>();

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

      final credential = await _loginWithCredential(
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
      final credential = await _loginWithCredential(
        FacebookAuthProvider.credential(token),
      );

      await _facebookAuth.logOut();
      return credential;
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  Future<Result<UserCredential>> _loginWithCredential(
    OAuthCredential credential,
  ) async {
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

  Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
  }

  Future<void> updateProfile() async {
    final user = currentUser;
    if (user == null) return;
    final data = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (data == null) return;
    final prev = user.photoURL;
    if (prev?.startsWith("users/") == true) {
      await _storage.ref(prev).delete();
    }
    final profilePath = "users/${user.uid}_${DateTime.now().toIso8601String()}";
    await _storage.ref(profilePath).putFile(File(data.path));
    await user.updatePhotoURL(profilePath);
  }
}
