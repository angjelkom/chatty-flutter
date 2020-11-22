import 'package:flutter/material.dart';
import 'package:chatty_flutter/constants/colors.dart';

class DatePicker extends StatelessWidget {
  final String value;
  final onChanged;
  final onClear;

  DatePicker({this.value, this.onChanged, this.onClear}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => () async {
        DateTime picker = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: new DateTime(1900),
            lastDate: new DateTime.now());

        if (picker != null) {
          onChanged(picker);
        }
      }(),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding:
            EdgeInsets.only(left: 32.0, top: 8.0, bottom: 8.0, right: 22.0),
        decoration: BoxDecoration(
            gradient: BLUE_GRADIENT, borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'BIRTHDAY',
              // style: TextStyle(letterSpacing: 2.0, fontFamily: 'Montserrat'),
            ),
            Row(children: [
              Text(
                value ?? 'Not set',
                style: TextStyle(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
              IconButton(
                onPressed: onClear,
                icon: Icon(Icons.clear),
              )
            ])
          ],
        ),
      ),
    );
  }
}
