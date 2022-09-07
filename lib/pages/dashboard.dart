import 'package:SmarterX/drawer.dart';
import 'package:SmarterX/pages/editcredential.dart';
import 'package:flutter/material.dart';
import 'package:SmarterX/pages/credential.dart';
import '../dbhelper.dart';
import '../whmcslist.dart';
import 'package:SmarterX/pages/report.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  bool isData = false;
  List<Whmcslist> whmcslist = [];

  @override
  void initState() {
    super.initState();
    getAllWhmcs();
  }

  Future getAllWhmcs() async {
    final alllists = await DatabaseHelper.instance.queryAllRows();
    whmcslist.clear();
    setState(() {
      alllists.forEach((row) => whmcslist.add(Whmcslist.fromMap(row)));
      isData = whmcslist.isNotEmpty ? true : false;
    });
  }

  Widget DashboardUI() {
    // inspect(isData);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: whmcslist.length,
        itemBuilder: (BuildContext context, int index) {
          int id = (whmcslist[index].id)!.toInt();
          return SizedBox(
            height: 100,
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
                    title: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPage(id: id)),
                        );
                      },
                      child: Text(whmcslist[index].name.toString()),
                    ),
                    subtitle: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPage(id: id)),
                        );
                      },
                      child: Text(whmcslist[index].url.toString()),
                    ),
                    trailing: Wrap(
                      spacing: 20, // space between two icons
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditCredentialPage(id: id)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            if (await confirm(
                              context,
                              title: const Text('Delete'),
                              content: const Text('Are you sure?'),
                              textOK: const Text('OK'),
                              textCancel: const Text('Cancel'),
                            )) {
                              await DatabaseHelper.instance
                                  .delete(id)
                                  .then((value) => getAllWhmcs());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.logout,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => const CredentialPage()),
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
                getAllWhmcs();
                return Future<void>.delayed(const Duration(seconds: 3));
              },
              child: DashboardUI(),
            ),
      drawer: SiderBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CredentialPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
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
