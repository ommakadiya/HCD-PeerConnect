import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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

    // Fade out and navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      if (mounted) {
        await _controller.forward();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionDuration: Duration.zero,
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.surface,
      body: FadeTransition(
        opacity: _opacity,
        child: Center(
          child: Image.asset(
            'assets/logo_appearing_while_opening.png',
            fit: BoxFit.fitWidth,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Error loading image: \n$error',
                  style: const TextStyle(color: AppColors.error),
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
