import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/meal_api_service.dart';
import '../models/meal_detail.dart';
import 'package:logger/logger.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? preload;
  const MealDetailScreen({super.key, required this.mealId, this.preload});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _api = MealApiService();
  MealDetail? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.preload != null) {
      _meal = widget.preload;
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final meal = await _api.getMealDetail(widget.mealId);
      setState(() {
        _meal = meal;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        Logger().d('Error loading recipe: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error loading recipe')));
      }
    }
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open YouTube')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = _meal;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _loading || meal == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${meal.category} · ${meal.area}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepOrange.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment
                        .bottomRight, // Position content in bottom right
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(meal.thumb, fit: BoxFit.cover),
                        ),
                      ),
                      if (meal.youtube != null && meal.youtube!.isNotEmpty)
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: FilledButton.icon(
                            onPressed: () => _openYoutube(meal.youtube!),
                            icon: Icon(
                              Icons.ondemand_video,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Watch on YouTube',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.deepOrange.shade900,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        color: Colors.deepOrange.shade300,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...meal.ingredients.map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• ${ing.name} (${ing.measure})',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange.shade100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.assignment,
                        color: Colors.deepOrange.shade300,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.instructions,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange.shade100,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
