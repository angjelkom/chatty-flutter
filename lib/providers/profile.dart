import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chatty_flutter/entities/user.dart';
import 'package:chatty_flutter/providers/graphql.dart';
import 'package:graphql/client.dart';
import 'package:chatty_flutter/constants/mutations.dart' as mutations;
import 'package:chatty_flutter/constants/queries.dart' as queries;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

class ProfileProvider extends GraphQLProvider {
  User _user;
  User get user => _user;
  TextEditingController _name = TextEditingController();
  TextEditingController get name => _name;
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController get phoneNumber => _phoneNumber;
  DateTime _birthday;
  String _gender = '';
  String get gender => _gender;
  bool _hasMadeChanges = false;
  bool get hasMadeChanges => _hasMadeChanges;
  MultipartFile _profileUploadPhoto;
  MultipartFile get profileUploadPhoto => _profileUploadPhoto;
  File _profileLocalPhoto;
  File get profileLocalPhoto => _profileLocalPhoto;
  String _profilePhoto;
  String get profilePhoto => _profilePhoto;
  final picker = ImagePicker();

  ProfileProvider() {
    _name.addListener(_controllerListener);
    _phoneNumber.addListener(_controllerListener);

    profile();
  }

  Future pickProfilePhoto() async {
    var _image = await picker.getImage(source: ImageSource.gallery);
    if (_image != null) {
      _profileUploadPhoto = MultipartFile.fromBytes(
          'file', await _image.readAsBytes(),
          filename: basename(_image.path));
      _profileLocalPhoto = File(_image.path);
      _hasMadeChanges = true;
      notifyListeners();
    }
  }

  void _controllerListener() {
    _hasMadeChanges =
        _user.name != _name.text || _user.phoneNumber != _phoneNumber.text;
    notifyListeners();
  }

  set birthday(DateTime bday) {
    _birthday = bday;
    _hasMadeChanges = true;
    notifyListeners();
  }

  set gender(String g) {
    _gender = g;
    _hasMadeChanges = _user.gender != _gender;
    notifyListeners();
  }

  void saveProfile() async {
    Map<String, dynamic> variables = {};
    if (_phoneNumber.text.trim() != user.phoneNumber) {
      variables['phoneNumber'] = _phoneNumber.text.trim();
    }

    if (_name.text.trim() != user.name) {
      variables['name'] = _name.text.trim();
    }

    if (formatBirthday(true) != user.birthday) {
      variables['birthday'] = formatBirthday(true);
    }

    if (_gender != user.gender) {
      variables['gender'] = _gender;
    }

    if (_gender != user.gender) {
      variables['gender'] = _gender;
    }

    if (_profileUploadPhoto != null ||
        _profilePhoto == null && user.profilePhoto != null) {
      variables['profilePhoto'] = _profileUploadPhoto;
    }

    mutate(
      mutation: mutations.SAVE_PROFILE,
      variables: variables,
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['saveProfile'] != null) {
          _user = User.fromJson(resultData['saveProfile']);
          _setChanges();
          notifyListeners();
        }
      },
      onError: (error) => print(error.toString()),
    );
  }

  void profile() async {
    final result = await query(query: queries.PROFILE);
    if (!result.hasException && !result.loading && result.data != null) {
      if (result.data['profile'] != null) {
        _user = User.fromJson(result.data['profile']);
        _setChanges();
        notifyListeners();
      }
    }
  }

  void logout(BuildContext context) async {
    await clearData();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  String formatBirthday(save) {
    return _birthday != null
        ? DateFormat(save ? 'yyyy-MM-dd' : 'd MMM y').format(_birthday)
        : null;
  }

  void _setChanges() {
    _name.text = _user.name;
    _phoneNumber.text = _user.phoneNumber;
    _birthday = _user.birthday != null ? DateTime.parse(_user.birthday) : null;
    _gender = _user.gender;
    _profilePhoto = _user.profilePhoto;
    _profileUploadPhoto = null;
    _hasMadeChanges = false;
    notifyListeners();
  }

  void cancelAll() {
    _setChanges();
  }
}
