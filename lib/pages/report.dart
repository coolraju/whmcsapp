import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:whmcsadmin/pages/credential.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPage();
}

class _ReportPage extends State<ReportPage> {
  final LocalStorage storage = LocalStorage('whmcsadmin');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                MaterialPageRoute(builder: (context) => const CredentialPage()),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          SizedBox(
            height: 130,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  ListTile(
                      leading: Icon(Icons.attach_money_rounded),
                      title: Text(
                        'Today Income',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text("1000")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money_rounded),
                    title: Text(
                      'This Month',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text('10000'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money_rounded),
                    title: Text(
                      'This Year',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text('10000'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money_rounded),
                    title: Text(
                      'All Time',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    subtitle: Text('1321321'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
