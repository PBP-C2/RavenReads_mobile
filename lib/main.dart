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
          home: const LoginPage()),
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
    ShopItem("Discussion Forum", Icons.checklist, const Color.fromARGB(255, 12, 39, 61)),
    ShopItem("Magic Quiz", Icons.add_shopping_cart, const Color.fromARGB(255, 12, 39, 61)),
    ShopItem("Spell Book", Icons.checklist, const Color.fromARGB(255, 12, 39, 61)),
    ShopItem("Whole Scroll", Icons.checklist, const Color.fromARGB(255, 12, 39, 61)),
    ShopItem("Book Store", Icons.checklist, const Color.fromARGB(255, 12, 39, 61)),
    ShopItem("Logout", Icons.logout, const Color.fromARGB(255, 134, 31, 24)),
  ];

  

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 12, 39, 61), // Dark background color
          child: Column(
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 12, 39, 61), // Top section color
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60.0), // Increased vertical padding
                child: const Text(
                  'Welcome to RavenReads',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Bottom section color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20), // Padding adjusted for curved top and spacing
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 5, // Horizontal space between items
                    mainAxisSpacing: 5, // Vertical space between items
                    childAspectRatio: 1.6, // Aspect ratio of the buttons
                  ),
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ShopCard(items[index]);
                  },
                ),
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
    return Card(
      color: item.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // Rounded corners
      ),
      child: InkWell(
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
                "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/auth/logout/");
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 40, // Icon size
              ),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    // return Material(
    //   color: item.color,
    //   child: InkWell(
    //     // Area responsive terhadap sentuhan
    //     onTap: () async {
    //       // Memunculkan SnackBar ketika diklik
    //       ScaffoldMessenger.of(context)
    //         ..hideCurrentSnackBar()
    //         ..showSnackBar(SnackBar(
    //             content: Text("Kamu telah menekan tombol ${item.name}!")));
    //       if (item.name == "Discussion Forum") {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => const MainDiscussion()));
    //       } else if (item.name == "Magic Quiz") {
    //         Navigator.push(
    //             context, MaterialPageRoute(builder: (context) => QuizPage()));
    //       } else if (item.name == "Spell Book") {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => const ShopFormPage()));
    //       } else if (item.name == "Whole Scroll") {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => ProductListPage()));
    //       } else if (item.name == "Book Store") {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => const BookStorePage()));
    //       } else if (item.name == "Logout") {
    //         final response = await request.logout(
    //             "https://ravenreads-c02-tk.pbp.cs.ui.ac.id//auth/logout/");
    //         String message = response["message"];
    //         if (response['status']) {
    //           String uname = response["username"];
    //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //             content: Text("$message Sampai jumpa, $uname."),
    //           ));
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(builder: (context) => const LoginPage()),
    //           );
    //         } else {
    //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //             content: Text("$message"),
    //           ));
    //         }
    //       }
    //     },
    //     child: Container(
    //       // Container untuk menyimpan Icon dan Text
    //       padding: const EdgeInsets.all(8),
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Icon(
    //               item.icon,
    //               color: Colors.white,
    //               size: 30.0,
    //             ),
    //             const Padding(padding: EdgeInsets.all(3)),
    //             Text(
    //               item.name,
    //               textAlign: TextAlign.center,
    //               style: const TextStyle(color: Colors.white),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
