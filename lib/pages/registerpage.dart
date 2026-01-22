import 'package:flutter/material.dart';
import 'package:jagamata/services/api_service.dart';
import 'package:jagamata/services/google_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await ApiService.register(
      email: emailController.text.trim(),
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Registrasi gagal!")),
      );
    }
  }

  void handleGoogleRegister() async {
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
        
        final result = await ApiService.loginWithGoogle(
          code: code,
          idToken: idToken,
        );
        
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registrasi Google berhasil!")),
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
            SnackBar(content: Text(result['message'] ?? "Registrasi Google gagal")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google sign in dibatalkan")),
        );
      }
    } catch (e) {
      print('[DEBUG] Google register error: $e');
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
                      height: 100, // Adjusted height
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50, color: kDarkBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Welcome Text
                Text(
                  "Bergabung Bersama Kami!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlue,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Buat akun untuk memulai perjalananmu",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Inputs
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Field
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined, color: kDarkBlue),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Username Field
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person_outline, color: kDarkBlue),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Register Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: kDarkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        onPressed: isLoading ? null : handleRegister,
                        child: isLoading 
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                            "DAFTAR",
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

                      // Google Register Button
                      OutlinedButton(
                        onPressed: isLoading ? null : handleGoogleRegister,
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
                                "Daftar dengan Google",
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

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: kLightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              key: Key('already_have_account')// for testing
                            ),
                          ),
                        ],
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
