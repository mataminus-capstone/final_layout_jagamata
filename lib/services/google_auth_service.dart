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
  Future<GoogleSignInData?> signIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
        // Manual Configuration MURNI karena google-services.json sudah dihapus
        // Ini memastikan kita hanya menggunakan Project 576... yang benar
        serverClientId: '576319322610-mrac1if4bh1rlq1r342tg1vek4uasr8r.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();
      
      print('[DEBUG] Starting Google Sign In (ID Token Flow)...');
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        print('[DEBUG] Google sign in cancelled by user');
        return null;
      }

      print('[DEBUG] User signed in: ${googleUser.email}');
      
      final googleAuth = await googleUser.authentication;
      
      print('[DEBUG] Google sign in successful');
      print('[DEBUG] ID Token found: ${googleAuth.idToken != null}');

      // FALLBACK STRATEGY: Gunakan ID Token jika Auth Code null
      // ID Token saja sudah cukup untuk validasi user di backend
      
      return GoogleSignInData(
        email: googleUser.email,
        displayName: googleUser.displayName ?? 'User',
        authorizationCode: googleAuth.serverAuthCode,
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
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: '576319322610-mrac1if4bh1rlq1r342tg1vek4uasr8r.apps.googleusercontent.com',
      );
      await googleSignIn.signOut();
      print('[DEBUG] Google sign out successful');
    } catch (e) {
      print('[DEBUG] Error signing out: $e');
    }
  }
}
