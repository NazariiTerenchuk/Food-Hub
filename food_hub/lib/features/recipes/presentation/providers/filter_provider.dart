import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Popular cuisine areas available as quick filters.
const List<String> popularAreas = [
  'American',
  'British',
  'Chinese',
  'French',
  'Indian',
  'Italian',
  'Japanese',
  'Mexican',
  'Thai',
  'Turkish',
];

/// Immutable filter state for the recipe list screen.
final class RecipeFilter {
  final String? selectedArea;

  const RecipeFilter({this.selectedArea});

  RecipeFilter copyWith({String? selectedArea}) =>
      RecipeFilter(selectedArea: selectedArea);

  RecipeFilter clearArea() => const RecipeFilter();

  bool get hasArea => selectedArea != null;
  bool get isEmpty => selectedArea == null;
}

/// Manages the active recipe filter on the list screen.
/// Cleared automatically when user navigates away from the list page.
class FilterNotifier extends Notifier<RecipeFilter> {
  @override
  RecipeFilter build() => const RecipeFilter();

  /// Select or deselect a cuisine area.
  /// Passing the currently selected area will deselect it (toggle).
  void toggleArea(String area) {
    state = state.selectedArea == area
        ? state.clearArea()
        : state.copyWith(selectedArea: area);
  }

  void clearAll() => state = const RecipeFilter();
}

final filterProvider =
    NotifierProvider<FilterNotifier, RecipeFilter>(FilterNotifier.new);
