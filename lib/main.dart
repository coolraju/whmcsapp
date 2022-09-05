import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/login.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  runApp(const WhmcsSmarterAdmin());
}

class WhmcsSmarterAdmin extends StatelessWidget {
  const WhmcsSmarterAdmin({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whmcs Smarter Admin',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WhmcsSmarterHomePage(title: 'wSmarters App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WhmcsSmarterHomePage extends StatefulWidget {
  const WhmcsSmarterHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WhmcsSmarterHomePage> createState() => _WhmcsSmarterHomePageState();
}

class _WhmcsSmarterHomePageState extends State<WhmcsSmarterHomePage> {
  final LocalStorage storage = LocalStorage('whmcsadmin');
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  @override
  void dispose() {
    // DatabaseHelper.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Image.asset('assets/images/logo.png'));
  }
}
