import 'package:flutter/material.dart';
import 'package:whmcsadmin/pages/credential.dart';
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
      home: const WhmcsSmarterHomePage(title: 'Whmcs Smarter Admin'),
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
  String cred = null;
  @override
  void initState() {
    super.initState();
    getData();
    print(cred);
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const CredentialPage())));
  }

  @override
  void dispose() {
    // DatabaseHelper.instance.close();

    super.dispose();
  }

  getData() async {
    storage.ready.then((_) => cred = storage.getItem('whmcsadmin'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: Image.asset('assets/images/logo.png'));
  }
}
