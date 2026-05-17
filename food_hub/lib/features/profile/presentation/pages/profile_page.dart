import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Extract first letter for avatar
    final initial = user?.email?.isNotEmpty == true
        ? user!.email![0].toUpperCase()
        : '?';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Avatar & Info ──────────────────────────────────────────────────
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                initial,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? l10n.notLoggedIn,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),

          // ── Settings ───────────────────────────────────────────────────────
          Text(
            l10n.settings,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                // Theme Toggle
                SwitchListTile(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (val) => ref.read(themeProvider.notifier).setMode(
                        val ? ThemeMode.dark : ThemeMode.light,
                      ),
                  title: Text(l10n.darkMode),
                  secondary: const Icon(Icons.dark_mode_outlined),
                ),
                const Divider(height: 1, indent: 56),

                // Language Dropdown
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.language),
                  trailing: DropdownButton<String>(
                    value: locale.languageCode,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'uk', child: Text('Українська')),
                      DropdownMenuItem(value: 'pl', child: Text('Polski')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(languageProvider.notifier)
                            .setLocale(Locale(val));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Logout ─────────────────────────────────────────────────────────
          FilledButton.icon(
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
            icon: const Icon(Icons.logout_rounded),
            label: Text(l10n.signOut),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
