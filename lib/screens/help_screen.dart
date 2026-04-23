import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Advertiser {
  final String name;
  final String description;
  final String imageUrl;

  Advertiser({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Advertiser> advertisers = [
    Advertiser(
      name: 'TechNova Solutions',
      description: 'Providing cloud-based SaaS tools for startups',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Advertiser(
      name: 'EduBridge',
      description: 'Connecting students with global scholarship programs',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Advertiser(
      name: 'HealthPlus',
      description: 'Affordable healthcare consultation services',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Advertiser(
      name: 'FinEdge',
      description: 'Personal finance and investment advisory',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Resources'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.8,
            ),
            itemCount: advertisers.length,
            itemBuilder: (context, index) {
              return AdvertiserCard(advertiser: advertisers[index]);
            },
          );
        },
      ),
    );
  }
}

class AdvertiserCard extends StatefulWidget {
  final Advertiser advertiser;

  const AdvertiserCard({super.key, required this.advertiser});

  @override
  State<AdvertiserCard> createState() => _AdvertiserCardState();
}

class _AdvertiserCardState extends State<AdvertiserCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppDurations.normal,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: _isHovered ? AppShadows.md(isDark: isDark) : AppShadows.sm(isDark: isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: isDark ? AppColors.darkBorder : AppColors.border.withValues(alpha: 0.3),
                  child: Image.network(
                    widget.advertiser.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.business,
                      size: 50,
                      color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.advertiser.name,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.advertiser.description,
                            style: theme.textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('View More'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
