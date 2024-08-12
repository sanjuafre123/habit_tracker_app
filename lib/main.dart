import 'package:flutter/material.dart';
import 'package:habit_tracker/provider/theme_provider.dart';
import 'package:habit_tracker/view/screen/home_page.dart';
import 'package:habit_tracker/view/screen/splash_page.dart';
import 'package:provider/provider.dart';

import 'DataBase/habit_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchData();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
