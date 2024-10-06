import 'package:flutter/material.dart';
import 'package:multiuser_habits/pages/habits_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:multiuser_habits/firebase_options.dart';
import 'package:multiuser_habits/services/habits_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HabitsProvider(),
        ),
      ],
      child: MaterialApp(
        home: HabitsPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
            brightness: Brightness.dark,
          ),
        ),
      ),
    );
  }
}
