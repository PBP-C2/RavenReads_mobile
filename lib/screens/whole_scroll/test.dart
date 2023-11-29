import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WhollScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 423,
          height: 911,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF1A2857),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 115,
                child: Container(
                  width: 424,
                  height: 818,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 19,
                        offset: Offset(0, -10),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 240,
                child: Container(
                  width: 333,
                  height: 51,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 388,
                child: Container(
                  width: 333,
                  height: 51,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 256,
                child: SizedBox(
                  width: 105,
                  child: Text(
                    'Title',
                    style: TextStyle(
                      color: Color(0xFFB5B0B0),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0.07,
                      letterSpacing: 0.09,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 403,
                child: SizedBox(
                  width: 105,
                  child: Text(
                    'Your book',
                    style: TextStyle(
                      color: Color(0xFFB5B0B0),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0.07,
                      letterSpacing: 0.09,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 312,
                child: Container(
                  width: 333,
                  height: 51,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 327,
                child: SizedBox(
                  width: 105,
                  child: Text(
                    'Image URL',
                    style: TextStyle(
                      color: Color(0xFFB5B0B0),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 0.07,
                      letterSpacing: 0.09,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 193,
                top: 35,
                child: SizedBox(
                  width: 203,
                  height: 58,
                  child: Text(
                    'WholeScroll',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0.03,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 158,
                child: SizedBox(
                  width: 203,
                  height: 58,
                  child: Text(
                    'Make My Own Book',
                    style: TextStyle(
                      color: Color(0xFF1A2857),
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0.03,
                      letterSpacing: -0.41,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 31,
                top: 43,
                child: Container(
                  width: 43,
                  height: 45,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Colors.white, Colors.white],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(1, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 58,
                child: Container(
                  width: 27,
                  height: 3,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1A2857),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 73,
                child: Container(
                  width: 27,
                  height: 3,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1A2857),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 65,
                child: Container(
                  width: 27,
                  height: 3,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1A2857),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}