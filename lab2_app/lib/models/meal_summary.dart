class MealSummary {
  final String id;
  final String name;
  final String thumb;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) => MealSummary(
        id: json['idMeal'] as String,
        name: json['strMeal'] as String,
        thumb: json['strMealThumb'] as String,
      );
}
