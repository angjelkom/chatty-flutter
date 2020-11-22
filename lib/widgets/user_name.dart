import 'package:flutter/material.dart';
import 'package:chatty_flutter/constants/colors.dart';

class UserName extends StatelessWidget {
  final TextEditingController controller;

  UserName({this.controller}) : super();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => _selectDate(context),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        decoration: BoxDecoration(
            gradient: BLUE_GRADIENT,
            // color: Colors.black45,
            borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'NAME',
              // style: TextStyle(letterSpacing: 2.0, fontFamily: 'Montserrat'),
            ),
            TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 8.0),
                isDense: true,
              ),
              style: TextStyle(
                  letterSpacing: 2.0,
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
              controller: controller,
            )
            // Text(
            //   phoneNumber,
            //   style: TextStyle(
            //       letterSpacing: 2.0,
            //       color: Color(0xff353535),
            //       fontWeight: FontWeight.bold,
            //       fontFamily: 'Montserrat'),
            // )
          ],
        ),
      ),
    );
  }
}
