import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/string_translator.dart';
import '../../../../features/recipes/data/models/category_model.dart';

/// Grid card for a meal category.
/// Uses Hero tag for the transition to the recipe list screen.
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'category_${category.id}',
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Background image ───────────────────────────────────
                  CachedNetworkImage(
                    imageUrl: category.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: theme.colorScheme.surfaceContainerHighest,
                      highlightColor:
                          theme.colorScheme.surface,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 40,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ),

                  // ── Gradient overlay ───────────────────────────────────
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.heroGradient,
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),

                  // ── Category name ──────────────────────────────────────
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      category.name.translateDynamic(context),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
