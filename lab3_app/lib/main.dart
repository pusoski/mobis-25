import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/favorites_service.dart';
import 'services/notification_service.dart';
import 'services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAuth.instance.signInAnonymously();

  await NotificationService.init();

  final details = await flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails();

  String? launchPayload;
  if (details?.didNotificationLaunchApp ?? false) {
    launchPayload = details!.notificationResponse?.payload;
  }

  try {
    await FavoritesService.instance.loadFavorites();
  } catch (e) {
    print('Error loading favorites: $e');
  }

  runApp(MealApp(initialMealId: launchPayload));
}

class MealApp extends StatelessWidget {
  final String? initialMealId;
  const MealApp({super.key, this.initialMealId});

  @override
  Widget build(BuildContext context) {
    if (initialMealId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.navigateToMealDetail(initialMealId!);
      });
    }

    return MaterialApp(
      title: 'Meals App',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const CategoriesScreen(),
    );
  }
}
