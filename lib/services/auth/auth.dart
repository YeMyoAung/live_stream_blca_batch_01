import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;
  AuthService()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn.standard(),
        _facebookAuth = FacebookAuth.instance;

  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? result = await _googleSignIn.signIn();
    if (result == null) {
      //TODO
      return;
    }
    final GoogleSignInAuthentication auth = await result.authentication;
    return _loginWithCredentail(
      GoogleAuthProvider.credential(accessToken: auth.accessToken),
    );
  }

  Future<void> loginWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();
    if (result.status != LoginStatus.success) {
      //TODO
      return;
    }
    final String? token = result.accessToken?.token;
    if (token == null) {
      ///TODO
      return;
    }
    return _loginWithCredentail(
      FacebookAuthProvider.credential(token),
    );
  }

  Future<void> _loginWithCredentail(OAuthCredential credential) async {
    _auth.signInWithCredential(credential);
  }
}
