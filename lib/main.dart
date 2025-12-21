import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ✅ Import provider
import 'package:flutter_5a/core/providers/onboarding_provider.dart';
import 'package:flutter_5a/core/providers/auth_provider.dart';
import 'package:flutter_5a/core/providers/user_provider.dart';
import 'package:flutter_5a/core/providers/tips_provider.dart';
import 'package:flutter_5a/core/providers/report_provider.dart';
import 'package:flutter_5a/core/providers/chat_provider.dart';

// ✅ Import view
import 'package:flutter_5a/views/onboarding_view.dart';
import 'package:flutter_5a/views/login.dart';
import 'package:flutter_5a/views/splash_screen.dart';

// ✅ Firebase dan Notifikasi
import 'package:flutter_5a/firebase_options.dart';
import 'package:flutter_5a/core/services/notification_service.dart';

// 🔹 Background handler wajib static dan global (Top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // PENTING: Harus inisialisasi Firebase lagi di sini
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 Handling background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1️⃣ Load file .env lebih awal (sebelum Firebase)
  await dotenv.load(fileName: ".env");

  // (Opsional) Tes apakah .env sudah terbaca
  print("🌍 ENV Loaded: ${dotenv.env['CLOUDINARY_CLOUD_NAME']}");

  // ✅ 2️⃣ Set handler background message (wajib sebelum runApp)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ 3️⃣ Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ 4️⃣ Inisialisasi Local Notification & FCM
  await NotificationService.initLocalNotifications(); // Notifikasi lokal
  await NotificationService.initFCM(); // Listener FCM

  // ✅ 5️⃣ Jadwalkan notifikasi harian pukul 08:00
  await NotificationService.scheduleDailyTip();

  // ✅ 6️⃣ Jalankan App dengan MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TipsProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 5A',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 247, 247, 247),
        ),
        fontFamily: "Poppins",
      ),
      home: const SplashScreen(),         //ubah dengan spalsh nanti dan kasi const
      routes: {
        '/onboarding': (_) => const OnboardingView(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
