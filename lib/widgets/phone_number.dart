import 'package:flutter/material.dart';
import 'package:chatty_flutter/constants/colors.dart';

class PhoneNumber extends StatelessWidget {
  final TextEditingController controller;

  PhoneNumber({this.controller}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => _selectDate(context),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        decoration: BoxDecoration(
            gradient: BLUE_GRADIENT, borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'PHONE NUMBER',
              // style: TextStyle(letterSpacing: 2.0, fontFamily: 'Montserrat'),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                textAlign: TextAlign.end,
                style: TextStyle(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
                keyboardType: TextInputType.phone,
                controller: controller,
              ),
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
