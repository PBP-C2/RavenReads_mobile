import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/ReplyThreadFormScreen.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion%20Forum/ReplyThread.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:raven_reads_mobile/widgets/Discussion%20Forum/MainDiscussionFormModal.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/MuggleThread.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/WizardThread.dart';

class ReplyThreadScreen extends StatefulWidget {
  final int id;
  
  const ReplyThreadScreen({Key? key, required this.id}) : super(key: key);

  @override
  _ReplyThreadScreenState createState() => _ReplyThreadScreenState();
}

class _ReplyThreadScreenState extends State<ReplyThreadScreen> {
  late Future<List<ReplyThread>> futureReplyThreads;
  late Future<List<String>> futurePersonName;
  late Future<List<MuggleThread>> futureMainThread;

  


  Future<WizardThread> fetchWizardThread(int id) async {
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_thread_json/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    return data;
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

  @override
  void initState() {
    super.initState();
    // Initialize futureReplyThreads with the initial data
    futureReplyThreads = fetchReplyThreads(widget.id);
    futurePersonName = fetchPersonNamesFromThreads();
    futureMainThread = fetchMuggleThread(widget.id);
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

  Future<List<MuggleThread>> fetchMuggleThread(int id) async {
  var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_main_thread_by_id/$id');
  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return data.map((d) => MuggleThread.fromJson(d)).toList();
    } else {
      throw Exception('Failed to load threads');
    }
}

  Future<List<String>> fetchPersonNamesFromThreads() async {
    // Wait for the reply threads to finish fetching.
    List<ReplyThread> replyThreads = await futureReplyThreads;

    // Create a list to hold the names.
    List<String> names = [];

    // Iterate over the reply threads and fetch each person's name.
    for (var thread in replyThreads) {
      try {
        String name = await getPersonName(thread.fields.person);
        names.add(name);
      } catch (e) {
        // If there's an error, add a default name or handle it accordingly.
        names.add('Unknown');
      }
    }

    return names;
  }


  Future<void> _refreshData() async {
    setState(() {
      // Re-fetch the data
      futureReplyThreads = fetchReplyThreads(widget.id);
      futurePersonName = fetchPersonNamesFromThreads();
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
      // drawer: const LeftDrawer(),
      body: Column(
        children: [
          FutureBuilder<List<MuggleThread>>(
            future: futureMainThread,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Belum ada thread yang dibuat"));
              } else {
                return Card(
                  color: Colors.orange,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("https://api.ambr.top/assets/UI/UI_AvatarIcon_Neuvillette.png?vh=2023100601"), // Replace with actual URL
                      radius: 20,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username), // Person's name
                        Text(snapshot.data![0].fields.dateCreated.toString()), // Date of creation, formatted
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            snapshot.data![0].fields.content.length > 100 
                              ? snapshot.data![0].fields.content.substring(0, 100) + '...'
                              : snapshot.data![0].fields.content, // First 100 characters of content
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          Expanded(
            child: 
          FutureBuilder<List<ReplyThread>>(
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
                return FutureBuilder<List<String>>(
                  future: futurePersonName,
                  builder: (context, nameSnapshot) {
                    if (nameSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (nameSnapshot.hasError) {
                      return Center(child: Text('Error: ${nameSnapshot.error}'));
                    } else if (!nameSnapshot.hasData || nameSnapshot.data!.isEmpty) {
                      return const Center(child: Text('Unknown'));
                    } else {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage("https://api.ambr.top/assets/UI/UI_AvatarIcon_Neuvillette.png?vh=2023100601"), // Replace with actual URL
                            radius: 20,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nameSnapshot.data![index]), // Person's name
                              Text(replyThread.fields.dateCreated.toString()), // Date of creation, formatted
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  replyThread.fields.content.length > 100 
                                    ? replyThread.fields.content.substring(0, 100) + '...'
                                    : replyThread.fields.content, // First 100 characters of content
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
            
              },
            );
          }
        },
      ),
          ),
      ],
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
