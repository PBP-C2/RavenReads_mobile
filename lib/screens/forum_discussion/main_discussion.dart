import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/MuggleThread.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/WizardThread.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/MainDiscussionFormModal.dart';
import 'package:raven_reads_mobile/screens/forum_discussion/reply_thread.dart';


class MainDiscussion extends StatefulWidget {
  const MainDiscussion({Key? key}) : super(key: key);

  @override
  _MainDiscussionState createState() => _MainDiscussionState();
}

class _MainDiscussionState extends State<MainDiscussion> {
  Future<List<Widget>>? cardContent;

  Future<void> _refreshData() async {
    setState(() {
      // Re-fetch the data
      cardContent = fetchAndCreateCards(context);
    });
  }

  Future<List<MuggleThread>> fetchMuggleThread() async {
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_muggle_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<MuggleThread> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(MuggleThread.fromJson(d));
      }
    }
    return list_product;
  }

  Future<List<WizardThread>> fetchWizardThread() async {
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_wizard_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<WizardThread> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(WizardThread.fromJson(d));
      }
    }
    return list_product;
  }
  
  Future<String> getPersonName(int id) async {
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_person_name_flutter/$id'); // Replace with your actual endpoint
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id}), // If your Django view expects an ID in the body
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data["status"] == true) {
        return data["name"];
      } else {
        throw Exception('Failed to load name');
      }
    } else {
      // Handle the case where the server returns a 405 status code
      var data = jsonDecode(response.body);
      throw Exception(data["message"]);
    }
  }

  // Future<List<Widget>> fetchAndCreateCards(BuildContext context) async {
  //   // Fetch Wizard data
  //   List<WizardThread> wizardThreads = await fetchWizardThread();

  //   // Create cards for Wizard data
  //   List<Widget> cards = await Future.wait(wizardThreads.map((wizardThread) async {
  //     try {
  //       String personName = await getPersonName(wizardThread.fields.person);

  //       return InkWell(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => ReplyThreadScreen(id: wizardThread.pk)),
  //           );
  //         },
  //         child: Card(
  //           child: ListTile(
  //             leading: CircleAvatar(
  //               backgroundImage: NetworkImage("https://api.ambr.top/assets/UI/UI_AvatarIcon_Furina.png?vh=2023100601"), // Replace with actual URL
  //               radius: 20,
  //             ),
  //             title: Text(wizardThread.fields.title),
  //             subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(personName), // Person's name
  //               Text(wizardThread.fields.dateCreated.toString()), // Date of creation, formatted
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 8.0),
  //                 child: Text(
  //                   wizardThread.fields.content.length > 100 
  //                     ? wizardThread.fields.content.substring(0, 100) + '...'
  //                     : wizardThread.fields.content, // First 100 characters of content
  //                   style: TextStyle(color: Colors.grey[600]),
  //                 ),
  //               ),
  //             ],
  //           ),// Display the fetched person name
  //           ),
  //         ),
  //       );
  //     } catch (e) {
  //       // Handle the error appropriately
  //       return SizedBox.shrink(); // Return an empty widget if there's an error
  //     }
  //   }));
  //   return cards;
  // } 

  Future<List<Widget>> fetchAndCreateCards(BuildContext context) async {
    List<Widget> cards = [];

    // Fetch and process Wizard threads
    List<WizardThread> wizardThreads = await fetchWizardThread();
    for (var wizardThread in wizardThreads) {
      String personName = await getPersonName(wizardThread.fields.person);
      var wizardCard = _createWizardCard(wizardThread, personName, context);
      cards.add(wizardCard);
    }
    cards = cards.reversed.toList();

    // Fetch and process Muggle threads
    List<MuggleThread> muggleThreads = await fetchMuggleThread();
    muggleThreads = muggleThreads.reversed.toList();
    for (var muggleThread in muggleThreads) {
      String personName = await getPersonName(muggleThread.fields.person);
      var muggleCard = _createMuggleCard(muggleThread, personName, context);
      cards.add(muggleCard);
    }

    return cards;
  }

  Widget _createWizardCard(WizardThread thread, String personName, BuildContext context) {
    // Implement the Wizard card creation logic
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReplyThreadScreen(id: thread.pk)),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://t4.ftcdn.net/jpg/03/29/19/15/360_F_329191596_tRQiV7LZjTZtuPM09QyOS09HV1D9VimE.jpg"), // Replace with actual URL
            radius: 20,
          ),
          title: Text(thread.fields.title),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(personName), // Person's name
            Text(thread.fields.dateCreated.toString()), // Date of creation, formatted
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                thread.fields.content.length > 100 
                  ? thread.fields.content.substring(0, 100) + '...'
                  : thread.fields.content, // First 100 characters of content
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),// Display the fetched person name
        ),
      ),
    );
  }

  Widget _createMuggleCard(MuggleThread thread, String personName, BuildContext context) {
    // Implement the Muggle card creation logic
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReplyThreadScreen(id: thread.pk)),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1589859762194-eaae75c61f64?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Ymx1ZSUyMGNvbG9yfGVufDB8fDB8fHww"), // Replace with actual URL
            radius: 20,
          ),
          title: Text(thread.fields.title),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(personName), // Person's name
            Text(thread.fields.dateCreated.toString()), // Date of creation, formatted
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                thread.fields.content.length > 100 
                  ? thread.fields.content.substring(0, 100) + '...'
                  : thread.fields.content, // First 100 characters of content
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),// Display the fetched person name
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.user?.username ?? 'Guest';
    final id = userProvider.user?.id ?? 0;

    final cardContent = fetchAndCreateCards(context);

    return Scaffold(
        appBar: CurvedAppBar(),
        drawer: const LeftDrawer(),
        body: Container (
            color: const Color.fromARGB(255, 79, 116, 221), // Dark background color
            child: Column (
              children: <Widget>[
                Container(
                  color: const Color.fromARGB(255, 79, 116, 221), // Top section color
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 60.0), // Increased vertical padding
                  child: const Text(
                    'Main Discussion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Bottom section color
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),    
                  child: FutureBuilder<List<Widget>>(
                    future: cardContent,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (!snapshot.hasData) {
                          return const Column(
                            children: [Text("Belum ada thread yang dibuat")],
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return snapshot.data![index];
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                  ),
                  ),
                  ),
              ],
            )
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Action to be taken when the button is pressed
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  MainDiscussionFormScreen(id: id)),
            );

            if (result == 'submitted') {
              // Refresh your screen data
              _refreshData();
            }
          },
          child: Icon(Icons.add), // Replace with your icon
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // default is 56.0

  CurvedAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 79, 116, 221),
        foregroundColor: Colors.white,
        // elevation: 0,
        // rest of your AppBar properties
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}