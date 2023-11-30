import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/models/Book/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class BookRecommendation extends StatefulWidget {
  final int totalPoints;

  const BookRecommendation({required this.totalPoints});

  @override
  _BookRecommendationState createState() => _BookRecommendationState();
}

class _BookRecommendationState extends State<BookRecommendation> {
  late Future<List<Book>> _books;

  Future<List<Book>> fetchBooks() async {
    final int points = widget.totalPoints;
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Book> books = [];
      for (var d in data) {
        if (d['pk'] == points - 1 ||
            d['pk'] == points - 2 ||
            d['pk'] == points - 3 ||
            d['pk'] == points) {
          books.add(Book.fromJson(d));
        }
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  void initState() {
    super.initState();
    _books = fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Recommendations'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: _books,
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No book data.",
                style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/seed/picsum/200/300',
                  ), // Replace with your image URL
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        orientation == Orientation.landscape ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    double screenWidth = MediaQuery.of(context).size.width;
                    double cardTextScaleFactor = screenWidth > 600 ? 1.5 : 1.0;

                    return Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  snapshot.data![index].fields.imageUrlL!,
                                  fit: BoxFit.cover,
                                  width: double
                                      .infinity, // Makes image responsive in width
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${snapshot.data![index].fields.title}",
                                    style: TextStyle(
                                      fontSize: 18.0 * cardTextScaleFactor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Author: ${snapshot.data![index].fields.author}",
                                    style: TextStyle(
                                        fontSize: 16.0 * cardTextScaleFactor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "ISBN: ${snapshot.data![index].fields.isbn}",
                                    style: TextStyle(
                                        fontSize: 16.0 * cardTextScaleFactor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Year Published: ${snapshot.data![index].fields.yearPublication}",
                                    style: TextStyle(
                                        fontSize: 16.0 * cardTextScaleFactor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Publisher: ${snapshot.data![index].fields.publisher}",
                                    style: TextStyle(
                                        fontSize: 16.0 * cardTextScaleFactor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
