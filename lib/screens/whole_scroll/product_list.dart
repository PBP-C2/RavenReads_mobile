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
      title: const Text("WholeScroll"),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
    body: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        Product product = products[index];
        return GestureDetector(
        onTap: () {
          _showProductDetails(context, product);
        },
        child: Card(
          child: SizedBox(
            width: 595.0, // Set the width
            height: 842.0, // Set the height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your image widget with BoxFit.cover
                SizedBox(
                  height: 200.0, // Adjust as needed
                  width: double.infinity, // Take the full width
                  child: Image.network(
                    product.imageurl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(product.title),
                ),
              ],
            ),
          ),
        ),

        );
      },
    ),
    drawer: const LeftDrawer(),
  );
}

}