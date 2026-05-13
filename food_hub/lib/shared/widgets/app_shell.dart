import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

/// Application shell that wraps main tab pages with a bottom navigation bar.
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const List<_NavItem> _navItems = [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      route: AppRoutes.home,
    ),
    _NavItem(
      label: 'Favorites',
      icon: Icons.favorite_outline_rounded,
      selectedIcon: Icons.favorite_rounded,
      route: AppRoutes.favorites,
    ),
    _NavItem(
      label: 'Add',
      icon: Icons.add_circle_outline_rounded,
      selectedIcon: Icons.add_circle_rounded,
      route: AppRoutes.addRecipe,
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      route: AppRoutes.profile,
    ),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _navItems.length; i++) {
      if (location == _navItems[i].route ||
          location.startsWith(_navItems[i].route == '/' ? '/home' : _navItems[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          context.go(_navItems[index].route);
        },
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        destinations: _navItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon, color: colorScheme.primary),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}
