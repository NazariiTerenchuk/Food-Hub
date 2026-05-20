import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/custom_recipe_model.dart';
import '../providers/add_recipe_provider.dart';

/// Edit an existing custom recipe — provides the Update in CRUD.
class EditRecipePage extends ConsumerStatefulWidget {
  final CustomRecipeModel recipe;
  const EditRecipePage({super.key, required this.recipe});

  @override
  ConsumerState<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends ConsumerState<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final List<TextEditingController> _ingredients;
  late final List<TextEditingController> _steps;
  File? _newPhoto;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.recipe.name);
    _descCtrl = TextEditingController(text: widget.recipe.description);
    _ingredients = widget.recipe.ingredients
        .map((s) => TextEditingController(text: s))
        .toList();
    _steps = widget.recipe.steps
        .map((s) => TextEditingController(text: s))
        .toList();
    if (_ingredients.isEmpty) _ingredients.add(TextEditingController());
    if (_steps.isEmpty) _steps.add(TextEditingController());
  }

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
      imageQuality: 50,
      maxWidth: 600,
      maxHeight: 600,
    );
    if (picked != null) setState(() => _newPhoto = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    setState(() => _loading = true);

    final ingredients = _ingredients
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _steps
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    String? photoBase64;
    if (_newPhoto != null) {
      final bytes = await _newPhoto!.readAsBytes();
      photoBase64 = base64Encode(bytes);
    }

    try {
      await ref.read(addRecipeRepositoryProvider).updateRecipe(
            uid: uid,
            id: widget.recipe.id,
            name: _nameCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            ingredients: ingredients,
            steps: steps,
            photoBase64: photoBase64,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.recipeSaved)),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

  void _showPhotoOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: Text(l10n.takePhoto),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded),
            title: Text(l10n.chooseFromGallery),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Determine what image to show
    Widget photoWidget;
    if (_newPhoto != null) {
      photoWidget = Image.file(_newPhoto!, fit: BoxFit.cover);
    } else if (widget.recipe.photoBase64 != null) {
      photoWidget = Image.memory(
        base64Decode(widget.recipe.photoBase64!),
        fit: BoxFit.cover,
      );
    } else {
      photoWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined,
              size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(l10n.addPhoto,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.primary)),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editRecipe),
        actions: [
          TextButton(
            onPressed: _loading ? null : _submit,
            child: _loading
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
            // ── Photo picker ──────────────────────────────────────────
            GestureDetector(
              onTap: _showPhotoOptions,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                clipBehavior: Clip.hardEdge,
                child: photoWidget,
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
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  final String addText;
  const _SectionHeader(
      {required this.title, required this.onAdd, required this.addText});

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
