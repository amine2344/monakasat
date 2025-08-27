import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mounakassat_dz/firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:firebase_core/firebase_core.dart';
import 'package:mounakassat_dz/app/routes/app_pages.dart';
import 'app/controllers/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/services/firebase_service.dart';
import 'storage/notification.storage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  final userId = FirebaseService().auth.currentUser?.uid;
  if (userId != null) {
    await NotificationStorage().saveNotification(userId, {
      'id':
          message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'receivedAt': DateTime.now().toIso8601String(),
      'read': false,
      'data': message.data,
    });
  }
}

AndroidNotificationChannel? channel;
bool isFlutterLocalNotificationsInitialized = false;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  if (!kIsWeb) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin?.initialize(initializationSettings);

      final androidPlugin = flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      channel != null
          ? await androidPlugin?.createNotificationChannel(channel!)
          : null;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS,
      );
      await flutterLocalNotificationsPlugin?.initialize(initializationSettings);
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    isFlutterLocalNotificationsInitialized = true;
    debugPrint('Flutter notifications initialized for $defaultTargetPlatform');
  }
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  if (notification != null && !kIsWeb) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin?.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel?.id ?? "safakati_id",
              channel?.name ?? "safakati",
              channelDescription: channel?.description,
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      flutterLocalNotificationsPlugin?.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
    debugPrint(
      'Notification shown: ${notification.title} - ${notification.body}',
    );
  } else {
    debugPrint('Notification not shown: ${message.data}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setAutoInitEnabled(false);
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  Get.put(FirebaseService());
  debugPrint('FirebaseService initialized in main');

  final themeController = ThemeController();
  Get.put(themeController);
  await themeController.loadThemePreference();
  await themeController.loadLocalePreference();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('fr'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      useOnlyLangCode: true,
      startLocale: await _getSavedLocale(),
      child: MounakassatApp(themeController: themeController),
    ),
  );
}

Future<Locale> _getSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code') ?? 'ar';
  return Locale(languageCode);
}

class MounakassatApp extends StatelessWidget {
  final ThemeController themeController;

  const MounakassatApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return Obx(
          () => GetMaterialApp(
            title: 'app_title'.tr(),
            debugShowCheckedModeBanner: false,
            theme: themeController.theme,
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            builder: (context, child) {
              return Directionality(
                textDirection: themeController.textDirection.value,
                child: child ?? Container(),
              );
            },
          ),
        );
      },
    );
  }
}
