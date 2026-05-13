import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  final String categoryName;

  const RecipeListPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: const Center(child: Text('Recipe List — Coming Soon')),
    );
  }
}
