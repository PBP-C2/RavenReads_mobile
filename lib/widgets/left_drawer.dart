import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/main.dart';
import 'package:raven_reads_mobile/screens/book_progress/book_progress.dart';
import 'package:raven_reads_mobile/screens/magic_quiz/quiz_page.dart';
import 'package:raven_reads_mobile/screens/forum_discussion/main_discussion.dart';
import 'package:raven_reads_mobile/screens/book_store/book_store.dart';
import 'package:raven_reads_mobile/screens/whole_scroll/product_list.dart';
import 'package:raven_reads_mobile/screens/whole_scroll/shoplist_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 79, 116, 221),
            ),
            child: Column(
              children: [
                Text(
                  'RavenReads',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                    "",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
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
                    builder: (context) => const MyHomePage(
                      title: "RavenReads Mobile",
                    ),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: const Text('Main Discussion'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDiscussion(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz_outlined),
            title: const Text('Magic Quiz'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Spell Book'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopFormPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_add),
            title: const Text('Whole Scroll'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Book Store'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookStorePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Book Progress'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookProgressionPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
