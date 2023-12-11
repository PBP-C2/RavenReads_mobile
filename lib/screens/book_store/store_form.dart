import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({Key? key});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  int _bookId = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    Future<bool> addBookCheckout(int bookId) async {
      final response = await request.post(
          'http://127.0.0.1:8000/add_book_flutter/', {'book_id': '$bookId'});

      if (response['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Choose Your Best Book',
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
                    hintText: "Enter Your ID Books",
                    labelText: "Books ID",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _bookId = int.tryParse(value ?? '') ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "The input must not be empty";
                    }
                    if (int.tryParse(value) == null) {
                      return "The input must be a number";
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
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final isSuccess = await addBookCheckout(_bookId);
                        if (isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Success to add book to checkout')));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                  'Failed to add book to checkout')));
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
