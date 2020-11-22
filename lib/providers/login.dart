import 'package:flutter/cupertino.dart';
import 'package:chatty_flutter/providers/graphql.dart';
import 'package:graphql/client.dart';
import 'package:chatty_flutter/constants/mutations.dart' as mutations;

class LoginProvider extends GraphQLProvider {
  String _name = '';
  String _phoneNumber = '';
  String _password = '';

  set name(String n) {
    _name = n;
    notifyListeners();
  }

  set phoneNumber(String num) {
    _phoneNumber = num;
    notifyListeners();
  }

  set password(String pwd) {
    _password = pwd;
    notifyListeners();
  }

  void login(context) async {
    mutate(
      mutation: mutations.LOGIN,
      variables: {
        'phoneNumber': _phoneNumber.trim(),
        'password': _password.trim()
      },
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['login'] != null) {
          await setData(resultData['login']);
          Navigator.of(context).pushReplacementNamed('/conversations');
        }
      },
      onError: (error) => print(error.toString()),
    );
  }

  void signup(context) async {
    mutate(
      mutation: mutations.SIGNUP,
      variables: {
        'name': _name.trim(),
        'phoneNumber': _phoneNumber.trim(),
        'password': _password.trim()
      },
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['signup'] != null) {
          await setData(resultData['signup']);
          Navigator.of(context).pushReplacementNamed('/conversations');
        }
      },
      onError: (error) => print(error.toString()),
    );
  }
}
