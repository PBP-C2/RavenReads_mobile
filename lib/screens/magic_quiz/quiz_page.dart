import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/screens/magic_quiz/quiz_results.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class Question {
  final String question;
  final List<Map<String, dynamic>> options;

  Question({required this.question, required this.options});
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int totalPoints = 0;
  int currentQuestion = 0;
  String displayText = '';
  String fetchedPoints = '0';
  List<Question> questions = [
    Question(
      question: "What genre do you prefer to read?",
      options: [
        {"option": "Mystery", "value": 1},
        {"option": "Fantasy", "value": 3},
        {"option": "Biography", "value": 7},
        {"option": "Science Fiction", "value": 10},
      ],
    ),
    Question(
      question: "Do you prefer standalone novels or book series?",
      options: [
        {"option": "Standalone Novels", "value": 1},
        {"option": "Book Series", "value": 3},
        {"option": "I like both equally", "value": 7},
        {"option": "I don't have a preference", "value": 10},
      ],
    ),
    Question(
      question: "What kind of setting do you enjoy in a book?",
      options: [
        {"option": "Imaginary Worlds", "value": 1},
        {"option": "Futuristic Worlds", "value": 3},
        {"option": "Historical Settings", "value": 7},
        {"option": "Realistic Settings", "value": 10},
      ],
    ),
    Question(
      question: "Which type of protagonist do you prefer?",
      options: [
        {"option": "Flawed and complex characters", "value": 1},
        {"option": "Heroic and virtuous characters", "value": 3},
        {"option": "Anti-heroes", "value": 7},
        {"option": "Real-life figures", "value": 10},
      ],
    ),
    Question(
      question: "What length of book do you usually prefer?",
      options: [
        {"option": "Short Novels", "value": 1},
        {"option": "Moderate Length Novels", "value": 3},
        {"option": "Long Epics", "value": 7},
        {"option": "I don't have a preference", "value": 10},
      ],
    ),
    Question(
      question: "Which plot element appeals to you the most?",
      options: [
        {"option": "Twists and turns", "value": 1},
        {"option": "Magic and fantastical elements", "value": 3},
        {"option": "Technological advancements", "value": 7},
        {"option": "Real-life challenges and triumphs", "value": 10},
      ],
    ),
    Question(
      question: "What type of narrative style do you enjoy?",
      options: [
        {"option": "First-person narration", "value": 1},
        {"option": "Third-person limited narration", "value": 3},
        {"option": "Third-person omniscient narration", "value": 7},
        {"option": "I don't have a preference", "value": 10},
      ],
    ),
    Question(
      question: "What drives you to keep reading a book?",
      options: [
        {"option": "Puzzling mysteries and clues", "value": 1},
        {"option": "Epic battles and adventures", "value": 3},
        {"option": "Exploration of futuristic ideas", "value": 7},
        {"option": "Compelling life stories", "value": 10},
      ],
    ),
    Question(
      question: "What emotional impact do you prefer from a book?",
      options: [
        {"option": "Suspense and thrill", "value": 1},
        {"option": "Wonder and awe", "value": 3},
        {"option": "Excitement and adrenaline", "value": 7},
        {"option": "Reflection and empathy", "value": 10},
      ],
    ),
    Question(
      question: "Which of the following topics interests you the most?",
      options: [
        {"option": "Crime and investigation", "value": 1},
        {"option": "Magic and mythical creatures", "value": 3},
        {"option": "Space exploration and futuristic technology", "value": 7},
        {"option": "Human achievements and struggles", "value": 10},
      ],
    ),
  ];

  void displayQuestion() {
    if (currentQuestion < questions.length) {
      Question current = questions[currentQuestion];
      setState(() {
        displayText = current.question;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookRecommendation(totalPoints: totalPoints),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    displayQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Quiz'),
        backgroundColor: const Color.fromARGB(255, 12, 39, 61),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://picsum.photos/seed/picsum/200/300'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      displayText,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              if (currentQuestion < questions.length)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...questions[currentQuestion].options.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  totalPoints += option["value"] as int;
                                  currentQuestion++;
                                  displayQuestion();
                                });
                                final response = await request.postJson(
                                  "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/post_quiz_points_flutter/",
                                  jsonEncode(<String, String>{
                                    'points': totalPoints.toString(),
                                  }),
                                );
                                fetchedPoints = response['points'];
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                              ),
                              child: Text(
                                option["option"] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      if (totalPoints == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Answer at least 1 question'),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookRecommendation(
                              totalPoints: int.parse(fetchedPoints),
                            ),
                          ),
                        );
                      }
                    },
                    label: const Text('Finish Quiz'),
                    backgroundColor: const Color.fromARGB(255, 12, 39, 61),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
