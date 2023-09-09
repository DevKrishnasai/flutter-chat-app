import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/pages/intro_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final client = FireBaseClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: client.auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const IntroPage();
            }
          }),
    );
  }
}
