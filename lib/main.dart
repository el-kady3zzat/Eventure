import 'package:eventure/core/utils/size/size_config.dart';

import 'package:eventure/features/events/presentation/blocs/book_btn/book_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/favorite_btn/favorite_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/save_btn/save_btn_bloc.dart';
import 'package:eventure/features/events/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:eventure/features/events/presentation/pages/details_page.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/firebase_options.dart';
import 'package:eventure/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:eventure/features/admin_Dashboard/testScreen.dart';

import 'package:eventure/features/splash/presentation/page/splash.dart';
import 'package:eventure/firebase_options.dart';
import 'package:eventure/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Creates an instance of FlutterLocalNotificationsPlugin to handle local notifications.
final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

// Handle Foreground Notifications
void setupFirebaseListeners() {
  void showNotification(RemoteMessage message, String channelId) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId, // Unique ID for the notification channel
      channelId, // Name for the notification channel
      importance: Importance.max, // Ensures the highest importance level
      priority: Priority.high, // Displays notification immediately
      icon: '@mipmap/launcher_icon', // Sets the notification small icon
    );

    // Applies Android-specific notification settings
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Displays the notification using flutter_local_notifications
    await flnp.show(
      0, // Unique notification ID (use different IDs for multiple notifications)
      message.notification?.title ?? '', // Notification title
      message.notification?.body ?? '', // Notification body
      notificationDetails, // Notification settings
    );
  }

  // Listens for FCM messages when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Default channel if no category is specified
    String channelId = 'eventure_general_channel';

    // Use data payload to decide the channel
    if (message.data.containsKey('channel')) {
      channelId = message.data['channel'];
    }

    showNotification(message, channelId);
  });

  // Detects when a user clicks a notification and opens the app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("User clicked on the notification");
  });
}

// Handle Background Notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Called when the app receives a message while in the background or terminated.
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  init();

  // Define multiple notification channels
  const AndroidNotificationChannel generalChannel = AndroidNotificationChannel(
    'eventure_general_channel', // Unique ID
    'General Notifications', // Channel Name
    description: 'Notifications for general updates.', // Channel description
    importance: Importance.high,
  );

  const AndroidNotificationChannel bookedEventsChannel =
      AndroidNotificationChannel(
    'eventure_booked_events_channel',
    'Booked Event Notifications',
    description: 'Notifications for booked upcoming events.',
    importance: Importance.high,
  );

  const AndroidNotificationChannel category1Channel =
      AndroidNotificationChannel(
    'eventure_category1_channel',
    'Offer Notifications',
    description: 'Notifications for special offers and promotions.',
    importance: Importance.high,
  );

  const AndroidNotificationChannel category2Channel =
      AndroidNotificationChannel(
    'eventure_category2_channel',
    'Offer Notifications',
    description: 'Notifications for special offers and promotions.',
    importance: Importance.high,
  );

  const AndroidNotificationChannel category3Channel =
      AndroidNotificationChannel(
    'eventure_category3_channel',
    'Offer Notifications',
    description: 'Notifications for special offers and promotions.',
    importance: Importance.high,
  );

  const AndroidNotificationChannel category4Channel =
      AndroidNotificationChannel(
    'eventure_category4_channel',
    'Offer Notifications',
    description: 'Notifications for special offers and promotions.',
    importance: Importance.high,
  );

  // Initialize Flutter Local Notificationss
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  // Initializes the local notifications plugin
  await flnp.initialize(initSettings);

  // Register notification channels
  final AndroidFlutterLocalNotificationsPlugin? androidFlnp =
      flnp.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidFlnp != null) {
    await androidFlnp.createNotificationChannel(generalChannel);
    await androidFlnp.createNotificationChannel(bookedEventsChannel);
    await androidFlnp.createNotificationChannel(category1Channel);
    await androidFlnp.createNotificationChannel(category2Channel);
    await androidFlnp.createNotificationChannel(category3Channel);
    await androidFlnp.createNotificationChannel(category4Channel);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
  if (kIsWeb) {
    runApp(AdminApp());
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Starts listening for notifications when the app runs
    setupFirebaseListeners();
    SizeConfig().init(context);

    return ScreenUtilInit(
      // designSize: const Size(390, 844),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        ),
        routes: {
          '/home': (context) => BlocProvider(
                create: (context) =>
                    getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
                child: HomePage(),
              ),
          '/details': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => getIt<FavoriteBtnBloc>()),
                  BlocProvider(create: (context) => getIt<SaveBtnBloc>()),
                  BlocProvider(create: (context) => getIt<BookBtnBloc>()),
                  BlocProvider(create: (context) => getIt<ScrollBloc>()),
                ],
                child: DetailsPage(),
              )
        },
      ),
    );
  }
}

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AdminDashboard(),
    );
  }
}
