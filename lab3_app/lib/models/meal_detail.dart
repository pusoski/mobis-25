class Ingredient {
  final String name;
  final String measure;

  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String thumb;
  final String category;
  final String area;
  final String instructions;
  final String? youtube;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumb,
    required this.category,
    required this.area,
    required this.instructions,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final ing = (json['strIngredient$i'] as String?)?.trim();
      final meas = (json['strMeasure$i'] as String?)?.trim();
      if (ing != null && ing.isNotEmpty) {
        ingredients.add(Ingredient(name: ing, measure: meas ?? ''));
      }
    }
    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumb: json['strMealThumb'] as String,
      category: (json['strCategory'] as String?) ?? '',
      area: (json['strArea'] as String?) ?? '',
      instructions: (json['strInstructions'] as String?) ?? '',
      youtube: (json['strYoutube'] as String?)?.isNotEmpty == true ? json['strYoutube'] as String : null,
      ingredients: ingredients,
    );
  }
}
