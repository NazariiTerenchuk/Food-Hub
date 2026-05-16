import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/add_recipe/presentation/pages/add_recipe_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
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

/// Routes that require the user to be logged in.
const _protectedPaths = {
  AppRoutes.addRecipe,
  AppRoutes.profile,
};

/// [ChangeNotifier] that bridges Riverpod auth state to GoRouter refresh.
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = _ref.read(isLoggedInProvider);
    final path = state.uri.path;
    final isAuthRoute = path == AppRoutes.login || path == AppRoutes.register;
    final isProtected = _protectedPaths.contains(path);

    if (!isLoggedIn && isProtected) return AppRoutes.login;
    if (isLoggedIn && isAuthRoute) return AppRoutes.home;
    return null;
  }
}

/// GoRouter as a Riverpod Provider so it can watch auth state.
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: notifier.redirect,

    routes: [
      // ── Auth routes (no shell) ────────────────────────────────────────
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

      // ── Main shell with bottom navigation ─────────────────────────────
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

      // ── Recipe routes (full-screen, no shell) ─────────────────────────
      GoRoute(
        path: AppRoutes.recipeList,
        name: 'recipeList',
        builder: (context, state) {
          final category =
              state.uri.queryParameters['category'] ?? '';
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
      body: Center(child: Text('404 — Page not found: ${state.uri}')),
    ),
  );
});
