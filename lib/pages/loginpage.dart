import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:jagamata/services/google_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() async {
    FocusScope.of(context).unfocus();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi email dan password terlebih dahulu!")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.login(
      email: email,
      password: password,
    );

    setState(() => isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil!")),
      );

      final userData = result['data'];
      final address = userData['address'];
      final phoneNumber = userData['phone_number'];
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (address == null || address.toString().isEmpty || 
            phoneNumber == null || phoneNumber.toString().isEmpty) {
          Navigator.pushReplacementNamed(context, '/complete-profile');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Login gagal!")),
      );
    }
  }

  void handleGoogleLogin() async {
    setState(() => isLoading = true);
    try {
      final googleAuthService = GoogleAuthService();
      final googleData = await googleAuthService.signIn();
      
      if (googleData != null) {
        final code = googleData.authorizationCode ?? '';
        final idToken = googleData.idToken ?? '';
        
        if (code.isEmpty && idToken.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal mendapatkan kode otorisasi atau ID Token")),
          );
          return;
        }
        
        print('[DEBUG] Attempting login with code: ${code.substring(0, code.length > 20 ? 20 : code.length)}...');
        print('[DEBUG] ID Token available: ${idToken.isNotEmpty}');
        
        final result = await ApiService.loginWithGoogle(
          code: code,
          idToken: idToken,
        );
        
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login Google berhasil!")),
          );
          
          final userData = result['data'];
          final address = userData['address'];
          final phoneNumber = userData['phone_number'];

          Future.delayed(const Duration(milliseconds: 800), () {
            if (address == null || address.toString().isEmpty || 
                phoneNumber == null || phoneNumber.toString().isEmpty) {
              Navigator.pushReplacementNamed(context, '/complete-profile');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? "Login Google gagal")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google sign in dibatalkan")),
        );
      }
    } catch (e) {
      print('[DEBUG] Google login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/maskot.png', height: 250),
                const SizedBox(height: 10),
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A77A1),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A77A1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isLoading ? "LOADING..." : "LOGIN",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(
                            Icons.g_mobiledata,
                            size: 24,
                            color: Colors.red,
                          ),
                          label: const Text(
                            "LOGIN DENGAN GOOGLE",
                            style: TextStyle(fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: isLoading ? null : handleGoogleLogin,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: const Text(
                          "BELUM PUNYA AKUN? DAFTAR SEKARANG",
                          style: TextStyle(
                            color: Color(0xFF4A77A1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
