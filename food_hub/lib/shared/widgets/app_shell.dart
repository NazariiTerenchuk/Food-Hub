import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../l10n/app_localizations.dart';

/// Application shell that wraps main tab pages with a bottom navigation bar.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const List<String> _routes = [
    AppRoutes.home,
    AppRoutes.favorites,
    AppRoutes.myRecipes,
    AppRoutes.profile,
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    // addRecipe lives inside myRecipes conceptually — highlight that tab
    if (location == AppRoutes.addRecipe) return 2;
    for (int i = 0; i < _routes.length; i++) {
      if (location == _routes[i] ||
          location.startsWith(_routes[i] == '/' ? '/home' : _routes[i])) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      floatingActionButton: selectedIndex == 2
          ? FloatingActionButton(
              heroTag: 'add_recipe_fab',
              onPressed: () => context.go(AppRoutes.addRecipe),
              tooltip: l10n.addRecipe,
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(_routes[index]);
        },
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: colorScheme.primary),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline_rounded),
            selectedIcon:
                Icon(Icons.favorite_rounded, color: colorScheme.primary),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon:
                Icon(Icons.menu_book_rounded, color: colorScheme.primary),
            label: l10n.myRecipes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon:
                Icon(Icons.person_rounded, color: colorScheme.primary),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
