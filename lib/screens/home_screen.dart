import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/group.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildGroupSection(BuildContext context, String title, List<Group> groups) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: groups.length,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemBuilder: (context, index) {
              final group = groups[index];
              return Container(
                width: 240,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  color: isDark ? AppColors.darkSurface : AppColors.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      group.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/app bar logo - Copy.png', height: 40),
        centerTitle: false,
      ),
      body: dataProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Image.asset('assets/app logo.jpg', height: 60),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Welcome to PeerConnect',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Discover communities near you',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildGroupSection(context, 'City Groups', dataProvider.cityGroups),
            _buildGroupSection(context, 'Origin City Groups', dataProvider.originCityGroups),
            _buildGroupSection(context, 'University Groups', dataProvider.universityGroups),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
