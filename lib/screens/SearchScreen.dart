import 'package:chatty_flutter/constants/other.dart';
import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/contacts_provider.dart';
import 'package:chatty_flutter/providers/conversations.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(builder: (_, provider, __) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 8.0,
            centerTitle: true,
            actions: <Widget>[
              Consumer<ConversationsProvider>(
                builder: (_, _provider, __) {
                  return RawMaterialButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      _provider.addConversation(
                          context, provider.selectedUsers);
                      provider.selectedUsers = [];
                    },
                    constraints: BoxConstraints.tightFor(width: 48.0),
                    child: Text('OK'),
                  );
                },
              )
            ],
            title: IntrinsicHeight(
              child: TextField(
                focusNode: _focusNode,
                onChanged: (text) {
                  provider.search(text);
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  hintStyle: TextStyle(fontSize: 12.0),
                  hintText: 'Search',
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide.none),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 16.0,
                  ),
                ),
              ),
            ),
          ),
          body: Container(
              child: ListView.builder(
                  itemCount: provider.results.length,
                  itemBuilder: (_, i) {
                    var user = provider.results[i];

                    return CheckboxListTile(
                      value: provider.selectedUsers.contains(user.id),
                      secondary: user.profilePhoto == null
                          ? CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text('${user.name[0]}'),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(
                                  '$graphQLEndPoint/${user.profilePhoto}'),
                            ),
                      title: Text('${user.name}'),
                      subtitle: Text('${user.phoneNumber}'),
                      onChanged: (bool value) {
                        provider.select(user.id, value);
                      },
                    );
                  })));
    });
  }
}
