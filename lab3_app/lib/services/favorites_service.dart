import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meal_summary.dart';
import 'package:flutter/foundation.dart';

class FavoritesService {
  FavoritesService._privateConstructor();
  static final FavoritesService instance =
      FavoritesService._privateConstructor();

  final _favorites = <MealSummary>[];
  final _firestore = FirebaseFirestore.instance;

  final _changeNotifier = ValueNotifier<int>(0);
  ValueListenable<int> get changeNotifier => _changeNotifier;

  List<MealSummary> get favorites => List.unmodifiable(_favorites);

  // Get UID (already signed in anonymously in main())
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> loadFavorites() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .get();

    _favorites.clear();
    for (var doc in snapshot.docs) {
      _favorites.add(
        MealSummary(id: doc['id'], name: doc['name'], thumb: doc['thumb']),
      );
    }
    _changeNotifier.value++;
  }

  Future<void> addFavorite(MealSummary meal) async {
    if (!_favorites.any((m) => m.id == meal.id)) {
      _favorites.add(meal);

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .doc(meal.id)
          .set({'id': meal.id, 'name': meal.name, 'thumb': meal.thumb});

      _changeNotifier.value++;
    }
  }

  Future<void> removeFavorite(String mealId) async {
    _favorites.removeWhere((m) => m.id == mealId);

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(mealId)
        .delete();

    _changeNotifier.value++;
  }

  bool isFavorite(String mealId) {
    return _favorites.any((m) => m.id == mealId);
  }
}
