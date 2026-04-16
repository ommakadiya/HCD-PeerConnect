import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'login_screen.dart';
import 'main_layout.dart';
import 'role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Wait for splash then check session
    Future.delayed(const Duration(seconds: 3), _checkSessionAndNavigate);
  }

  Future<void> _checkSessionAndNavigate() async {
    if (!mounted) return;

    final provider = context.read<AppStateProvider>();

    // Try to restore Firebase session from a previous sign-in
    final hasCompletedProfile = await provider.tryRestoreSession();

    if (!mounted) return;

    await _controller.forward(); // fade out
    if (!mounted) return;

    Widget destination;
    if (!provider.isLoggedIn) {
      // Not signed in → Login
      destination = const LoginScreen();
    } else if (!hasCompletedProfile) {
      // Signed in but no profile → Role selection
      destination = const RoleSelectionScreen();
    } else {
      // Fully set up → Home
      destination = const MainLayout();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _opacity,
        child: Center(
          child: Image.asset(
            'assets/logo_appearing_while_opening.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading image: \n$error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
