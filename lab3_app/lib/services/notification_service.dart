import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import '../services/navigation_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            NavigationService.navigateToMealDetail(payload);
          });
        }
      },
    );

    await FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final recipeId = message.data['idMeal'];
      if (recipeId != null && recipeId.isNotEmpty) {
        NavigationService.navigateToMealDetail(recipeId);
      }
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final recipeId = initialMessage.data['idMeal'];
      if (recipeId != null && recipeId.isNotEmpty) {
        NavigationService.navigateToMealDetail(recipeId);
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _showLocalNotification(message);
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final String title = notification?.title ?? data['title'] ?? 'Recipe';
    final String body =
        notification?.body ?? data['body'] ?? 'Check out your recipe!';
    final String payload = data['idMeal'] ?? '';

    final AndroidNotificationDetails
    androidDetails = AndroidNotificationDetails(
      'recipe_channel',
      'Recipe Notifications',
      channelDescription: 'Channel for daily recipe notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(body),
      // largeIcon: data['image'] != null ? FilePathAndroidBitmap(data['image']) : null,
    );

    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }
}