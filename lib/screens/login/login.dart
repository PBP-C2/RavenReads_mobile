import 'package:raven_reads_mobile/main.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';
import 'package:raven_reads_mobile/screens/register/register.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:raven_reads_mobile/models/UserProvider.dart';


void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 @override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  final userProvider = Provider.of<UserProvider>(context);
  return Scaffold(
    body: Container(
      color: const Color.fromARGB(255, 79, 116, 221), // Use SingleChildScrollView to avoid overflow when keyboard appears
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: const Color.fromARGB(255, 79, 116, 221),// Top section color
              width: double.infinity,// Increased vertical padding
               padding: const EdgeInsets.symmetric(
                      vertical: 30.0), 
              child: const Text(
                'Welcome to RavenReads!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
          ),
          Flexible(child: 
          Container(
            decoration: BoxDecoration(
                        color: Colors.white, // Bottom section color
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                 // Adjust the size as needed
          SizedBox( 
          height: 0,
          child : Stack(
            alignment: Alignment.center,
            children: [
              // Your logo widget here (e.g., an Image or Container)
              
            ],
          ),
          ),
          const SizedBox(height: 50), // Adjust the size as needed
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () async {
              String username = _usernameController.text;
                String password = _passwordController.text;

                // Cek kredensial
                // Untuk menyambungkan Android emulator dengan Django pada localhost,
                // gunakan URL http://10.0.2.2/
                final response = await request.login(
                    "https://ravenreads-c02-tk.pbp.cs.ui.ac.id/auth/login/",
                    {
                      'username': username,
                      'password': password,
                    });

                if (request.loggedIn) {
                  String message = response['message'];
                  String uname = response['username'];
                  int id = response['id'];
                  userProvider.login(uname, id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: 'Raven Reads')),
                  );
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text("$message Selamat datang, $uname.")));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Login Gagal'),
                      content: Text(response['message']),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
            },
            child: const Text('Sign In'),
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 79, 116, 221), // Adjust the color to match the design
              minimumSize: Size(double.infinity, 36), // Set the size of the button
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
               // Navigate to registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrationPage()),
                );
            },
            child: Text(
              'Register here!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 79, 116, 221), // Adjust the color to match the design
                decoration: TextDecoration.underline,
              ),
            ),
          ),
              ]
            ),
          ),
          ),
        ],
    ),
    )
  );
}

}
