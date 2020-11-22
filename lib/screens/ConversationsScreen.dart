import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/conversations.dart';
import 'package:chatty_flutter/widgets/bottom_bar.dart';
import 'package:chatty_flutter/widgets/chat_app_bar.dart';
import 'package:chatty_flutter/widgets/conversation_item.dart';
import 'package:provider/provider.dart';

class ConversationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        appBar: ChatAppBar(
          middle: Text('Chats'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                })
          ],
        ),
        body: Consumer<ConversationsProvider>(builder: (context, provider, _) {
          return ListView.builder(
              itemCount: provider.conversations.length,
              itemBuilder: (_, i) {
                var conversation = provider.conversations[i];
                return ConversationItem(
                  conversation: conversation,
                  onDelete: () {
                    provider.delete(conversation.id);
                  },
                  onTap: () {
                    provider.setActive(conversation);
                    Navigator.of(context).pushNamed('/conversation');
                  },
                );
              });
        }));
  }
}
