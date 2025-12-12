import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/views/splash/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/helper_methods.dart';
import 'core/notification_helper.dart'; // Added import
import 'provider/theme_provider.dart';
import 'provider/settings_provider.dart';
import 'provider/bookmark_provider.dart';
import 'provider/plan_provider.dart';
import 'views/constant/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper().init(); // Initialize notifications
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool themeBool = prefs.getBool("isDark") ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(isDark: themeBool),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookmarkProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlanProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await readJson();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: ((context, value, child) {
        return MaterialApp(
          title: 'hafzon',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: value.getTheme,
          home: const SplashView(),
        );
      }),
    );
  }
}
