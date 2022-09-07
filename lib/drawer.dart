import 'package:flutter/material.dart';
import 'pages/dashboard.dart';

class SiderBar extends StatefulWidget {
  const SiderBar({Key? key}) : super(key: key);

  @override
  State<SiderBar> createState() => _SiderBar();
}

class _SiderBar extends State<SiderBar> {
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 5, 96, 170)),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                SizedBox(height: 100),
                ListTile(
                  title: const Text(
                    'Settings',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: const Icon(
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
                  title: const Text(
                    'Support',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: const Icon(
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
                  title: const Text(
                    'Knowlede Base',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  leading: const Icon(
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
                                  builder: (context) => const DashboardPage()),
                            );
                          },
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
