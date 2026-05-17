import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/string_translator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../recipes/presentation/providers/meal_providers.dart';

/// Featured "Meal of the Day" card shown at the top of the home screen.
/// Navigates to the recipe detail page on tap.
class MealOfDayCard extends ConsumerWidget {
  const MealOfDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mealAsync = ref.watch(mealOfDayProvider);

    return mealAsync.when(
      loading: () => _Skeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (meal) => GestureDetector(
        onTap: () => context.push(
          '${AppRoutes.recipeDetail}?id=${meal.id}',
        ),
        child: Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Hero(
                  tag: 'meal_${meal.id}',
                  child: CachedNetworkImage(
                    imageUrl: meal.thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),

                // Gradient overlay
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.heroGradient,
                      stops: [0.3, 1.0],
                    ),
                  ),
                ),

                // Badge + content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Meal of the Day" badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🍽  ${AppLocalizations.of(context)!.mealOfDay}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Meal name
                      Text(
                        meal.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 6,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Category + Area
                      if (meal.category.isNotEmpty || meal.area.isNotEmpty)
                        Text(
                          [
                            meal.area.translateDynamic(context),
                            meal.category.translateDynamic(context),
                          ].where((s) => s.isNotEmpty).join(' • '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
