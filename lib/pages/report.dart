import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:whmcsadmin/pages/credential.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:whmcsadmin/pages/dashboard.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPage();
}

class _ReportPage extends State<ReportPage> {
  final LocalStorage storage = LocalStorage('whmcsadmin');
  String today = "";
  String month = "";
  String year = "";
  String alltime = "";
  bool isData = false;
  getReport() async {
    var cred = storage.getItem('whmcsadmin');
    var credential = jsonDecode(cred.toString());
    try {
      final response = await http.post(
        Uri.parse("${credential['url']}/includes/api.php"),
        body: {
          "action": "billingoverview",
          "username": credential['username'],
          "password":
              md5.convert(utf8.encode(credential['password'])).toString(),
          "responsetype": "json",
          "accesskey": credential['accesskey'],
        },
      );
      var jsondata = jsonDecode(response.body);
      inspect(jsondata['income']);
      // if (response.statusCode == 200) {
      if (jsondata['result'] == "success") {
        today = jsondata['income']['today'];
        month = jsondata['income']['thismonth'];
        year = jsondata['income']['thisyear'];
        alltime = jsondata['income']['alltime'];
        setState(() {
          isData = true;
        });
      } else {
        showDialogBox(jsondata['message']);
      }
    } catch (e) {
      inspect(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getReport();
  }

  Widget ReportUI() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        padding: const EdgeInsets.all(2),
        children: <Widget>[
          SizedBox(
            height: 130,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0,
              color: Colors.red[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: const Text(
                        'Today Income',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(today)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0,
              color: Colors.green[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: const Text(
                      'This Month',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(month),
                  ),
                ],
              ),
            ),
          ),
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
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: const Text(
                      'This Year',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(year),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0,
              color: Colors.pink[50],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: const Text(
                      'All Time',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text(alltime),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Report"),
          centerTitle: true,
          // automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                storage.deleteItem('whmcsadmin');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CredentialPage()),
                );
              },
            )
          ],
        ),
        body: isData == false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ReportUI(),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 5, 96, 170)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(children: <Widget>[
                    SizedBox(height: 100),
                    ListTile(
                      title: Text(
                        'Settings',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.shuffle,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      onTap: () {
                        /*Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => shufflerBuilder()));*/
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Support',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.info_outline,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      onTap: () {
                        /* Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => mistakePage()));*/
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Knowlede Base',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.border_color,
                        size: 20.0,
                        color: Colors.white,
                      ),
                      onTap: () {
                        /*Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => importantLinks()));*/
                      },
                    ),
                  ]),
                ),
                Container(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Column(
                          children: <Widget>[
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.dashboard),
                              title: Text('Dashboard'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardPage()),
                                );
                              },
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
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
