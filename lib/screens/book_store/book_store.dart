import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/models/Book/book.dart';
import 'package:raven_reads_mobile/screens/book_store/checkout_store.dart';
import 'package:raven_reads_mobile/screens/book_store/store_form.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

enum Model { BOOK_BOOK }

class BookCard extends StatelessWidget {
  final Book book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 39, 61),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              constraints: BoxConstraints(maxHeight: 300),
              child: Image.network(
                book.fields.imageUrlL!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    color: Colors.black,
                     child: Center(
                      child: Text("Image not available"),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.fields.title,
                        style: TextStyle(
                          fontSize: book.fields.title.length > 30 ? 9 : 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      book.fields.author,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      'ID: ${book.pk}',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookStorePage extends StatefulWidget {
  const BookStorePage({Key? key}) : super(key: key);

  @override
  _BookStorePageState createState() => _BookStorePageState();
}

class _BookStorePageState extends State<BookStorePage> {
  late Future<List<Book>> _books;

  Future<List<Book>> fetchProduct() async {
    try {
      var url =
          Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/api/books/');
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
        List<Book> listProduct = [];
        for (var d in data) {
          if (d != null && d['pk'] <= 150) {
            listProduct.add(Book.fromJson(d));
          }
        }
        return listProduct;
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error in fetchProduct: $e");
      throw Exception("Failed to load data");
    }
  }

  List<Book> selectedBooks = [];

  @override
  void initState() {
    super.initState();
    _books = fetchProduct();
  }

  void navigateToAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShopFormPage()),
    );
  }

  void navigateToCheckout() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductPage(
                bookIds: selectedBooks.map((book) => book.pk).toList())),
      );
    } catch (e) {
      print("Error navigating to checkout: $e");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('There was an error'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void toggleBookSelection(Book book) {
    setState(() {
      if (selectedBooks.contains(book)) {
        selectedBooks.remove(book);
      } else {
        selectedBooks.add(book);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Book Store',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 39, 61),
        foregroundColor: Colors.grey[300],
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Choose Your Best Book',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: navigateToAddBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 39, 61),
                      foregroundColor: Colors.grey[300],
                    ),
                    child: Text('Add Book'),
                  ),
                  ElevatedButton(
                    onPressed: navigateToCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 39, 61),
                      foregroundColor: Colors.grey[300],
                    ),
                    child: Text('See Checkout'),
                  ),
                ],
              ),
              FutureBuilder<List<Book>>(
                future: _books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No books available.'),
                    );
                  } else {
                    List<Book> books = snapshot.data!;
                    return GridView.count(
                      primary: true,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: books.map((Book book) {
                        return BookCard(book);
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookStorePage(),
  ));
}
