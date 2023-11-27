import 'package:flutter/material.dart';

class Product {
  final String name;
  final int price;
  final String description;

  Product(this.name, this.price, this.description);
}

class ProductListPage extends StatelessWidget {
  static List<Product> products = [];

  ProductListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          return Card(
            child: ListTile(
              title: Text('Nama: ${product.name}'),
              subtitle: Text('Harga: ${product.price}\nDeskripsi: ${product.description}'),
            ),
          );
        },
      ),
    );
  }
}