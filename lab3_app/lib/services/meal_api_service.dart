import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class MealApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse('$_base/categories.php'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['categories'] as List<dynamic>? ?? []);
    return list
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MealSummary>> getMealsByCategory(String category) async {
    final uri = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php',
    ).replace(queryParameters: {'c': category});
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load meals for $category');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List?) ?? [];
    return list
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MealSummary>> searchMealsByName(
    String query, {
    String? restrictCategory,
  }) async {
    final uri = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php',
    ).replace(queryParameters: {'s': query});
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Search failed');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List?) ?? [];
    final summaries = list
        .map((e) {
          final m = e as Map<String, dynamic>;
          return {
            'idMeal': m['idMeal'],
            'strMeal': m['strMeal'],
            'strMealThumb': m['strMealThumb'],
            'strCategory': m['strCategory'],
          };
        })
        .where((m) {
          if (restrictCategory == null || restrictCategory.isEmpty) return true;
          return (m['strCategory'] as String?) == restrictCategory;
        })
        .map((m) => MealSummary.fromJson(m))
        .toList();
    return summaries;
  }

  Future<MealDetail> getMealDetail(String id) async {
    final res = await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load meal $id');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List<dynamic>? ?? []);
    if (list.isEmpty) {
      throw Exception('Meal not found');
    }
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }

  Future<MealDetail> getRandomMeal() async {
    final res = await http.get(Uri.parse('$_base/random.php'));
    if (res.statusCode != 200) {
      throw Exception('Failed to load random meal');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final list = (data['meals'] as List<dynamic>? ?? []);
    if (list.isEmpty) {
      throw Exception('Random meal not found');
    }
    return MealDetail.fromJson(list.first as Map<String, dynamic>);
  }
}
