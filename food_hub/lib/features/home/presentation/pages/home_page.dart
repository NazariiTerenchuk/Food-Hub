import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../recipes/presentation/providers/meal_providers.dart';
import '../widgets/category_card.dart';

/// Main home screen showing a search bar and categories grid.
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
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => ref.invalidate(categoriesProvider),
        child: CustomScrollView(
          slivers: [
            // ── App Bar ─────────────────────────────────────────────────
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
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FoodHub',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
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
                      _searchActive ? Icons.close_rounded : Icons.search_rounded,
                      key: ValueKey(_searchActive),
                    ),
                  ),
                  tooltip: _searchActive ? 'Close search' : 'Search recipes',
                ),
                const SizedBox(width: 8),
              ],
            ),

            // ── Search bar ───────────────────────────────────────────────
            if (_searchActive)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search recipes...',
                    leading: const Icon(Icons.search_rounded),
                    onChanged: (_) => setState(() {}),
                    elevation: const WidgetStatePropertyAll(1),
                  ),
                ),
              ),

            // ── Greeting ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What would you like to cook today? 🍽️',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Categories',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Categories Grid ──────────────────────────────────────────
            categoriesAsync.when(
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: List.generate(
                    8,
                    (_) => _ShimmerCard(),
                  ),
                ),
              ),
              error: (error, _) => SliverFillRemaining(
                child: ErrorView(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(categoriesProvider),
                ),
              ),
              data: (categories) {
                // Filter by search query if active
                final filtered = _searchController.text.isEmpty
                    ? categories
                    : categories
                        .where((c) => c.name
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
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
                        onTap: () => context.go(
                          '${AppRoutes.recipeList}?category=${category.name}',
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

/// Shimmer placeholder card shown while categories are loading.
class _ShimmerCard extends StatelessWidget {
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
