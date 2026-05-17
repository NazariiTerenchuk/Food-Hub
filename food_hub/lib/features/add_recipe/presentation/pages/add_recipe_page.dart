import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/add_recipe_provider.dart';

class AddRecipePage extends ConsumerStatefulWidget {
  const AddRecipePage({super.key});
  @override
  ConsumerState<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends ConsumerState<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<TextEditingController> _ingredients = [TextEditingController()];
  final List<TextEditingController> _steps = [TextEditingController()];
  File? _photo;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    for (final c in [..._ingredients, ..._steps]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50, // Heavily compressed to fit in 1MB Firestore doc
      maxWidth: 600,
      maxHeight: 600,
    );
    if (picked != null) setState(() => _photo = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ingredients = _ingredients
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _steps
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    await ref.read(addRecipeProvider.notifier).submit(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          ingredients: ingredients,
          steps: steps,
          photo: _photo,
        );
  }

  void _addField(List<TextEditingController> list) =>
      setState(() => list.add(TextEditingController()));

  void _removeField(List<TextEditingController> list, int i) {
    if (list.length <= 1) return;
    setState(() {
      list[i].dispose();
      list.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final state = ref.watch(addRecipeProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(addRecipeProvider, (_, next) {
      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.recipeSaved)));
        context.pop();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    if (!isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.addRecipe)),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addRecipe),
        actions: [
          TextButton(
            onPressed: state.loading ? null : _submit,
            child: state.loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Photo picker ─────────────────────────────────────────
            GestureDetector(
              onTap: () => _showPhotoOptions(),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.surfaceContainerHighest,
                  image: _photo != null
                      ? DecorationImage(
                          image: FileImage(_photo!), fit: BoxFit.cover)
                      : null,
                ),
                child: _photo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 48,
                              color: theme.colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(l10n.addPhoto,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary)),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // ── Name ─────────────────────────────────────────────────
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                  labelText: l10n.recipeName,
                  prefixIcon: const Icon(Icons.restaurant_rounded)),
              validator: (v) => (v == null || v.trim().length < 3)
                  ? 'Name must be at least 3 characters'
                  : null,
            ),
            const SizedBox(height: 16),

            // ── Description ──────────────────────────────────────────
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: l10n.description,
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.description_outlined)),
            ),
            const SizedBox(height: 24),

            // ── Ingredients ──────────────────────────────────────────
            _SectionHeader(
                title: l10n.ingredients,
                onAdd: () => _addField(_ingredients),
                addText: l10n.add),
            ..._ingredients.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: e.value,
                        decoration: InputDecoration(
                            hintText: 'Ingredient ${e.key + 1}'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removeField(_ingredients, e.key),
                    ),
                  ]),
                )),
            const SizedBox(height: 24),

            // ── Steps ────────────────────────────────────────────────
            _SectionHeader(
                title: l10n.instructions, 
                onAdd: () => _addField(_steps),
                addText: l10n.add),
            ..._steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14, right: 8),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              theme.colorScheme.primaryContainer,
                          child: Text('${e.key + 1}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: e.value,
                          maxLines: 2,
                          decoration:
                              InputDecoration(hintText: 'Step ${e.key + 1}'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeField(_steps, e.key),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: Text(AppLocalizations.of(context)!.takePhoto),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded),
            title: Text(AppLocalizations.of(context)!.chooseFromGallery),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  final String addText;
  const _SectionHeader({required this.title, required this.onAdd, required this.addText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: Text(addText),
        ),
      ]),
    );
  }
}
