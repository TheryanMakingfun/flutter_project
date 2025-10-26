import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ untuk deteksi web
import 'dart:io' show Platform; // ✅ aman digunakan jika bukan web

// 🎯 ID unik untuk notifikasi tips harian
const int dailyTipNotificationId = 1001;
// 🎯 ID Channel Android yang konsisten
const String dailyTipChannelId = 'tips_harian_channel';

class NotificationService {
  // 🔔 Plugin utama untuk notifikasi lokal
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // 🧩 Logger instance
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
  static Future<void> initLocalNotifications() async {
    if (kIsWeb) {
      _logger.w('⚠️ Local notifications are not supported on Web.');
      return;
    }

    // 1️⃣ Setup Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
    _logger.i('Timezone set to: ${tz.local.name}');

    // 2️⃣ Setup Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 3️⃣ Setup iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 4️⃣ Setup Windows (jika bukan web)
    const WindowsInitializationSettings windowsSettings = WindowsInitializationSettings(
      appName: 'flutter_5a',
      appUserModelId: 'com.app.flutter_5a',
      guid: 'C00105F3-F326-4CC2-A8D7-E9CE3469BCE3',
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
      _logger.i('📩 Local Notification clicked → payload: ${response.payload}');
    });

    // 5️⃣ Minta izin untuk iOS
    final bool? granted = await _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    _logger.i('✅ Local notifications initialized. Granted (iOS): $granted');
  }

  // 🔥 Inisialisasi dan Listener Firebase Messaging
  static Future<void> initFCM() async {
    if (kIsWeb) {
      _logger.w('⚠️ FCM notifications are not fully supported on Web. Skipping setup.');
      return;
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _logger.w('[FCM] Dilewati di platform Desktop.');
      return;
    }

    // 1️⃣ Minta izin notifikasi
    await FirebaseMessaging.instance.requestPermission();
    _logger.i('🔔 FCM permission granted.');

    // 2️⃣ Dapatkan token FCM
    final token = await FirebaseMessaging.instance.getToken();
    _logger.w('🔑 FCM Token: $token');

    // 3️⃣ Listener pesan foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('💌 FCM Message received in foreground: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // 4️⃣ Listener saat notifikasi diklik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('🚀 FCM Notification opened → ${message.notification?.title}');
    });
  }

  // 🎯 Menampilkan notifikasi lokal (untuk pesan FCM di foreground)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    if (kIsWeb) return; // ✅ skip di web

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;

    if (notification != null) {
      _logger.d('🔧 Showing local notification for FCM → ${notification.title}');
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            dailyTipChannelId,
            'Tips Harian Channel',
            channelDescription: 'Notifikasi untuk tips harian.',
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

  // 🗓️ Jadwalkan notifikasi harian jam 08:00
  static Future<void> scheduleDailyTip() async {
    if (kIsWeb) {
      _logger.w('⚠️ Scheduled notifications are not supported on Web.');
      return;
    }

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      dailyTipChannelId,
      'Tips Harian',
      channelDescription: 'Notifikasi Tips Harian Pagi',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.zonedSchedule(
      dailyTipNotificationId,
      'Tips Harian',
      'Tips untuk memulai hari mu.',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, 
      matchDateTimeComponents: DateTimeComponents.time,
    );

    _logger.i('🗓️ Daily tip scheduled for ${scheduledDate.hour}:${scheduledDate.minute} (${scheduledDate.timeZoneName}). Next: ${scheduledDate.day}/${scheduledDate.month}');
  }

  // ❌ Batalkan semua notifikasi terjadwal
  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _localNotifications.cancelAll();
    _logger.w('🗑️ All notifications cancelled.');
  }
}
