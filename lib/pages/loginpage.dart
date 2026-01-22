import 'package:flutter/material.dart';
import 'package:jagamata/pages/loading_page.dart';
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
      // Show explicit loading page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoadingPage()),
      );

      final userData = result['data'];
      final address = userData['address'];
      final phoneNumber = userData['phone_number'];
      
      // Wait a bit to show the loading screen (optional, but requested for UX)
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (address == null || address.toString().isEmpty || 
          phoneNumber == null || phoneNumber.toString().isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/complete-profile', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
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
          // Show explicit loading page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoadingPage()),
          );
          
          final userData = result['data'];
          final address = userData['address'];
          final phoneNumber = userData['phone_number'];

          // Wait a bit to show the loading screen
          await Future.delayed(const Duration(seconds: 2));

          if (!mounted) return;

          if (address == null || address.toString().isEmpty || 
              phoneNumber == null || phoneNumber.toString().isEmpty) {
            Navigator.pushNamedAndRemoveUntil(context, '/complete-profile', (route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
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
  Widget build(BuildContext context) {
    // Define brand colors
    const Color kDarkBlue = Color(0xFF11417f);
    const Color kLightBlue = Color(0xFF14b4ef);
    // const Color kTosca = Color(0xFFa2c38e); // Unused for now but good to have reference

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Area
                Hero(
                  tag: 'logo',
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Image.asset(
                      'images/logo/logo-with-text.png',
                      height: 120, // Slightly larger for emphasis on white
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 50, color: kDarkBlue);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Welcome Text
                Text(
                  "Selamat Datang!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlue,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Silakan masuk untuk melanjutkan",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                // Inputs
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Field
                    TextField(
                      key: const Key('login_email'),
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined, color: kDarkBlue),
                        filled: true,
                        fillColor: Colors.grey[100], // Subtle grey fill
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: kLightBlue, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Field
                    TextField(
                      key: const Key('login_password'),
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: kDarkBlue),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: kLightBlue, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Login Button
                    ElevatedButton(
                      key: const Key('login_button'),// for testing
                      onPressed: isLoading ? null : handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kDarkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2, // Reduced elevation for cleaner look
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              "MASUK",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                    
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("atau", style: TextStyle(color: Colors.grey[500])),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Google Login Button
                    OutlinedButton(
                      onPressed: isLoading ? null : handleGoogleLogin,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'images/googleSymbol.png',
                            height: 24,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24, color: Colors.blue),
                          ),
                          const SizedBox(width: 12),
                          const Flexible(
                            child: Text(
                              "Masuk dengan Google",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum punya akun? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: kLightBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
