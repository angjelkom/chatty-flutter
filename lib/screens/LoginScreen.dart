import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/login.dart';
import 'package:chatty_flutter/widgets/chat_app_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final signup;
  LoginScreen({this.signup}) : super();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var isMobile = width > 768.0;
    return Scaffold(
      appBar: signup ? ChatAppBar() : null,
      body: Center(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(32.0),
            child: Consumer<LoginProvider>(
              builder: (context, provider, _) {
                return Container(
                  constraints:
                      isMobile ? BoxConstraints(maxWidth: 300.0) : null,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (signup) ...[
                          TextField(
                            onChanged: (text) => provider.name = text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              hintStyle: TextStyle(fontSize: 12.0),
                              hintText: 'Name',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  borderSide: BorderSide.none),
                            ),
                            textInputAction: TextInputAction.send,
                          ),
                          SizedBox(height: 16.0),
                        ],
                        TextField(
                          onChanged: (text) => provider.phoneNumber = text,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            hintStyle: TextStyle(fontSize: 12.0),
                            hintText: 'Phone Number',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide.none),
                          ),
                          textInputAction: TextInputAction.send,
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          onChanged: (text) => provider.password = text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            hintStyle: TextStyle(fontSize: 12.0),
                            hintText: 'Password',
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide.none),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.send,
                        ),
                        if (!signup) ...[
                          SizedBox(height: 16.0),
                          RaisedButton(
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(32.0),
                              ),
                              onPressed: () => provider.login(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                              )),
                        ],
                        SizedBox(height: 16.0),
                        RaisedButton(
                            color: Colors.pinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(32.0),
                            ),
                            onPressed: () {
                              print('Signup');
                              if (signup) {
                                provider.signup(context);
                              } else {
                                Navigator.of(context).pushNamed('/signup');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Signup',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ]),
                );
              },
            )),
      ),
    );
  }
}
