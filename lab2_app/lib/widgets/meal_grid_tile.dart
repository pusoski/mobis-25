import 'package:flutter/material.dart';
import '../models/meal_summary.dart';

class MealGridTile extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;

  const MealGridTile({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.network(meal.thumb, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                meal.name,
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
      ),
    );
  }
}
