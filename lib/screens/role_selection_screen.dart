import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'child_profile_setup_screen.dart';
import 'parent_profile_setup_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/app logo.jpg', height: 100),
              const SizedBox(height: 30),
              const Text(
                'Who are you?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Select your role to get started',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  children: [
                    _buildRoleCard(
                      context,
                      icon: Icons.child_care,
                      title: 'I am a Child',
                      subtitle: 'Set up your profile and connect with your parents',
                      color: const Color(0xFF003366),
                      onTap: () {
                        Provider.of<AppStateProvider>(context, listen: false).setRole('child');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ChildProfileSetupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildRoleCard(
                      context,
                      icon: Icons.family_restroom,
                      title: 'I am a Parent',
                      subtitle: 'Set up your profile and link to your child',
                      color: const Color(0xFF003366),
                      onTap: () {
                        Provider.of<AppStateProvider>(context, listen: false).setRole('parent');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ParentProfileSetupScreen()),
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 40, color: color),
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
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
