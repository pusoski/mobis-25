import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'favorites_screen.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';
import 'package:logger/logger.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _api = MealApiService();
  List<Category> _all = [];
  List<Category> _filtered = [];
  bool _loading = true;
  // ignore: unused_field
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final cats = await _api.getCategories();
      setState(() {
        _all = cats;
        _filtered = cats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        Logger().d('Error loading categories: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading categories')),
        );
      }
    }
  }

  void _onSearch(String value) {
    setState(() {
      _query = value;
      _filtered = _all
          .where((c) => c.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> _openRandom() async {
    try {
      final meal = await _api.getRandomMeal();
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealId: meal.id, preload: meal),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Logger().d('Failed to load random meal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load random meal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  tooltip: 'Favorites',
                  color: Colors.deepOrange.shade600,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FavoritesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  color: Colors.deepOrange.shade600,
                  tooltip: 'Random Recipe',
                  icon: const Icon(Icons.shuffle),
                  onPressed: _openRandom,
                ),
              ],
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SearchBar(
              hintText: 'Search Categories...',
              onChanged: _onSearch,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12, right: 5),
                child: const Icon(Icons.search, size: 20),
              ),
            ),
          ),
        ),
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _filtered.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 160),
                        Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepOrange.shade200,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final c = _filtered[i];
                        return CategoryCard(
                          category: c,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    MealsByCategoryScreen(category: c.name),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
