import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/favorites_service.dart';
import 'dart:ui';

class MealGridTile extends StatefulWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealGridTile({super.key, required this.meal, required this.onTap});

  @override
  State<MealGridTile> createState() => _MealGridTileState();
}

class _MealGridTileState extends State<MealGridTile> {
  bool get isFavorite => FavoritesService.instance.isFavorite(widget.meal.id);

  @override
  void initState() {
    super.initState();
    FavoritesService.instance.changeNotifier.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    FavoritesService.instance.changeNotifier.removeListener(
      _onFavoritesChanged,
    );
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.instance.removeFavorite(widget.meal.id);
    } else {
      await FavoritesService.instance.addFavorite(widget.meal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(widget.meal.thumb, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.meal.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.deepOrange.shade100,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
