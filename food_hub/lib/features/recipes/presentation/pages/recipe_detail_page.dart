import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../favorites/data/models/favorite_meal_model.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../data/models/meal_detail_model.dart';
import '../providers/meal_providers.dart';

/// Full-screen recipe detail with Hero image, ingredients and instructions.
class RecipeDetailPage extends ConsumerWidget {
  final String mealId;

  const RecipeDetailPage({super.key, required this.mealId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealAsync = ref.watch(mealDetailProvider(mealId));

    return mealAsync.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(mealDetailProvider(mealId)),
        ),
      ),
      data: (meal) => _DetailBody(meal: meal),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailBody extends ConsumerWidget {
  final MealDetailModel meal;

  const _DetailBody({required this.meal});

  Future<void> _toggleFavorite(WidgetRef ref) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    final repo = ref.read(favoritesRepositoryProvider);
    final isFav = await repo.isFavorite(uid, meal.id);
    if (isFav) {
      await repo.removeFavorite(uid, meal.id);
    } else {
      await repo.addFavorite(
        uid,
        FavoriteMealModel(
          mealId: meal.id,
          name: meal.name,
          thumbnailUrl: meal.thumbnailUrl,
          category: meal.category,
          addedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Splits the instruction blob into individual steps.
  List<String> _parseSteps(String raw) => raw
      .split(RegExp(r'\r?\n\r?\n'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final steps = _parseSteps(meal.instructions);
    final isFavAsync = ref.watch(isFavoriteProvider(meal.id));
    final isFav = isFavAsync.value ?? false;

    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor:
                    theme.colorScheme.surface.withValues(alpha: 0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor:
                      theme.colorScheme.surface.withValues(alpha: 0.85),
                  child: IconButton(
                    icon: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(ref),
                    tooltip:
                        isFav ? 'Remove from favorites' : 'Add to favorites',
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'meal_${meal.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: meal.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: AppColors.heroGradient,
                          stops: [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    meal.name,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),

                  // Category / Area / Tags chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (meal.area.isNotEmpty)
                        Chip(
                          avatar: const Icon(Icons.place_outlined, size: 16),
                          label: Text(meal.area),
                          visualDensity: VisualDensity.compact,
                        ),
                      if (meal.category.isNotEmpty)
                        Chip(
                          avatar: const Icon(Icons.category_outlined,
                              size: 16),
                          label: Text(meal.category),
                          visualDensity: VisualDensity.compact,
                        ),
                      ...meal.tags.map(
                        (t) => Chip(
                          label: Text(t),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Ingredients ───────────────────────────────────────
                  Text(
                    l10n.ingredients,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...meal.ingredients.map(
                    (ing) => _IngredientRow(
                      name: ing.name,
                      measure: ing.measure,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Instructions ──────────────────────────────────────
                  Text(
                    l10n.instructions,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...steps.asMap().entries.map(
                        (e) => _InstructionStep(
                          number: e.key + 1,
                          text: e.value,
                        ),
                      ),

                  // ── YouTube button ────────────────────────────────────
                  if (meal.youtubeUrl != null &&
                      meal.youtubeUrl!.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _openYoutube(meal.youtubeUrl!),
                        icon: const Icon(Icons.play_circle_outline_rounded),
                        label: Text(l10n.watchOnYoutube),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF0000),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _IngredientRow extends StatelessWidget {
  final String name;
  final String measure;

  const _IngredientRow({required this.name, required this.measure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            measure,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _InstructionStep extends StatelessWidget {
  final int number;
  final String text;

  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: theme.textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
