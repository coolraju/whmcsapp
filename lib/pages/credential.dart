import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whmcsadmin/pages/report.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class CredentialPage extends StatefulWidget {
  const CredentialPage({Key? key}) : super(key: key);

  @override
  State<CredentialPage> createState() => _CredentialPage();
}

class _CredentialPage extends State<CredentialPage> {
  final LocalStorage storage = LocalStorage('whmcsadmin');
  final _formKey = GlobalKey<FormState>();
  var client = http.Client();
  final urlController = TextEditingController();
  final apiuserController = TextEditingController();
  final passwordController = TextEditingController();
  final secretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("API Credential"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1)),
                    labelText: 'Your WHMCS URL with http/https'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WHMCS url';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: apiuserController,
                decoration: const InputDecoration(
                  labelText: 'Your API Admin User',
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter API Admin user';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Your API Admin Password',
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter API Admin Password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: secretController,
                decoration: const InputDecoration(
                  labelText: 'Your API Access Key',
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                ),
                // obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  API Access Key';
                  }
                  return null;
                },
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: _submit,
                child: const Text('Login'),
              ),
              const Spacer(flex: 1),
              Center(
                  child: InkWell(
                      child: const Text(
                        'How to get API Credentials?',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () => _launchURL())),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        final response = await http.post(
          Uri.parse("${urlController.text.trim()}/includes/api.php"),
          body: {
            "action": "billingoverview",
            "username": apiuserController.text.trim(),
            "password": md5
                .convert(utf8.encode(passwordController.text.trim()))
                .toString(),
            "responsetype": "json",
            "accesskey": secretController.text.trim(),
          },
        );
        // inspect(response);
        var jsondata = jsonDecode(response.body);
        // inspect(jsondata);
        if (response.statusCode == 200) {
          if (jsondata['result'] == "success") {
            WhmcsCredential whmcscredential = WhmcsCredential(
                urlController.text.trim(),
                apiuserController.text.trim(),
                passwordController.text.trim(),
                secretController.text.trim());
            String jsoncred = jsonEncode(whmcscredential);
            storage.setItem('whmcsadmin', jsoncred);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReportPage()),
            );
          } else {
            showDialogBox("Connection failed." + jsondata['message']);
          }
        } else {
          showDialogBox(
              'Request failed with status: ${response.statusCode}. Message: ${jsondata['message']}');
        }
      } catch (e) {
        inspect(e);
        showDialogBox(e.toString());
      }
    } else {
      showDialogBox("Please fill all fields.");
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

  _launchURL() async {
    const _url =
        'https://www.whmcssmarters.com/clients/index.php?rp=/knowledgebase/201/How-to-get-API-Credentials.html';
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}

class WhmcsCredential {
  String whmcsurl;
  String whmcsapiuser;
  String whmcsapipassword;
  String secret;
  WhmcsCredential(
      this.whmcsurl, this.whmcsapiuser, this.whmcsapipassword, this.secret);
  Map toJson() => {
        'url': whmcsurl,
        'username': whmcsapiuser,
        'password': whmcsapipassword,
        'accesskey': secret
      };
}
