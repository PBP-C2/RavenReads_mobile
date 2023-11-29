import 'package:flutter/material.dart';

class QuizResultsPage extends StatelessWidget {
  final int totalPoints;

  QuizResultsPage({required this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
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
                Navigator.pop(context);
              },
              child: Text('Back to Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
