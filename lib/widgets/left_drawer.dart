import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/main.dart';
import 'package:raven_reads_mobile/screens/forum_discussion/main_discussion.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'Shopping List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text("Uhhhhhhhhh isinya nanti aja ini mau diisi apaan saya juga gak tau", 
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          // TODO: Bagian routing
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: "RavenReads Mobile",),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Main Discussion'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainDiscussion(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}