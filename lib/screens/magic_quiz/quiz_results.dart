import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/main.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class QuizResultsPage extends StatelessWidget {
  final int totalPoints;

  QuizResultsPage({required this.totalPoints});

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
