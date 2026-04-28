import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../widgets/micro_interactions.dart';
import 'child_profile_setup_screen.dart';
import 'parent_profile_setup_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/app logo.jpg', height: 100),
              const SizedBox(height: 30),
              Text(
                'Who are you?',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Select your role to get started',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  children: [
                    _buildRoleCard(
                      context,
                      icon: Icons.school,
                      title: 'I am a Student',
                      subtitle: 'Set up your profile and connect with your parents',
                      onTap: () {
                        Provider.of<AppStateProvider>(context, listen: false).setRole('child');
                        Navigator.of(context).pushReplacement(
                          FadePageRoute(page: const ChildProfileSetupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildRoleCard(
                      context,
                      icon: Icons.supervisor_account,
                      title: 'I am a Parent',
                      subtitle: 'Set up your profile and link to your child',
                      onTap: () {
                        Provider.of<AppStateProvider>(context, listen: false).setRole('parent');
                        Navigator.of(context).pushReplacement(
                          FadePageRoute(page: const ParentProfileSetupScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = AppColors.primary;

    return PressableScale(
      onTap: onTap,
      scaleFactor: 0.98,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: AppShadows.sm(isDark: isDark),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: 40, color: primary),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: primary, size: 20),
          ],
        ),
      ),
    );
  }
}
