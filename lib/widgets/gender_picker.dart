import 'package:flutter/material.dart';
import 'package:chatty_flutter/constants/colors.dart';

class GenderPicker extends StatelessWidget {
  final String value;
  final onChanged;

  GenderPicker({this.value, this.onChanged}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(12.0),
          gradient: BLUE_GRADIENT),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'GENDER',
            style: TextStyle(letterSpacing: 2.0, fontFamily: 'Montserrat'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () => onChanged('male'),
                  child: Opacity(
                    opacity: value == 'male' ? 1 : .5,
                    child: Text(
                      'Male',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => onChanged('female'),
                child: Opacity(
                  opacity: value == 'female' ? 1 : .5,
                  child: Text(
                    'Female',
                    style: TextStyle(
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: InkWell(
                  onTap: () => onChanged(''),
                  child: Opacity(
                    opacity: value == null || value == '' ? 1 : .5,
                    child: Text(
                      'None',
                      style: TextStyle(
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
