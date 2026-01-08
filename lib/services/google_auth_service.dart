import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInData {
  final String email;
  final String displayName;
  final String? authorizationCode;
  final String? idToken;
  final String? accessToken;

  GoogleSignInData({
    required this.email,
    required this.displayName,
    this.authorizationCode,
    this.idToken,
    this.accessToken,
  });
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    serverClientId: 'YOUR_GOOGLE_SERVER_CLIENT_ID_HERE', // Ganti dengan Server Client ID Anda dari Google Console
  );

  Future<GoogleSignInData?> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[DEBUG] Google sign in cancelled by user');
        return null;
      }

      final googleAuth = await googleUser.authentication;
      
      print('[DEBUG] Google sign in successful');
      print('[DEBUG] Authorization code: ${googleAuth.serverAuthCode}');

      return GoogleSignInData(
        email: googleUser.email,
        displayName: googleUser.displayName ?? 'User',
        authorizationCode: googleAuth.serverAuthCode, // Authorization code untuk backend
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
    } catch (e) {
      print('[DEBUG] Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('[DEBUG] Google sign out successful');
    } catch (e) {
      print('[DEBUG] Error signing out: $e');
    }
  }
}
