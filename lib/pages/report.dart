import 'package:SmarterX/drawer.dart';
import 'package:flutter/material.dart';
import 'package:SmarterX/pages/credential.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:SmarterX/pages/dashboard.dart';
import '../dbhelper.dart';
import '../whmcslist.dart';

class ReportPage extends StatefulWidget {
  final int id;
  const ReportPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPage();
}

class _ReportPage extends State<ReportPage> {
  List<Whmcslist> whmcslist = [];
  String today = "";
  String month = "";
  String year = "";
  String alltime = "";
  bool isData = false;

  Future getReport() async {
    final alllists = await DatabaseHelper.instance.queryRow(widget.id);
    alllists.forEach((row) => whmcslist.add(Whmcslist.fromMap(row)));
    try {
      var password = whmcslist[0].password;
      final response = await http.post(
        Uri.parse("${whmcslist[0].url}/includes/api.php"),
        body: {
          "action": "billingoverview",
          "username": whmcslist[0].api,
          "password": md5.convert(utf8.encode(password.toString())).toString(),
          "responsetype": "json",
          "accesskey": whmcslist[0].secret,
        },
      );
      var jsondata = jsonDecode(response.body);
      // inspect(jsondata['income']);
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
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(
          //       Icons.logout,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       // storage.deleteItem('whmcsadmin');
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CredentialPage()),
          //       );
          //     },
          //   )
          // ],
        ),
        body: isData == false
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.blue,
                onRefresh: () async {
                  getReport();
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: ReportUI()),
        drawer: SiderBar(),
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
