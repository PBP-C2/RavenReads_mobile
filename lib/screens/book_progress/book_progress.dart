import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/ReadingProgress.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookProgressionPage extends StatefulWidget {
  const BookProgressionPage({Key? key}) : super(key: key);

  @override
  _BookProgressionPageState createState() => _BookProgressionPageState();
}

class _BookProgressionPageState extends State<BookProgressionPage> {
  Future<List<ReadingProgress>> fetchProgress() async {
    var url =
        Uri.parse('https://ravenreads-c02-tk.pbp.cs.ui.ac.id/get-progression/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<ReadingProgress> listProgress = [];
    for (var d in data) {
      if (d != null) {
        listProgress.add(ReadingProgress.fromJson(d));
      }
    }
    return listProgress;
  }

  final _bookformKey = GlobalKey<FormState>();
  static List<GlobalKey<FormState>> _reviewformKeys = [];
  static List<ReadingProgress> _listProgress = [];
  List<ReadingProgress> _progresses = List.from(_listProgress);
  Map<int, bool> _isExpanded = {};
  int _lastExpanded = -1;
  bool _dropDownEnabled = false;
  bool _textFieldEnabled = false;
  int _rating = -1;
  String _bookId = "";
  String _review = "";
  String _searchQuery = "";

  void toggleEnabled() {
    _dropDownEnabled = !_dropDownEnabled;
    _textFieldEnabled = !_textFieldEnabled;
  }

  @override
  void initState() {
    super.initState();
    _initReviewFormKeys();
  }

  Future<void> _initReviewFormKeys() async {
    List<ReadingProgress> data = await fetchProgress();
    setState(
      () {
        _reviewformKeys =
            List.generate(data.length, (index) => GlobalKey<FormState>());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Progression'),
        backgroundColor: Color(0xFF00025F),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue[900],
      drawer: LeftDrawer(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search ...",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.indigo[800],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  height: 57,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange[500])),
                    child: const Text(
                      "Add New Book",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Add New Book",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.white,
                            content: Form(
                              key: _bookformKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter book ID",
                                  labelText: "Enter book ID",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    _bookId = value!;
                                  });
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Book ID cannot be empty!";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Book ID has to be integer!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Close",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 65, 227, 70)),
                                  ),
                                  onPressed: () async {
                                    if (_bookformKey.currentState!.validate()) {
                                      final response = await request.postJson(
                                        "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/add-progression/",
                                        jsonEncode(
                                          <String, int>{
                                            "newBook": int.parse(_bookId)
                                          },
                                        ),
                                      );

                                      if (response["status"] == "success") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "The book has been successfully saved!"),
                                          ),
                                        );
                                        setState(() {});
                                      } else if (response["status"] ==
                                          "error") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "The book has already exist in the progress!"),
                                          ),
                                        );
                                      }
                                      _reviewformKeys
                                          .add(new GlobalKey<FormState>());
                                      _bookformKey.currentState!.reset();
                                    }
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            // List
            FutureBuilder(
              future: fetchProgress(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.orange,
                  ));
                } else {
                  if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return const Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "There is no progress data",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    _listProgress = snapshot.data!;
                    _progresses = List.from(_listProgress);
                    if (_searchQuery.isNotEmpty) {
                      _progresses = _listProgress
                          .where((element) => element.fields.title
                              .toLowerCase()
                              .contains(_searchQuery))
                          .toList();
                    }
                    if (_progresses.length == 0) {
                      return const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No matching book",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                        ],
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _progresses.length,
                        itemBuilder: (_, index) {
                          if (!_isExpanded.containsKey(index)) {
                            _isExpanded[index] = false;
                          }
                          return Column(
                            children: [
                              Column(
                                children: [
                                  ListTileTheme(
                                    tileColor: (index % 2 == 0)
                                        ? Colors.blue[50]
                                        : Colors.blueGrey[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: (_isExpanded[index]!)
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            )
                                          : BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        "${_progresses[index].fields.title}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${_progresses[index].fields.progress}/${_progresses[index].fields.pages}",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  final response =
                                                      await request.postJson(
                                                    "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/increment-progress/${_progresses[index].pk}/",
                                                    jsonEncode(
                                                      <String, String>{},
                                                    ),
                                                  );

                                                  if (response["status"] ==
                                                      "success") {
                                                    setState(() {});
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: Colors.blueAccent[700],
                                                ),
                                              )
                                            ],
                                          ),
                                          LinearProgressIndicator(
                                            value: _progresses[index]
                                                    .fields
                                                    .progress /
                                                _progresses[index].fields.pages,
                                            backgroundColor: Colors.grey[400],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color.fromARGB(255, 105, 232, 63),
                                            ),
                                          ),
                                        ],
                                      ),
                                      leading: Container(
                                          width: 40,
                                          child: Image.network(
                                              _progresses[index].fields.image)),
                                      trailing: ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () {
                                              if (_lastExpanded == index) {
                                                _isExpanded[index] =
                                                    !_isExpanded[index]!;
                                                _lastExpanded = -1;
                                              } else {
                                                if (_lastExpanded != -1) {
                                                  _isExpanded[_lastExpanded] =
                                                      false;
                                                }
                                                _isExpanded[index] = true;
                                                _lastExpanded = index;
                                              }
                                              if (_dropDownEnabled) {
                                                toggleEnabled();
                                              }
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blueAccent[700]),
                                        ),
                                        child: Text(
                                          "Review",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_isExpanded[index]!)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        color: (index % 2 == 0)
                                            ? Colors.blue[50]
                                            : Colors.blueGrey[
                                                50], // Replace with your desired color
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Form(
                                          key: _reviewformKeys[index],
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    child: Text(
                                                      "Rating:",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    child:
                                                        DropdownButtonFormField<
                                                            int>(
                                                      value: (_progresses[index]
                                                                  .fields
                                                                  .rating <=
                                                              0)
                                                          ? null
                                                          : _progresses[index]
                                                              .fields
                                                              .rating,
                                                      items: [
                                                        DropdownMenuItem(
                                                          value: 1,
                                                          child: Text(
                                                            "1",
                                                            style: TextStyle(
                                                                color: (_dropDownEnabled)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        600]),
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 2,
                                                          child: Text(
                                                            "2",
                                                            style: TextStyle(
                                                                color: (_dropDownEnabled)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        600]),
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 3,
                                                          child: Text(
                                                            "3",
                                                            style: TextStyle(
                                                                color: (_dropDownEnabled)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        600]),
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 4,
                                                          child: Text(
                                                            "4",
                                                            style: TextStyle(
                                                                color: (_dropDownEnabled)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        600]),
                                                          ),
                                                        ),
                                                        DropdownMenuItem(
                                                          value: 5,
                                                          child: Text(
                                                            "5",
                                                            style: TextStyle(
                                                                color: (_dropDownEnabled)
                                                                    ? Colors
                                                                        .black
                                                                    : Colors.grey[
                                                                        600]),
                                                          ),
                                                        ),
                                                      ],
                                                      onChanged:
                                                          _dropDownEnabled
                                                              ? (value) {
                                                                  setState(() {
                                                                    _rating =
                                                                        value!;
                                                                  });
                                                                }
                                                              : null,
                                                      validator: (int? value) {
                                                        if (value == null ||
                                                            value <= 0) {
                                                          return "Rating cannot be empty!";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 75,
                                                    child: Text(
                                                      "Review:",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      textInputAction:
                                                          TextInputAction
                                                              .newline,
                                                      initialValue:
                                                          _progresses[index]
                                                              .fields
                                                              .review,
                                                      enabled:
                                                          _textFieldEnabled,
                                                      style: TextStyle(
                                                        color:
                                                            (_textFieldEnabled)
                                                                ? Colors.black
                                                                : Colors
                                                                    .grey[600],
                                                        fontSize: 16,
                                                      ),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          _review = value!;
                                                        });
                                                      },
                                                      validator:
                                                          (String? value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      182,
                                                                      181,
                                                                      181)),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        toggleEnabled();
                                                      });
                                                    },
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(Color
                                                                  .fromARGB(
                                                                      255,
                                                                      65,
                                                                      227,
                                                                      70)),
                                                    ),
                                                    onPressed: () async {
                                                      if (_reviewformKeys[index]
                                                          .currentState!
                                                          .validate()) {
                                                        final response =
                                                            await request
                                                                .postJson(
                                                          "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/add-review/${_progresses[index].pk}/",
                                                          jsonEncode(
                                                            <String, String>{
                                                              "rating": _rating
                                                                  .toString(),
                                                              "review": _review,
                                                            },
                                                          ),
                                                        );

                                                        if (response[
                                                                "status"] ==
                                                            "success") {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "New review has been saved!"),
                                                            ),
                                                          );
                                                        }
                                                        if (_dropDownEnabled) {
                                                          toggleEnabled();
                                                        }
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
