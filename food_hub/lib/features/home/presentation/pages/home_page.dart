import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../recipes/presentation/providers/meal_providers.dart';
import '../widgets/category_card.dart';
import '../widgets/meal_of_day_card.dart';

/// Main home screen: search, Meal of the Day, categories grid.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _searchController = TextEditingController();
  bool _searchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(mealOfDayProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────────
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 120,
              backgroundColor: theme.colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                  start: 20,
                  bottom: 16,
                ),
                title: Text(
                  'FoodHub',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() => _searchActive = !_searchActive);
                    if (!_searchActive) _searchController.clear();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _searchActive
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      key: ValueKey(_searchActive),
                    ),
                  ),
                  tooltip:
                      _searchActive ? 'Close search' : 'Search recipes',
                ),
                const SizedBox(width: 8),
              ],
            ),

            // ── Search bar ─────────────────────────────────────────────
            if (_searchActive)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: l10n.searchHint,
                    leading: const Icon(Icons.search_rounded),
                    onChanged: (_) => setState(() {}),
                    elevation: const WidgetStatePropertyAll(1),
                  ),
                ),
              ),

            // ── Meal of the Day ────────────────────────────────────────
            if (!_searchActive) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                  child: Text(
                    l10n.mealOfDay,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: MealOfDayCard(),
                ),
              ),
            ],

            // ── Categories header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.categories,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            // ── Categories Grid ────────────────────────────────────────
            categoriesAsync.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: List.generate(8, (_) => const _ShimmerCard()),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(categoriesProvider),
                ),
              ),
              data: (categories) {
                final filtered = _searchController.text.isEmpty
                    ? categories
                    : categories
                        .where((c) => c.name.toLowerCase().contains(
                              _searchController.text.toLowerCase(),
                            ))
                        .toList();

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyView(
                      title: 'No categories found',
                      subtitle: 'Try a different search term.',
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final category = filtered[index];
                      return CategoryCard(
                        category: category,
                        onTap: () => context.push(
                          '${AppRoutes.recipeList}?category=${Uri.encodeComponent(category.name)}',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
