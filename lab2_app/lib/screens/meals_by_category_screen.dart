import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_grid_tile.dart';
import 'meal_detail_screen.dart';
import 'package:logger/logger.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final _api = MealApiService();
  List<MealSummary> _meals = [];
  bool _loading = true;
  // ignore: unused_field
  String _query = '';
  // ignore: unused_field
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _searching = false;
      _query = '';
    });
    try {
      final meals = await _api.getMealsByCategory(widget.category);
      setState(() {
        _meals = meals;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        Logger().d('Error loading meals: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error loading meals')));
      }
    }
  }

  Future<void> _onSearch(String value) async {
    setState(() {
      _query = value;
      _searching = value.trim().isNotEmpty;
    });
    if (value.trim().isEmpty) {
      _load();
      return;
    }
    try {
      final results = await _api.searchMealsByName(
        value,
        restrictCategory: widget.category,
      );
      setState(() => _meals = results);
    } catch (e) {
      if (!mounted) return;
      Logger().d('Search failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Search failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SearchBar(
              hintText: 'Search in ${widget.category}...',
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
              child: _meals.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 160),
                        Center(
                          child: Text('No meals found in ${widget.category}.'),
                        ),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemCount: _meals.length,
                      itemBuilder: (context, i) {
                        final m = _meals[i];
                        return MealGridTile(
                          meal: m,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MealDetailScreen(mealId: m.id),
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
