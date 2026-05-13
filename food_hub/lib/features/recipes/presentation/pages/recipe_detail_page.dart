import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final String mealId;

  const RecipeDetailPage({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Recipe Detail: $mealId — Coming Soon')),
    );
  }
}
