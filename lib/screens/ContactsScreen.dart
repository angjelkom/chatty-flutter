import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/contacts_provider.dart';
import 'package:chatty_flutter/widgets/bottom_bar.dart';
import 'package:chatty_flutter/widgets/chat_app_bar.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      appBar: ChatAppBar(
        middle: Text('Contacts'),
      ),
      body: Consumer<ContactsProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
              itemCount: provider.contacts.length,
              itemBuilder: (context, i) {
                var contact = provider.contacts.elementAt(i);
                return ListTile(
                    leading: contact.avatar == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.avatar),
                            radius: 50.0,
                          ),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chat_bubble),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.videocam),
                            onPressed: () {},
                          )
                        ]),
                    title: Text(contact.displayName));
              });
        },
      ),
    );
  }
}
