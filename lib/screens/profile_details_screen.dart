import 'package:flutter/material.dart';
import '../models/dummy_users.dart';
import '../theme/app_theme.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final DummyUser user;
  final ValueChanged<bool> onConnectionStatusChanged;

  const ProfileDetailsScreen({
    super.key,
    required this.user,
    required this.onConnectionStatusChanged,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  late bool isConnected;

  @override
  void initState() {
    super.initState();
    isConnected = widget.user.isConnected;
  }

  void _toggleConnection() {
    setState(() {
      isConnected = !isConnected;
    });
    widget.user.isConnected = isConnected;
    widget.onConnectionStatusChanged(isConnected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            // ══════════════════════════════════════
            //  HERO SECTION
            // ══════════════════════════════════════
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(user.profileImage),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Name
                    Text(
                      user.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flight_takeoff_rounded,
                          size: 15,
                          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${user.country} → ${user.migratedCountry}',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Connect button
                    SizedBox(
                      width: 180,
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: _toggleConnection,
                        icon: Icon(
                          isConnected ? Icons.check_rounded : Icons.person_add_outlined,
                          size: 18,
                        ),
                        label: Text(
                          isConnected ? 'Connected' : '+ Connect',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConnected ? AppColors.success : AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // ══════════════════════════════════════
            //  SECTION CARDS
            // ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  // ── 1. Basic Info ──
                  _SectionCard(
                    isDark: isDark,
                    title: 'BASIC INFO',
                    theme: theme,
                    child: Column(
                      children: [
                        _InfoRow(label: 'Age', value: '${user.age} years', isDark: isDark, theme: theme),
                        _divider(isDark),
                        _InfoRow(label: 'Gender', value: user.gender, isDark: isDark, theme: theme),
                        _divider(isDark),
                        _InfoRow(label: 'From', value: user.country, isDark: isDark, theme: theme),
                        _divider(isDark),
                        _InfoRow(label: 'Living in', value: user.migratedCountry, isDark: isDark, theme: theme),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── 2. Skills ──
                  _SectionCard(
                    isDark: isDark,
                    title: 'SKILLS',
                    theme: theme,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: user.skills.map((s) => _buildTag(s, isDark)).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── 3. Interests ──
                  _SectionCard(
                    isDark: isDark,
                    title: 'INTERESTS',
                    theme: theme,
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: user.interests.map((i) => _buildTag(i, isDark)).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── 4. Bio ──
                  _SectionCard(
                    isDark: isDark,
                    title: 'ABOUT',
                    theme: theme,
                    child: Text(
                      user.bio,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tag chip ──
  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9), // bg-gray-100
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkText : const Color(0xFF374151), // text-gray-700
        ),
      ),
    );
  }

  // ── Thin divider ──
  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: isDark ? AppColors.darkBorder : AppColors.border,
    );
  }
}

// ══════════════════════════════════════════════════
//  REUSABLE SECTION CARD
// ══════════════════════════════════════════════════
class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final ThemeData theme;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.title,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        boxShadow: AppShadows.sm(isDark: isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  INFO ROW — label : value
// ══════════════════════════════════════════════════
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final ThemeData theme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
