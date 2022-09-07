import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:whmcsadmin/pages/dashboard.dart';
import 'package:whmcsadmin/pages/report.dart';
import 'package:whmcsadmin/pages/credential.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  late String credential;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  // bool? _canCheckBiometrics;
  // List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  final LocalStorage storage = LocalStorage('whmcsadmin');
  final pinController = TextEditingController();
  final confpinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Authorized to View Report',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      // print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _authorized = authenticated == true ? 'Authorized' : 'Not Authorized';
      if (authenticated == true) {
        var items = storage.getItem('whmcsadmin');
        if (items == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CredentialPage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportPage()),
          );
        }
      }
    });
  }

  Future<void> _pinauthenticate() async {
    var items = storage.getItem('whmcsadmin');
    if (items == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CredentialPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _supportState.name != 'supported'
            ? Column(
                children: <Widget>[
                  const Spacer(flex: 2),
                  SizedBox(
                    height: 130,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 0,
                      color: Colors.blue[50],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          ListTile(
                            leading: Icon(Icons.notes),
                            title: Text(
                              '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Text(""),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  GestureDetector(
                    onTap: () {
                      _authenticate();
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset('assets/images/fingerprint.png',
                            width: 80, height: 100)),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )
            : pinScreen(),
      ),
    );
  }

  Widget pinScreen() {
    var storedpin = storage.getItem('adminpin');
    // inspect(storedpin);
    if (storedpin != "" && storedpin != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              key: const Key('PasswordField'),
              controller: pinController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'Enter Pin',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1)),
              ),
            ),
            ElevatedButton(
              key: const Key('UnlockButton'),
              child: const Text('Unlock'),
              onPressed: () {
                if (pinController.text.trim() == storedpin) {
                  _pinauthenticate();
                } else {
                  showDialogBox("Wrong Pin");
                }
              },
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              key: const Key('PinField'),
              controller: pinController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'Choose your pin',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              key: const Key('ConfiPinField'),
              controller: confpinController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'Confirm Pin',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1)),
              ),
            ),
            ElevatedButton(
              key: const Key('SetPin'),
              child: const Text('Set Pin'),
              onPressed: () {
                if (pinController.text.trim() ==
                    confpinController.text.trim()) {
                  storage.setItem('adminpin', pinController.text.trim());
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  showDialogBox("Pin Mismatched");
                }
              },
            )
          ],
        ),
      );
    }
  }

  void showDialogBox(text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("$text"),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
