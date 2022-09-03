import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whmcsadmin/pages/report.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class CredentialPage extends StatefulWidget {
  const CredentialPage({Key? key}) : super(key: key);

  @override
  State<CredentialPage> createState() => _CredentialPage();
}

class _CredentialPage extends State<CredentialPage> {
  late String _email;
  late String _password;
  late String _whmcsurl;
  final LocalStorage storage = LocalStorage('whmcsadmin');
  final _formKey = GlobalKey<FormState>();
  var client = http.Client();
  final urlController = TextEditingController();
  final apiuserController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Credential"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Whmcs URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter whmcs url';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apiuserController,
                decoration: const InputDecoration(labelText: 'Your email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Your password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: _testConnection,
                child: const Text('Test Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testConnection() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      showDialogBox("Please Wait..");
      try {
        var url = Uri.https(
            'www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});
        var response = await http.get(url);
        inspect(response);
        if (response.statusCode == 200) {
          var resp = response.body;
          print('Number of books about http: $resp.');
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialogBox('Credential is correct. Click to Login.');
        } else {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialogBox('Request failed with status: ${response.statusCode}.');
          print('Request failed with status: ${response.statusCode}.');
        }
      } finally {
        client.close();
      }
    }
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        WhmcsCredential whmcscredential = WhmcsCredential(urlController.text,
            apiuserController.text, passwordController.text);
        String jsoncred = jsonEncode(whmcscredential);
        storage.setItem('whmcsadmin', jsoncred);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data ... ')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportPage()),
        );
      } catch (e) {
        inspect(e);
      }
    } else {
      print("errror");
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

class WhmcsCredential {
  String whmcsurl;
  String whmcsapiuser;
  String whmcsapipassword;
  WhmcsCredential(this.whmcsurl, this.whmcsapiuser, this.whmcsapipassword);
  Map toJson() =>
      {'url': whmcsurl, 'username': whmcsapiuser, 'password': whmcsapipassword};
}
