import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'privacy_policy_screen.dart';
import '../providers/user_provider.dart';
import '../providers/connection_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);
    final isChild = provider.role == 'child';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                boxShadow: AppShadows.sm(isDark: isDark),
              ),
              child: Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: isDark ? AppColors.darkBorder : AppColors.border,
                        child: Icon(Icons.person, size: 40, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // User Info from Provider
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name.isNotEmpty ? provider.name : 'Your Name',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            isChild ? 'Child' : 'Parent',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                provider.originCity.isNotEmpty ? provider.originCity : 'Your City',
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
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

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Profile Information'),
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.primary, size: 20),
                        onPressed: () => _showEditProfileDialog(context, provider),
                        tooltip: 'Edit Profile Information',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.only(bottom: AppSpacing.md, right: AppSpacing.xs),
                      ),
                    ],
                  ),
                  _buildCard(
                    children: isChild
                        ? [
                            _buildInfoRow(Icons.person, 'Name', provider.name),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.school, 'University', provider.university),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.menu_book, 'Course', provider.course),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.public, 'Country', provider.migratedCountry),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.location_city, 'City', provider.migratedCity),
                          ]
                        : [
                            _buildInfoRow(Icons.person, 'Name', provider.name),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.location_city, 'Origin City', provider.originCity),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.phone, 'Phone', provider.phone),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.home, 'Address', provider.address),
                            const Divider(height: 1, indent: 50),
                            _buildInfoRow(Icons.work, 'Occupation', provider.occupation),
                            if (provider.parentDetails.isNotEmpty) ...[
                              const Divider(height: 1, indent: 50),
                              _buildInfoRow(Icons.child_care, 'Child Email', provider.parentDetails[0].childEmailId),
                            ],
                            if (provider.parentDetails.length > 1) ...[
                              const Divider(height: 1, indent: 50),
                              _buildInfoRow(Icons.person_add, 'Parent 2', provider.parentDetails[1].name),
                            ],
                          ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Account Settings'),
                  _buildCard(
                    children: [
                      _buildSettingsTile(Icons.lock_outline, 'Change Password', onTap: () => _showChangePasswordDialog(context)),
                      const Divider(height: 1, indent: 50),
                      _buildSettingsTile(
                        Icons.privacy_tip_outlined, 
                        'Privacy Policies',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('App Settings'),
                  _buildCard(
                    children: [
                      _buildSwitchTile(Icons.notifications_outlined, 'Notifications', _notificationsEnabled, (val) {
                        setState(() => _notificationsEnabled = val);
                      }),
                      const Divider(height: 1, indent: 50),
                      _buildSwitchTile(Icons.lightbulb_outline, 'Theme', provider.isDarkMode, (val) {
                        provider.toggleTheme(val);
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Security & Logout'),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout', style: TextStyle(fontSize: 16)),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Delete Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            onPressed: () => _showDeleteDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, left: AppSpacing.xs),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        boxShadow: AppShadows.sm(isDark: isDark),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(value.isNotEmpty ? value : '—', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(label, style: Theme.of(context).textTheme.bodySmall),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, AppStateProvider provider) {
    final nameCtrl = TextEditingController(text: provider.name);
    final uniCtrl = TextEditingController(text: provider.university);
    final courseCtrl = TextEditingController(text: provider.course);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: uniCtrl, decoration: const InputDecoration(labelText: 'University')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: courseCtrl, decoration: const InputDecoration(labelText: 'Course')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateProfile(
                name: nameCtrl.text.trim(),
                university: uniCtrl.text.trim(),
                course: courseCtrl.text.trim(),
              );
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Delete Account', style: TextStyle(color: AppColors.error)),
            content: isDeleting 
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: AppColors.error),
                      const SizedBox(height: AppSpacing.lg),
                      const Text('Deleting account and clearing data...'),
                    ],
                  )
                : const Text('Are you sure you want to delete your account? This action cannot be undone.'),
            actions: isDeleting
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        setState(() => isDeleting = true);

                        // Simulate API delay for delete user & sign out
                        await Future.delayed(const Duration(seconds: 2));

                        if (!ctx.mounted) return;

                        // 1. CLEAR USER SESSION COMPLETELY & FORCE APP STATE RESET
                        Provider.of<AppStateProvider>(ctx, listen: false).resetData();
                        Provider.of<UserProvider>(ctx, listen: false).clearUser();
                        Provider.of<ConnectionProvider>(ctx, listen: false).clear();

                        // 2. Close the dialog
                        Navigator.pop(ctx);
                        
                        // 3. Show confirmation message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account and all data erased successfully.')),
                        );
                        
                        // 4. REDIRECT AFTER DELETE & PREVENT RENDERING PROTECTED SCREENS
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
          );
        }
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: currentCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newCtrl.text == confirmCtrl.text && newCtrl.text.isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New passwords do not match or are empty.')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
