import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class Product {
  final String title;
  final String imageurl;
  final String content;

  Product(this.title, this.imageurl, this.content);
}

void _showProductDetails(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(product.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.content),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class ProductListPage extends StatelessWidget {
  static List<Product> products = [];

  ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creators Book"),
        backgroundColor: Colors.indigo[900], // Adjust the color to match PNG
        actions: [
          IconButton(
            icon: const Icon(Icons.menu), // Change to your menu icon
            onPressed: () {
              // Open drawer or do something else
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0), 
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
          childAspectRatio: 0.6, // Adjust this to a portrait ratio
        ),

        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return GestureDetector(
            onTap: () {
              _showProductDetails(context, product);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0), // Rounded corners for the card
              ),
              elevation: 5.0, // Card shadow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the card items
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0), // Rounded corners for the image
                        child: Image.network(
                          product.imageurl,
                          fit: BoxFit.cover, // Cover the area without changing the aspect ratio
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Adjust as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),


          );
        },
      ),
      drawer: const LeftDrawer(), // Your custom drawer
    );
  }
}
