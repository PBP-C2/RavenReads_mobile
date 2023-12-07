import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/ReplyThreadFormScreen.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion%20Forum/ReplyThread.dart';
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
  late Future<List<ReplyThread>> futureReplyThreads;

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

  @override
  void initState() {
    super.initState();
    // Initialize futureReplyThreads with the initial data
    futureReplyThreads = fetchReplyThreads(widget.id);
  }

  Future<List<ReplyThread>> fetchReplyThreads(int id) async {
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_thread_json/$id');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return data.map((d) => ReplyThread.fromJson(d)).toList();
    } else {
      throw Exception('Failed to load threads');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      // Re-fetch the data
      futureReplyThreads = fetchReplyThreads(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final username = userProvider.user?.username ?? 'Guest';
    final id = userProvider.user?.id ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Threads'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ReplyThread>>(
        future: futureReplyThreads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada thread yang dibuat"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final replyThread = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(replyThread.fields.content),
                    // Add other card details as needed
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReplyThreadFormScreen(main_thread_id: widget.id)),
          );

          if (result == 'submitted') {
            _refreshData();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
