
import 'conversation.dart';

class User {
  final String token;
  final String id;
  final String name;
  final String phoneNumber;
  final String birthday;
  final String gender;
  final String profilePhoto;
  final List<Conversation> conversations;

  User({this.token, this.id, this.name, this.phoneNumber, this.conversations, this.birthday, this.gender, this.profilePhoto});

  factory User.fromJson(Map<String, dynamic> json) {
    var conversations = (json['conversations'] as List);
    return User(
      token: json['token'],
      id: json['_id'],
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      profilePhoto: json['profilePhoto'],
      conversations: conversations?.map((i){
        return Conversation.fromJson(i);
      })?.toList(),
    );
  }
}