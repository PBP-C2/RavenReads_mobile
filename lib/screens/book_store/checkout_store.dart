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
  
  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    Future<List<dynamic>> seeCheckout() async {
      final response =
          await request.get('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get_book_details/');

      return response['checkout_books'].map((book) => book).toList();
    }

    return Scaffold(
  appBar: AppBar(
    title: const Center(
      child: Text(
        'Book Store Checkout',
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 12, 39, 61),
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
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "ID: ${book['id']}",
                      style: TextStyle(
                        fontSize: 12, 
                        color: Colors.black, 
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Author: ${book['author']}",
                      style: TextStyle(
                        fontSize: 15, 
                        color: const Color.fromARGB(255, 12, 39, 61),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Publisher: ${book['publisher']}",
                      style: TextStyle(
                        fontSize: 14, 
                        color: const Color.fromARGB(255, 12, 39, 61), 
                      ),
                    ),
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
