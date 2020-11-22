import 'package:chatty_flutter/entities/user.dart';

import 'message.dart';

class Conversation {
  final String id;
  final String createdAt;
  final String modifiedAt;
  final List<User> users;
  final List<Message> messages;
  final Message lastMessage;

  // Conversation({this.id, this.createdAt, this.modifiedAt, this.users, this.messages, this.lastMessage});
  Conversation(
      {this.id,
      this.createdAt,
      this.modifiedAt,
      this.users,
      this.messages,
      this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var users = (json['users'] as List);
    var messages = (json['messages'] as List);
    return Conversation(
        id: json['_id'],
        createdAt: json['createdAt'],
        modifiedAt: json['modifiedAt'],
        users: users?.map((i) {
          return User.fromJson(i);
        })?.toList(),
        messages: messages?.map((i) => Message.fromJson(i))?.toList(),
        lastMessage: Message.fromJson(json['lastMessage']));
  }
}
