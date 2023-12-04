import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/models/Book/book.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

class BookCard extends StatelessWidget {
  final Book book;

  BookCard(this.book);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            book.fields.imageUrlS,
            width: 50,
            height: 50,
          ),
          SizedBox(height: 10),
          Text(
            book.fields.title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            book.fields.author,
            style: TextStyle(fontSize: 12, color: Colors.white),
            textAlign: TextAlign.center,
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
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> listProduct = [];
    for (var d in data) {
      if (d != null && d['pk'] < 50) {
        listProduct.add(Book.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  void initState() {
    super.initState();
    _books = fetchProduct(); // Mengambil data saat initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LIST OF BOOKS',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Book Store',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
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
