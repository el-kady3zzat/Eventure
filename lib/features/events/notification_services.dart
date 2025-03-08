import 'package:eventure/features/events/data/datasources/event_datasource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:eventure/injection.dart';
import 'package:eventure/features/events/presentation/blocs/notifications/notifications_bloc.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission();

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(initializationSettings);

    // Get token and register
    await _registerFcmToken();

    // Set up foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _handleMessage(message);
    });
  }

  static Future<void> _registerFcmToken() async {
    getIt<FirebaseMessaging>().onTokenRefresh.listen((newToken) {
      getIt<EventDatasource>().registerFcmToken();
    });
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    final settingsBloc = getIt<NotificationsBloc>();
    final currentState = settingsBloc.state;

    if (currentState is NotificationSettingsLoaded) {
      final settings = currentState.notificationSettings;
      final String? channelId = message.data['channel_id'];

      if (channelId != null && settings[channelId] == true) {
        _showNotification(message);
      }
    }
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    // Prevents crashes
    if (message.notification == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'eventure_channel',
      'Eventure Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await _localNotificationsPlugin.show(
      message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'Tap to view details',
      notificationDetails,
    );
  }
}
