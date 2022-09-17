import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, 'login');
      } else {
        Navigator.pushNamed(context, 'home');
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          Text('Estamos preparando todo...')
        ],
      ),
    );
  }
}
