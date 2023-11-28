import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/ReplyThreadFormScreen.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/ReplyThread.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/MainDiscussionFormModal.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';

class ReplyThreadScreen extends StatefulWidget {
  final int id;
  
  const ReplyThreadScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ReplyThreadScreenState createState() => _ReplyThreadScreenState();
}
class _ReplyThreadScreenState extends State<ReplyThreadScreen> {

  Future<List<ReplyThread>> fetchReplyThread(int id) async {
      var url = Uri.parse(
          'http://127.0.0.1:8000/get_thread_json/$id');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Product
      List<ReplyThread> list_product = [];
      for (var d in data) {
          if (d != null) {
              list_product.add(ReplyThread.fromJson(d));
          }
      }
      return list_product;
  }
  
  Future<List<Widget>> fetchAndCreateCards(BuildContext context) async {
    // Fetch Wizard data
    List<ReplyThread> wizardThreads = await fetchReplyThread(widget.id);

    // Create cards for Wizard data
    List<Widget> cards = wizardThreads.map((wizardThread) {
      return InkWell(
        child: Card(
          // Customize your card
          child: ListTile(
            title: Text(wizardThread.fields.content), // Assuming WizardThread has a 'title' field
            // Add other card details
          ),
        ),
      );
    }).toList();
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.user?.username ?? 'Guest';
    final id = userProvider.user?.id ?? 0;
    final cardContent = fetchAndCreateCards(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Threads'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Widget>>(
        future: cardContent,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text("Belum ada thread yang dibuat")
                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to be taken when the button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReplyThreadFormScreen(main_thread_id:widget.id )),
          );
        },
        child: Icon(Icons.add), // Replace with your icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }
}