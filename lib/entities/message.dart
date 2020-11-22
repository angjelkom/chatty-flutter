import 'package:chatty_flutter/entities/chatty_file.dart';
import 'package:chatty_flutter/entities/user.dart';

class Message {
  final String id;
  final String created;
  final String updated;
  final String content;
  final List<ChattyFile> files;
  final User sender;

  Message(
      {this.id,
      this.created,
      this.updated,
      this.content,
      this.files,
      this.sender});

  factory Message.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Message(
      id: json['_id'],
      created: json['created'],
      updated: json['updated'],
      content: json['content'],
      files: json['files']
          ?.map((i) => ChattyFile.fromJson(i))
          ?.toList()
          ?.cast<ChattyFile>(),
      sender: User.fromJson(json['sender']),
    );
  }
}
