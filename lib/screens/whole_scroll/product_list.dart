import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:raven_reads_mobile/models/WholeScroll/spellbook.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductListPage> {
  Future<List<Scroll>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/spell_book/show_scroll/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Scroll> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Scroll.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(),
        builder: (context, AsyncSnapshot<List<Scroll>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                Text(
                  "Tidak ada data produk.",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 10),
                ),
                const SizedBox(height: 8),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200, // Adjust the height as needed
                      color: Color(0xff4F74DD), // Set your desired shade of blue
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'WholeScroll',
                            style: TextStyle(
                              fontSize: 48,
                              color: Color(0xfffffffffff),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
             
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        _showProductDetails(context, snapshot.data![index]);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                "${snapshot.data![index].fields.imageUrl}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data![index].fields.title}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
  void _showProductDetails(BuildContext context, Scroll scroll) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "${scroll.fields.title}",
            textAlign: TextAlign.center, 
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              
            ),
            ),
          
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${scroll.fields.content}"),
                // Add more details as needed
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
}
// class WaveClip extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double curveHeight = size.height / 4; // Adjust the value to control the wave height
//     double curveWidth = size.width / 4; // Adjust the value to control the wave width

//     var path = Path()
//       ..lineTo(0, size.height)
//       ..lineTo(curveWidth, size.height - curveHeight)
//       ..lineTo(2 * curveWidth, size.height)
//       ..lineTo(3 * curveWidth, size.height - curveHeight)
//       ..lineTo(4 * curveWidth, size.height)
//       ..lineTo(size.width, size.height)
//       ..lineTo(size.width, 0);

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // default is 56.0

  CurvedAppBar({
    Key? key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedBottomClipper(),
      child: AppBar(
        title: Text(''),
        backgroundColor:  Color(0xff4F74DD), 
        // rest of your AppBar properties
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height + 30, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}