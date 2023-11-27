import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/MuggleThread.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/WizardThread.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';
import 'package:raven_reads_mobile/widgets/MainDiscussionFormModal.dart';


class MainDiscussion extends StatelessWidget {
  const MainDiscussion({Key? key}) : super(key: key);

  Future<List<MuggleThread>> fetchMuggleThread() async {
      var url = Uri.parse(
          'http://127.0.0.1:8000/get_muggle_json/');
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
      var url = Uri.parse(
          'http://127.0.0.1:8000/get_wizard_json/');
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

  Future<List<Widget>> fetchAndCreateCards() async {
    // Fetch Wizard data
    List<WizardThread> wizardThreads = await fetchWizardThread();

    // Create cards for Wizard data
    List<Widget> cards = wizardThreads.map((wizardThread) {
      return Card(
        // Customize your card
        child: ListTile(
          title: Text(wizardThread.fields.title), // Assuming WizardThread has a 'title' field
          // Add other card details
        ),
      );
    }).toList();

    // Fetch Muggle data
    List<MuggleThread> muggleThreads = await fetchMuggleThread();

    // Create cards for Muggle data and add to the existing list
    cards.addAll(muggleThreads.map((muggleThread) {
      return Card(
        // Customize your card
        child: ListTile(
          title: Text(muggleThread.fields.title), // Assuming MuggleThread has a 'title' field
          // Add other card details
        ),
      );
    }).toList());

    return cards;
  }


  @override
  Widget build (BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.user?.username ?? 'Guest';
    final id = userProvider.user?.id ?? 0;

    final cardContent = fetchAndCreateCards();

    return Scaffold(
      appBar: AppBar(
        title: Text('Threads'),
      ),
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
            MaterialPageRoute(builder: (context) => MainDiscussionFormScreen()),
          );
        },
        child: Icon(Icons.add), // Replace with your icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }

}

