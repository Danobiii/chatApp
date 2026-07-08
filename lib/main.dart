import 'package:chat_app/core/routes/chat_app_routes.dart';
import 'package:chat_app/core/themes/theme_provider.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/views/auth_folder/auth_services.dart';
import 'package:chat_app/views/auth_folder/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthServices().sessionExpiration();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
