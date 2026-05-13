import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_recipe/presentation/pages/add_recipe_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../../features/recipes/presentation/pages/recipe_list_page.dart';
import '../../shared/widgets/app_shell.dart';

/// Route name constants to avoid hardcoded strings.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/';
  static const String recipeList = '/recipes';
  static const String recipeDetail = '/recipes/detail';
  static const String favorites = '/favorites';
  static const String addRecipe = '/add-recipe';
  static const String profile = '/profile';
}

/// GoRouter configuration for FoodHub.
/// Uses shell route for bottom navigation and redirect for auth guard.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,

  // TODO(auth): Replace with real auth state from Riverpod in Commit 17
  redirect: (BuildContext context, GoRouterState state) {
    // Placeholder: no redirect until Firebase Auth is integrated
    return null;
  },

  routes: [
    // ── Auth routes (no shell) ──────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

    // ── Main shell with bottom navigation ──────────────────────────────
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.favorites,
          name: 'favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: AppRoutes.addRecipe,
          name: 'addRecipe',
          builder: (context, state) => const AddRecipePage(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),

    // ── Recipe routes (no shell — full-screen) ─────────────────────────
    GoRoute(
      path: AppRoutes.recipeList,
      name: 'recipeList',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'] ?? '';
        return RecipeListPage(categoryName: category);
      },
    ),
    GoRoute(
      path: AppRoutes.recipeDetail,
      name: 'recipeDetail',
      builder: (context, state) {
        final mealId = state.uri.queryParameters['id'] ?? '';
        return RecipeDetailPage(mealId: mealId);
      },
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('404 — Page not found: ${state.uri}'),
    ),
  ),
);
