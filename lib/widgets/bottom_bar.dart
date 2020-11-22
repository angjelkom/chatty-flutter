import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/bottom_navigtation_provider.dart';
import 'package:provider/provider.dart';

Widget bottomBar() {
  return Consumer<BottomNavigationProvider>(
    builder: (context, provider, _) {
      return BottomNavigationBar(
          currentIndex: provider.index,
          onTap: (index) {
            provider.index = index;
            switch (index) {
              case 1:
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/contacts', (Route<dynamic> route) => false);
                break;
              case 2:
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/settings', (Route<dynamic> route) => false);
                break;
              default:
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/conversations', (Route<dynamic> route) => false);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'Conversations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ]);
    },
  );
}
