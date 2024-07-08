import 'package:app_amic_dental_2024/router/app_routes.dart';
import 'package:app_amic_dental_2024/services/doc_upload/doc_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBQ9f8Ok8GL85QnAkRftWZ9mzHrh_9JJ4Q',
    appId: '1:643766654426:android:46eff2724bd0c325c55ce3',
    messagingSenderId: '643766654426',
    projectId: 'cloud-flutter-message',
    storageBucket: 'cloud-flutter-message.appspot.com',
  ));
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBQ9f8Ok8GL85QnAkRftWZ9mzHrh_9JJ4Q',
      appId: '1:643766654426:android:46eff2724bd0c325c55ce3',
      messagingSenderId: '643766654426',
      projectId: 'cloud-flutter-message',
      storageBucket: 'cloud-flutter-message.appspot.com',
    ),
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'test_channel_id',
        'Notificaciones prueba',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: 'item x');
    }
  });
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  // var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await loadConfig();
  await getFBToken();

  runApp(const MyApp());
}

Future<void> loadConfig() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 10.0
    ..progressColor = Colors.grey
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.grey
    ..maskColor = Colors.white.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future<void> getFBToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  print("FCM Token: $fcmToken");
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.
    print("New FCM Token: $fcmToken");
  }).onError((err) {
    print("Error getting FCM token: $err");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final themeMode = platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DocService())],
      child: MaterialApp(
        title: 'Amic Dental',
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.latoTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.light,
              seedColor: const Color.fromRGBO(16, 50, 114, 1)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color.fromRGBO(16, 50, 114, 1)),
          useMaterial3: true,
        ),
        themeMode: themeMode,
        initialRoute: AppRoutes.singin,
        routes: AppRoutes.getAppRoutes(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
