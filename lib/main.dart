import 'package:chat_app/core/routes/chat_app_routes.dart';
import 'package:chat_app/core/themes/theme_provider.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/services/chat/auth_services.dart';
import 'package:chat_app/views/auth_folder/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart' show kDebugMode;
// import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // if (kDebugMode) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  //   await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  //   FirebaseDatabase.instance.useDatabaseEmulator('10.0.2.2', 9000);
  // }
  // if (kDebugMode) {
  //   const emulatorHost = '192.168.0.112'; // your laptop's IP
  //   FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
  //   await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
  //   FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, 9000);
  // }
  await AuthServices().sessionExpiration();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  try {
    String? token = await messaging.getToken();
    // print("FCM TOKEN: $token");
  } catch (e) {
    print("Failed to get FCM token: $e");
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // push notification initialization

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        onGenerateRoute: ChatAppRoutes.generateRoute,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}
