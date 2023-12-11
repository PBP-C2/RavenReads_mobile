import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/Book/book.dart';

class ProductPage extends StatefulWidget {
  final List<int> bookIds;

  const ProductPage({Key? key, required this.bookIds}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Book> selectedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    for (int i = 0; i < widget.bookIds.length; i++) {
      final bookId = widget.bookIds[i];
      try {
        final bookDetails = await fetchBookDetailsById(bookId);
        setState(() {
          selectedBooks.add(bookDetails!);
        });
      } catch (e) {
        print("Error fetching book details: $e");
      }
    }
  }

  Future<Book?> fetchBookDetailsById(int bookId) async {
    final url = Uri.parse('http://127.0.0.1:8000/get_book_details/$bookId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      final Book bookDetails = Book.fromJson(data);
      return bookDetails;
    } else {
      throw Exception('Failed to load book details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    Future<List<dynamic>> seeCheckout() async {
      final response =
          await request.get('http://127.0.0.1:8000/get_book_details/');

      return response['checkout_books'].map((book) => book).toList();
    }

    return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Book Store Checkout',
      ),
    ),
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
  body: FutureBuilder(
    future: seeCheckout(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!.map((book) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, // Set rata kiri
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Author: ${book['author']}"),
                    const SizedBox(height: 10),
                    Text("Publisher: ${book['publisher']}"),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  ),
);

  }
}
