import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:raven_reads_mobile/main.dart';
import 'package:raven_reads_mobile/models/Book/book.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class QuizResultsPage extends StatelessWidget {
  final int totalPoints;
  const QuizResultsPage({required this.totalPoints});

  Future<List<Book>> fetchProduct() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> list_product = [];
    for (var d in data) {
      if (d != null && d['fields']['pk'] == 1) {
        list_product.add(Book.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Quiz'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Total Points: $totalPoints',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: "RavenReads Mobile",
                      ),
                    ));
              },
              child: Text('Back to Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
