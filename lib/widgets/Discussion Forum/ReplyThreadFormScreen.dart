import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:raven_reads_mobile/main.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';


class ReplyThreadFormScreen extends StatefulWidget {
    final int main_thread_id;
    const ReplyThreadFormScreen({super.key, required this.main_thread_id});

    @override
    State<ReplyThreadFormScreen> createState() => _ReplyThreadFormScreenState();
}

class _ReplyThreadFormScreenState extends State<ReplyThreadFormScreen> {

  final _formKey = GlobalKey<FormState>();
  String _content = "";
    @override
    Widget build(BuildContext context) {
        final userProvider = Provider.of<UserProvider>(context);
        final id = userProvider.user?.id ?? 0;
        final request = context.watch<CookieRequest>();
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Form Tambah Produk',
              ),
            ),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Content",
                          labelText: "Content",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _content = value!;
                          });
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Title tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.indigo),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                                final response = await request.postJson(
                                "http://127.0.0.1:8000/reply_discussion_flutter/",
                                jsonEncode(<String, String>{
                                    'user_id': id.toString(),
                                    'main_thread_id': widget.main_thread_id.toString(),
                                    'content': _content,
                                }));
                                if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                    content: Text("Produk baru berhasil disimpan!"),
                                    ));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHomePage(title: "Raven Reads Mobile")),
                                    );
                                } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content:
                                            Text("Terdapat kesalahan, silakan coba lagi."),
                                    ));
                                }
                            }
                        },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
              ),
            ),
          ),
        );
    }
}