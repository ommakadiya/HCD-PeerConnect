import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/dummy_users.dart';
import 'profile_details_screen.dart';

class StudentConnectionsScreen extends StatefulWidget {
  const StudentConnectionsScreen({super.key});

  @override
  State<StudentConnectionsScreen> createState() => _StudentConnectionsScreenState();
}

class _StudentConnectionsScreenState extends State<StudentConnectionsScreen> {
  String _searchQuery = '';
  List<DummyUser> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _filteredUsers = List.from(dummyUsers);
          _isLoading = false;
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase().trim();
      if (_searchQuery.isEmpty) {
        _filteredUsers = List.from(dummyUsers);
      } else {
        _filteredUsers = dummyUsers.where((user) {
          return user.name.toLowerCase().contains(_searchQuery) ||
              user.country.toLowerCase().contains(_searchQuery) ||
              user.migratedCountry.toLowerCase().contains(_searchQuery) ||
              user.skills.any((s) => s.toLowerCase().contains(_searchQuery));
        }).toList();
      }
    });
  }

  void _toggleConnection(DummyUser user) {
    setState(() {
      user.isConnected = !user.isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Connect')),
      body: Column(
        children: [
          // ── STICKY SEARCH BAR ──
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            child: TextField(
              onChanged: _onSearchChanged,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search by name, skills, or location…',
                prefixIcon: Icon(Icons.search, size: 20, color: isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                filled: true,
                fillColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ── HEADER ──
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (!_isLoading)
                  Text(
                    '${_filteredUsers.length} people',
                    style: theme.textTheme.labelMedium,
                  ),
              ],
            ),
          ),

          // ── CONTENT ──
          Expanded(
            child: _isLoading
                ? _buildSkeletonGrid(isDark)
                : _filteredUsers.isEmpty
                    ? _buildEmptyState(isDark, theme)
                    : _buildUserGrid(isDark, theme),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  RESPONSIVE USER GRID
  // ══════════════════════════════════════════════
  Widget _buildUserGrid(bool isDark, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns;
        if (constraints.maxWidth >= 900) {
          columns = 3; // Desktop
        } else if (constraints.maxWidth >= 550) {
          columns = 2; // Tablet
        } else {
          columns = 1; // Mobile
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: columns == 1 ? 2.0 : 0.78,
          ),
          itemCount: _filteredUsers.length,
          itemBuilder: (context, index) {
            final user = _filteredUsers[index];
            return columns == 1
                ? _buildHorizontalCard(user, isDark, theme)
                : _buildVerticalCard(user, isDark, theme);
          },
        );
      },
    );
  }

  // ══════════════════════════════════════════════
  //  VERTICAL CARD (tablet / desktop grid)
  // ══════════════════════════════════════════════
  Widget _buildVerticalCard(DummyUser user, bool isDark, ThemeData theme) {
    return _HoverCard(
      isDark: isDark,
      onTap: () => _navigateToProfile(user),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top: avatar + name + location ──
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.profileImage),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${user.country} → ${user.migratedCountry}',
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Middle: skill tags ──
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: user.skills.take(3).map((skill) => _buildSkillTag(skill, isDark)).toList(),
              ),
            ),

            // ── Bottom: connect button ──
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: _buildConnectButton(user, isDark),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  HORIZONTAL CARD (mobile single column)
  // ══════════════════════════════════════════════
  Widget _buildHorizontalCard(DummyUser user, bool isDark, ThemeData theme) {
    return _HoverCard(
      isDark: isDark,
      onTap: () => _navigateToProfile(user),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.profileImage),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${user.country} → ${user.migratedCountry}',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: user.skills.take(3).map((s) => _buildSkillTag(s, isDark)).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildConnectButton(user, isDark),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  SKILL TAG
  // ══════════════════════════════════════════════
  Widget _buildSkillTag(String skill, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.15)
            : const Color(0xFFDBEAFE), // bg-blue-100
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        skill,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.primary : const Color(0xFF1D4ED8), // text-blue-700
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  CONNECT BUTTON with states
  // ══════════════════════════════════════════════
  Widget _buildConnectButton(DummyUser user, bool isDark) {
    final connected = user.isConnected;
    return SizedBox(
      height: 34,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        child: ElevatedButton(
          onPressed: () => _toggleConnection(user),
          style: ElevatedButton.styleFrom(
            backgroundColor: connected ? AppColors.success : AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                connected ? Icons.check : Icons.person_add_outlined,
                size: 14,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(connected ? 'Connected' : '+ Connect'),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  NAVIGATE TO PROFILE
  // ══════════════════════════════════════════════
  void _navigateToProfile(DummyUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileDetailsScreen(
          user: user,
          onConnectionStatusChanged: (status) {
            setState(() => user.isConnected = status);
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  EMPTY STATE
  // ══════════════════════════════════════════════
  Widget _buildEmptyState(bool isDark, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_search_outlined,
              size: 48,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'No users found',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try adjusting your search criteria.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  SKELETON GRID
  // ══════════════════════════════════════════════
  Widget _buildSkeletonGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = constraints.maxWidth >= 900 ? 3 : (constraints.maxWidth >= 550 ? 2 : 1);
        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: columns == 1 ? 2.4 : 0.85,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => _buildSkeletonCard(isDark),
        );
      },
    );
  }

  Widget _buildSkeletonCard(bool isDark) {
    final shimmer = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);
    final base = isDark ? AppColors.darkSurface : AppColors.surface;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: shimmer, shape: BoxShape.circle)),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 14, decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(width: 70, height: 10, decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(width: 50, height: 20, decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 6),
              Container(width: 60, height: 20, decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(4))),
            ],
          ),
          const Spacer(),
          Container(width: double.infinity, height: 34, decoration: BoxDecoration(color: shimmer, borderRadius: BorderRadius.circular(AppRadius.sm))),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  HOVER CARD — scale + shadow on hover / long press
// ══════════════════════════════════════════════════
class _HoverCard extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  final Widget child;

  const _HoverCard({
    required this.isDark,
    required this.onTap,
    required this.child,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hovering ? 1.025 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: _hovering
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : (widget.isDark ? AppColors.darkBorder : AppColors.border),
            ),
            boxShadow: _hovering
                ? AppShadows.md(isDark: widget.isDark)
                : AppShadows.sm(isDark: widget.isDark),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
