import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Data Model ──
class Advertiser {
  final String name;
  final String description;
  final String category;
  final IconData icon;
  final Color brandColor;

  const Advertiser({
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.brandColor,
  });
}

// ── Static data ──
const _advertisers = [
  Advertiser(
    name: 'TechNova Solutions',
    description: 'Cloud-based SaaS tools to help startups launch faster and scale smarter.',
    category: 'SaaS',
    icon: Icons.cloud_outlined,
    brandColor: Color(0xFF3B82F6),
  ),
  Advertiser(
    name: 'EduBridge',
    description: 'Connecting students with global scholarship programs and mentors worldwide.',
    category: 'Education',
    icon: Icons.school_outlined,
    brandColor: Color(0xFF8B5CF6),
  ),
  Advertiser(
    name: 'HealthPlus',
    description: 'Affordable healthcare consultations with certified professionals, 24/7.',
    category: 'Healthcare',
    icon: Icons.favorite_outline,
    brandColor: Color(0xFFEF4444),
  ),
  Advertiser(
    name: 'FinEdge',
    description: 'Personal finance advisory and smart investment tracking for everyone.',
    category: 'Finance',
    icon: Icons.trending_up_outlined,
    brandColor: Color(0xFF10B981),
  ),
  Advertiser(
    name: 'WorkHive',
    description: 'Find co-working spaces and remote-friendly offices near your location.',
    category: 'Workspace',
    icon: Icons.business_outlined,
    brandColor: Color(0xFFF59E0B),
  ),
  Advertiser(
    name: 'LegalEase',
    description: 'Immigration and visa assistance tailored for migrants and students abroad.',
    category: 'Legal',
    icon: Icons.gavel_outlined,
    brandColor: Color(0xFF6366F1),
  ),
];

// ══════════════════════════════════════════════════
//  HELP SCREEN
// ══════════════════════════════════════════════════
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Resources')),
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Partner Services',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Curated tools and services to help you settle in and thrive.',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // ── Responsive Grid ──
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                int columns;
                if (constraints.crossAxisExtent >= 900) {
                  columns = 3;
                } else if (constraints.crossAxisExtent >= 550) {
                  columns = 2;
                } else {
                  columns = 1;
                }

                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _AdvertiserCard(
                      advertiser: _advertisers[index],
                      isDark: isDark,
                    ),
                    childCount: _advertisers.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    mainAxisExtent: 180,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════
//  ADVERTISER CARD — startup marketplace style
// ══════════════════════════════════════════════════
class _AdvertiserCard extends StatefulWidget {
  final Advertiser advertiser;
  final bool isDark;

  const _AdvertiserCard({required this.advertiser, required this.isDark});

  @override
  State<_AdvertiserCard> createState() => _AdvertiserCardState();
}

class _AdvertiserCardState extends State<_AdvertiserCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = widget.isDark;
    final ad = widget.advertiser;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_hovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _hovered
                ? ad.brandColor.withValues(alpha: 0.4)
                : (isDark ? AppColors.darkBorder : AppColors.border),
          ),
          boxShadow: _hovered
              ? AppShadows.md(isDark: isDark)
              : AppShadows.sm(isDark: isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top: Logo + Category ──
            Row(
              children: [
                // Brand icon
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ad.brandColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(ad.icon, size: 22, color: ad.brandColor),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.name,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ad.brandColor.withValues(alpha: isDark ? 0.12 : 0.06),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ad.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: ad.brandColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Description ──
            Expanded(
              child: Text(
                ad.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.4,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── CTA ──
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: ad.brandColor,
                  side: BorderSide(color: ad.brandColor.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
