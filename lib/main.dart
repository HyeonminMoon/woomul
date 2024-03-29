import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:woomul/provider/auth_service.dart';
import 'package:woomul/provider/board_service.dart';
import 'package:woomul/provider/comment_service.dart';
import 'package:woomul/provider/fcm_service.dart';
import 'package:woomul/provider/like_service.dart';
import 'package:woomul/ui/auth/login_home_page.dart';
import 'package:woomul/ui/board/bottombar_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:woomul/ui/splash_sreen.dart';

// 스몰아이즈 //
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
// 스몰아이즈 //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 스몰아이즈 //

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initFirebaseMessage();

  // 스몰아이즈 //

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => BoardService()),
        ChangeNotifierProvider(create: (context) => UserData()),
        ChangeNotifierProvider(create: (context) => MbtiService()),
        ChangeNotifierProvider(create: (context) => CommentService()),
        ChangeNotifierProvider(create: (context) => LikeService()),
        ChangeNotifierProvider(create: (context) => FcmService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: splashScreen()//LoginScreen()
    );
  }
}

Future<void> initFirebaseMessage() async {
  var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}
