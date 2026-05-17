import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/string_translator.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../providers/filter_provider.dart';
import '../providers/meal_providers.dart';
import '../widgets/meal_card.dart';

/// Displays meals for a [categoryName] with optional area filter chips.
class RecipeListPage extends ConsumerStatefulWidget {
  final String categoryName;

  const RecipeListPage({super.key, required this.categoryName});

  @override
  ConsumerState<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends ConsumerState<RecipeListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear filter when entering a new category list
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(filterProvider.notifier).clearAll(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = ref.watch(filterProvider);

    // Switch data source depending on active area filter
    final mealsAsync = filter.hasArea
        ? ref.watch(mealsByAreaProvider(filter.selectedArea!))
        : ref.watch(mealsByCategoryProvider(widget.categoryName));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (filter.hasArea) {
            ref.invalidate(mealsByAreaProvider(filter.selectedArea!));
          } else {
            ref.invalidate(mealsByCategoryProvider(widget.categoryName));
          }
        },
        child: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              expandedHeight: 140,
              backgroundColor: theme.colorScheme.surface,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  filter.hasArea
                      ? '${filter.selectedArea!.translateDynamic(context)} Cuisine'
                      : widget.categoryName.translateDynamic(context),
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 56,
                  bottom: 16,
                ),
              ),
            ),

            // ── Search bar ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: SearchBar(
                  controller: _searchController,
                  hintText: filter.hasArea
                      ? 'Search in ${filter.selectedArea!.translateDynamic(context)}...'
                      : 'Search in ${widget.categoryName.translateDynamic(context)}...',
                  leading: const Icon(Icons.search_rounded),
                  onChanged: (_) => setState(() {}),
                  elevation: const WidgetStatePropertyAll(1),
                ),
              ),
            ),

            // ── Area filter chips ──────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: popularAreas.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final area = popularAreas[i];
                    final selected = filter.selectedArea == area;
                    return FilterChip(
                      label: Text(area.translateDynamic(context)),
                      selected: selected,
                      onSelected: (_) =>
                          ref.read(filterProvider.notifier).toggleArea(area),
                      selectedColor:
                          theme.colorScheme.primaryContainer,
                      checkmarkColor: theme.colorScheme.primary,
                    );
                  },
                ),
              ),
            ),

            // ── Meals list ─────────────────────────────────────────────
            mealsAsync.when(
              loading: () => SliverList.builder(
                itemCount: 6,
                itemBuilder: (_, __) => const _ShimmerCard(),
              ),
              error: (e, _) => SliverFillRemaining(
                child: ErrorView(
                  message: e.toString(),
                  onRetry: () {
                    if (filter.hasArea) {
                      ref.invalidate(
                          mealsByAreaProvider(filter.selectedArea!));
                    } else {
                      ref.invalidate(
                          mealsByCategoryProvider(widget.categoryName));
                    }
                  },
                ),
              ),
              data: (meals) {
                final q = _searchController.text.toLowerCase();
                final filtered = q.isEmpty
                    ? meals
                    : meals
                        .where(
                            (m) => m.name.toLowerCase().contains(q))
                        .toList();

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyView(
                      title: 'No recipes found',
                      subtitle: 'Try a different search or filter.',
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => MealCard(
                    meal: filtered[i],
                    onTap: () => context.push(
                      '${AppRoutes.recipeDetail}?id=${filtered[i].id}',
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
