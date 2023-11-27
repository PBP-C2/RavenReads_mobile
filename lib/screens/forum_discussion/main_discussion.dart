import 'package:flutter/material.dart';
import 'package:raven_reads_mobile/widgets/left_drawer.dart';

class MainDiscussion extends StatelessWidget {
  const MainDiscussion({super.key});
  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      title: 'MainDiscussion',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wizardly Discussion'),
        ),
        drawer: const LeftDrawer(),
        body: Align(
          alignment: Alignment.topCenter,
            child: Card(
              margin: EdgeInsets.all(20),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded edges
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Discussion Title',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text('Author : rizkimaul'),
                    SizedBox(height: 7),
                    Text('Some description text for the card...'),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}