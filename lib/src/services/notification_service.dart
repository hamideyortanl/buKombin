import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(
      settings: initSettings,
    );

    await _createChannels();
  }

  Future<void> _createChannels() async {
    const channel = AndroidNotificationChannel(
      'care_channel',
      'Bakım Önerileri',
      description: 'Kıyafet bakım ve yıkama önerileri',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    const android = AndroidNotificationDetails(
      'care_channel',
      'Bakım Önerileri',
      channelDescription: 'Kıyafet bakım ve yıkama önerileri',
      importance: Importance.max,
      priority: Priority.high,
    );

    const ios = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: android,
      iOS: ios,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}