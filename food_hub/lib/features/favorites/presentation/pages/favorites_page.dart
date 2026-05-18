import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/string_translator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/empty_view.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/favorite_meal_model.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    if (!isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border_rounded, size: 80),
              const SizedBox(height: 16),
              Text(l10n.signInToSeeFavorites),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(l10n.signIn),
              ),
            ],
          ),
        ),
      );
    }

    final favAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        centerTitle: false,
      ),
      body: favAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (favs) {
          if (favs.isEmpty) {
            return EmptyView(
              icon: Icons.favorite_border_rounded,
              title: l10n.noFavoritesYet,
              subtitle: l10n.noFavoritesDesc,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) => _FavTile(fav: favs[i]),
          );
        },
      ),
    );
  }
}

class _FavTile extends ConsumerWidget {
  final FavoriteMealModel fav;
  const _FavTile({required this.fav});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Hero(
          tag: 'meal_${fav.mealId}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              fav.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(fav.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(fav.category.translateDynamic(context),
            style: TextStyle(
                color: theme.colorScheme.primary, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_rounded, color: Colors.red),
          onPressed: () async {
            final uid = ref.read(currentUserProvider)?.uid;
            if (uid == null) return;
            await ref
                .read(favoritesRepositoryProvider)
                .removeFavorite(uid, fav.mealId);
          },
        ),
        onTap: () => context.push(
          '${AppRoutes.recipeDetail}?id=${fav.mealId}',
        ),
      ),
    );
  }
}
