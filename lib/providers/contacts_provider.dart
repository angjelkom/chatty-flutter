import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:chatty_flutter/constants/queries.dart' as queries;
import 'package:chatty_flutter/entities/user.dart';
import 'package:chatty_flutter/providers/graphql.dart';

class ContactsProvider extends GraphQLProvider {
  Iterable<Contact> _contacts = [];
  List<User> _results = [];
  List<User> get results => _results;
  Iterable<Contact> get contacts => _contacts;
  List<String> _selectedUsers = [];
  List<String> get selectedUsers => _selectedUsers;
  Timer _timer;

  ContactsProvider() {
    // getContacts();
  }

  void getContacts() async {
    _contacts = await ContactsService.getContacts();
    notifyListeners();
  }

  void search(text) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 300), () async {
      final result =
          await query(query: queries.SEARCH, variables: {'query': text});
      if (!result.hasException && !result.loading && result.data != null) {
        if (result.data['search'] != null) {
          _results = (result.data['search'] as List)
              .map((e) => User.fromJson(e))
              .toList();
          notifyListeners();
        }
      }
    });
  }

  void select(String id, bool value) {
    value ? _selectedUsers.add(id) : _selectedUsers.remove(id);
    notifyListeners();
  }

  set selectedUsers(users) {
    _selectedUsers = users;
    notifyListeners();
  }
}
