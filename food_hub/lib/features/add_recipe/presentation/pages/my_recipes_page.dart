import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/custom_recipe_model.dart';
import '../providers/add_recipe_provider.dart';
import 'edit_recipe_page.dart';

/// Displays all custom recipes created by the signed-in user.
/// Supports real-time updates (StreamProvider) and full CRUD via swipe/buttons.
class MyRecipesPage extends ConsumerWidget {
  const MyRecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final theme = Theme.of(context);

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.myRecipes)),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock_outline_rounded, size: 56),
            const SizedBox(height: 16),
            Text(l10n.signInToAddRecipes),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/login'),
              child: Text(l10n.signIn),
            ),
          ]),
        ),
      );
    }

    final recipesAsync = ref.watch(myRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myRecipes),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: l10n.addRecipe,
            onPressed: () => context.go('/add-recipe'),
          ),
        ],
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant_menu_rounded,
                      size: 80,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(l10n.noMyRecipesYet,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(l10n.noMyRecipesDesc,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.go('/add-recipe'),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.addRecipe),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: recipes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _RecipeCard(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}

class _RecipeCard extends ConsumerWidget {
  final CustomRecipeModel recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dismissible(
      key: Key(recipe.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_rounded, color: theme.colorScheme.onError),
      ),
      confirmDismiss: (dir) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.deleteRecipe),
            content: Text(l10n.deleteRecipeConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        final uid = ref.read(currentUserProvider)?.uid;
        if (uid != null) {
          ref
              .read(addRecipeRepositoryProvider)
              .deleteRecipe(uid, recipe.id);
        }
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: recipe.photoBase64 != null
                ? Image.memory(
                    base64Decode(recipe.photoBase64!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.restaurant_rounded,
                        color: theme.colorScheme.primary),
                  ),
          ),
          title: Text(recipe.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(
            recipe.description.isEmpty
                ? '${recipe.ingredients.length} ingredients • ${recipe.steps.length} steps'
                : recipe.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'edit') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EditRecipePage(recipe: recipe),
                ));
              } else if (val == 'delete') {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.deleteRecipe),
                    content: Text(l10n.deleteRecipeConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                ).then((confirmed) {
                  if (confirmed == true) {
                    final uid = ref.read(currentUserProvider)?.uid;
                    if (uid != null) {
                      ref
                          .read(addRecipeRepositoryProvider)
                          .deleteRecipe(uid, recipe.id);
                    }
                  }
                });
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.delete,
                    style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
