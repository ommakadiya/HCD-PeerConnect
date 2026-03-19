import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    // Mock network delay for authentication
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assests/App Icon.png', height: 100),
              const SizedBox(height: 30),
              const Text(
                'Welcome to PeerConnect',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Connect with your community safely and effortlessly.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _handleGoogleSignIn,
                      icon: const Icon(FontAwesomeIcons.google, color: Colors.red),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
