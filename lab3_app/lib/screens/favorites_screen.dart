import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_grid_tile.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: FavoritesService.instance.changeNotifier,
        builder: (context, _, __) {
          final favorites = FavoritesService.instance.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange.shade200,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final meal = favorites[i];
              return MealGridTile(
                meal: meal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(mealId: meal.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
