import 'package:app_pizzeria/app/auth/auth_page.dart';
import 'package:app_pizzeria/app/auth/check_out_page.dart';
import 'package:app_pizzeria/app/home/home_page.dart';
import 'package:app_pizzeria/app/point/create_point_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//final FirebaseAuth _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'checkout',
      routes: {
        'checkout': ((context) => const CheckOutPage()),
        'login': ((context) => const AuthPage()),
        'home': ((context) => const HomePage()),
        'create_point': ((context) => const CreatePointScreen()),
      },
    );
  }
}
