import 'package:flutter/material.dart';
import '../screens/meal_detail_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateToMealDetail(String idMeal) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: idMeal)),
    );
  }
}
