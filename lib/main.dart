import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/screens/book_store/book_store.dart';
import 'package:raven_reads_mobile/screens/login/login.dart';
import 'package:raven_reads_mobile/screens/magic_quiz/quiz_page.dart';
import 'package:raven_reads_mobile/screens/whole_scroll/product_list.dart';
import 'package:raven_reads_mobile/screens/whole_scroll/shoplist_form.dart';
import '../screens/forum_discussion/main_discussion.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CookieRequest>(
          create: (_) => CookieRequest(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: LoginPage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".;

  final List<ShopItem> items = [
    ShopItem("Discussion Forum", Icons.checklist, Colors.blue),
    ShopItem("Magic Quiz", Icons.add_shopping_cart, Colors.green),
    ShopItem("Spell Book", Icons.checklist, Colors.yellow),
    ShopItem("Whole Scroll", Icons.checklist, Colors.orange),
    ShopItem("Book Store", Icons.checklist, Colors.pink),
    ShopItem("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RavenReads',
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Welcome to RavenReads', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ShopItem item) {
                  // Iterasi untuk setiap item
                  return ShopCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopItem {
  final String name;
  final IconData icon;
  final Color color;

  ShopItem(this.name, this.icon, this.color);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;
  const ShopCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Discussion Forum") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainDiscussion()));
          } else if (item.name == "Magic Quiz") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QuizPage()));
          } else if (item.name == "Spell Book") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ShopFormPage()));
          } else if (item.name == "Whole Scroll") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductListPage()));
          } else if (item.name == "Book Store") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BookStorePage()));
          } else if (item.name == "Logout") {
            final response = await request.logout(
                "https://ravenreads-c02-tk.pbp.cs.ui.ac.id//auth/logout/");
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message"),
              ));
            }
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
