import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:raven_reads_mobile/models/Discussion Forum/ReplyThread.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReplyThreadScreen extends StatefulWidget {
  const ReplyThreadScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply Thread'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Reply',
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}