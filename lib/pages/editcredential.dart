import 'package:flutter/material.dart';
import 'package:SmarterX/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dbhelper.dart';
import '../whmcslist.dart';

class EditCredentialPage extends StatefulWidget {
  const EditCredentialPage({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<EditCredentialPage> createState() => _EditCredentialPage();
}

class _EditCredentialPage extends State<EditCredentialPage> {
  final _formKey = GlobalKey<FormState>();
  var client = http.Client();
  final nameController = TextEditingController();
  final urlController = TextEditingController();
  final apiuserController = TextEditingController();
  final passwordController = TextEditingController();
  final secretController = TextEditingController();
  int id = 0;
  String name = '';
  String url = '';
  String api = '';
  String password = '';
  String secret = '';
  bool _passwordVisible = true;
  List<Whmcslist> whmcslist = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSingleWhmcs();
  }

  Future getSingleWhmcs() async {
    final alllists = await DatabaseHelper.instance.queryRow(widget.id);
    whmcslist.clear();
    setState(() {
      alllists.forEach((row) => whmcslist.add(Whmcslist.fromMap(row)));
      nameController.text = (whmcslist[0].name).toString();
      urlController.text = whmcslist[0].url.toString();
      apiuserController.text = whmcslist[0].api.toString();
      passwordController.text = (whmcslist[0].password).toString();
      secretController.text = (whmcslist[0].secret).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("API Credential"),
        centerTitle: true,
        // automaticallyImplyLeading: isWhmcsList,
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
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1)),
                    labelText: 'Your WHMCS Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WHMCS Name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
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
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(_passwordVisible == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      }),
                  labelText: 'Your API Admin Password',
                  border: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                ),
                obscureText: _passwordVisible,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: _submit,
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Loading...',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ],
                      )
                    : const Text('Update'),
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
      setState(() {
        isLoading = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
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
            Map<String, dynamic> row = {
              DatabaseHelper.columnId: widget.id,
              DatabaseHelper.columnName: nameController.text.trim(),
              DatabaseHelper.columnUrl: urlController.text.trim(),
              DatabaseHelper.columnApi: apiuserController.text.trim(),
              DatabaseHelper.columnPasword: passwordController.text.trim(),
              DatabaseHelper.columnSecret: secretController.text.trim(),
            };
            Whmcslist whmcslist = Whmcslist.fromMap(row);

            final inserted = await DatabaseHelper.instance.update(whmcslist);
            inspect(inserted);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
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

  Future<void> _launchURL() async {
    final Uri _url = Uri.parse(
        'https://www.whmcssmarters.com/clients/index.php?rp=/knowledgebase/201/How-to-get-API-Credentials.html');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
