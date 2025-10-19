import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

class NotificationService {
  // 🔔 Plugin utama untuk notifikasi lokal
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // 🧩 Logger instance biar keren
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 3,
      lineLength: 70,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTime,
    ),
  );

  // ✅ Inisialisasi notifikasi lokal
  static Future<void> init() async {
    // 1️⃣ Setup Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 2️⃣ Setup iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 3️⃣ Gabungkan
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    // 4️⃣ Inisialisasi plugin
    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
      _logger.i('📩 Notification clicked → payload: ${response.payload}');
    });

    // 🔥 Pastikan Firebase sudah siap
    await Firebase.initializeApp();
    _logger.i('🔥 Firebase initialized successfully.');

    // 5️⃣ Setup background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 6️⃣ Minta izin notifikasi (terutama iOS)
    await FirebaseMessaging.instance.requestPermission();
    _logger.i('🔔 Notification permission granted.');

    // 7️⃣ Dapatkan token FCM
    final token = await FirebaseMessaging.instance.getToken();
    _logger.w('🔑 FCM Token: $token');

    // 8️⃣ Listener ketika pesan diterima saat app dibuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('💌 Message received in foreground: ${message.notification?.title}');
      _showNotification(message);
    });

    // 9️⃣ Listener ketika notifikasi diklik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('🚀 Notification opened → ${message.notification?.title}');
      // TODO: Navigasi ke halaman tertentu kalau perlu
    });
  }

  // 🎯 Menampilkan notifikasi lokal
  static Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;

    if (notification != null) {
      _logger.d('🔧 Showing local notification → ${notification.title}');
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            channelDescription: 'Notifikasi umum aplikasi.',
            importance: Importance.max,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // 🌙 Handler pesan saat app di background
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    _logger.w('🌙 Background message received: ${message.messageId}');
  }
}
