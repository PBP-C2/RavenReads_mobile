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
    var url = Uri.parse('http://localhost:8000/spell_book/show_scroll/');
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
      appBar: AppBar(
        title: const Text('Product'),
      ),
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
            return GridView.builder(
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
                  // Show product details using the _showProductDetails method
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


            //         return ListView.builder(
            //             itemCount: snapshot.data!.length,
            //             itemBuilder: (_, index) => Container(
            //                     margin: const EdgeInsets.symmetric(
            //                         horizontal: 16, vertical: 12),
            //                     padding: const EdgeInsets.all(20.0),
            //                     child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                         Text(
            //                         "${snapshot.data![index].fields.title}",
            //                         style: const TextStyle(
            //                             fontSize: 18.0,
            //                             fontWeight: FontWeight.bold,
            //                         ),
            //                         ),
            //                         const SizedBox(height: 10),
            //                         Image.network("${snapshot.data![index].fields.imageUrl}"),

            //                         const SizedBox(height: 10),
            //                         Text(
            //                             "${snapshot.data![index].fields.content}")
            //                     ],
            //                     ),
            //                 ));
            //         }
            //     }
            // }));
    //}

// void _showProductDetails(BuildContext context, Scroll scroll) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text(scroll.title),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(scroll.content),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// class ProductListPage extends StatelessWidget {
//   static List<Scroll> scrolls = [];

//   ProductListPage({Key? key}) : super(key: key);
//   Future<List<Scroll>> fetchProduct(request) async {
//     var response = await request.get(
//       'http://localhost:8000/spell_book/show_scroll/',
//     );
//     List<Scroll> listScrolls = [];
    
//     for (var d in response) {
  
//       if (d != null) {
//         listScrolls.add(Scroll.fromJson(d));
//       }
//     }
//     return listScrolls;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Creators Book"),
//         backgroundColor: Colors.indigo[900], // Adjust the color to match PNG
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.menu), // Change to your menu icon
//             onPressed: () {
//               // Open drawer or do something else
//             },
//           ),
//         ],
//       ),
//        body: FutureBuilder(
//         future: fetchProduct(request),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return const Center(child: CircularProgressIndicator());
//           } else if(snapshot.data!.length == 0){
//             return GridView.builder(
//               padding: const EdgeInsets.all(16.0),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 10.0,
//                 childAspectRatio: 0.6,
//               ),
//               itemCount: scrolls.length,
//               itemBuilder: (context, index) {
//                 Scroll scroll = snapshot.data![index];
//                 return GestureDetector(
//                   onTap: () {
//                     _showProductDetails(context, scroll);
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     elevation: 5.0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(25.0),
//                               child: Image.network(
//                                 scroll.imageUrl,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             scroll.title,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else{
//             return GridView.builder(
//               padding: const EdgeInsets.all(16.0),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 10.0,
//                 childAspectRatio: 0.6,
//               ),
//               itemCount: scrolls.length,
//               itemBuilder: (context, index) {
//                 Scroll scroll = snapshot.data![index];
//                 return GestureDetector(
//                   onTap: () {
//                     _showProductDetails(context, scroll);
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                     elevation: 5.0,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(25.0),
//                               child: Image.network(
//                                 scroll.imageUrl,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             scroll.title,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       drawer: const LeftDrawer(),
//     );
//   }
// 