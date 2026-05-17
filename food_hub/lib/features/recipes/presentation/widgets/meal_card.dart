import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/string_translator.dart';
import '../../data/models/meal_model.dart';

/// Horizontal list card for a single meal.
/// Hero tag matches [RecipeDetailPage] for the image transition.
class MealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // ── Thumbnail ────────────────────────────────────────────
              Hero(
                tag: 'meal_${meal.id}',
                child: SizedBox(
                  width: 110,
                  height: 110,
                  child: CachedNetworkImage(
                    imageUrl: meal.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor:
                          theme.colorScheme.surfaceContainerHighest,
                      highlightColor: theme.colorScheme.surface,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Info ─────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (meal.area != null || meal.category != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                [
                                  meal.area?.translateDynamic(context),
                                  meal.category?.translateDynamic(context)
                                ]
                                    .whereType<String>()
                                    .where((s) => s.isNotEmpty)
                                    .join(' • '),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
