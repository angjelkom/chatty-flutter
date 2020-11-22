import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:chatty_flutter/entities/conversation.dart';
import 'package:chatty_flutter/entities/message.dart';
import 'package:chatty_flutter/providers/graphql.dart';
import 'package:chatty_flutter/constants/queries.dart' as queries;
import 'package:chatty_flutter/constants/mutations.dart' as mutations;
import 'package:graphql/client.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart';

class ConversationsProvider extends GraphQLProvider {
//  Map<String, Conversation> _conversations = {};
//  Map<String, Conversation> get conversations => _conversations;
  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  Conversation _active;
  Conversation get active => _active;
  Function _onNewMessage;
  List<Map<String, MultipartFile>> _uploadFiles;
  bool _openEmoji = false;
  bool get openEmoji => _openEmoji;

  ConversationsProvider() {
    fetchConversations();
    listenForConversation();
  }

  uploadFiles() async {
    final List<Asset> uploadFiles = await MultiImagePicker.pickImages(
      maxImages: 3,
      cupertinoOptions: CupertinoOptions(
        selectionFillColor: "#ff11ab",
        selectionTextColor: "#ffffff",
        selectionCharacter: "✓",
      ),
    );

    _uploadFiles = await Future.wait(uploadFiles.map((file) async {
      ByteData byteData = await file.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      ByteData thumbByteData = await file.getThumbByteData(300, 300);
      List<int> thumbData = thumbByteData.buffer.asUint8List();

      return {
        'thumbnail':
            MultipartFile.fromBytes('photo', thumbData, filename: file.name),
        'file': MultipartFile.fromBytes('photo', imageData, filename: file.name)
      };
    }));
  }

  void fetchConversations() async {
    final result = await query(query: queries.CONVERSATIONS);
    if (!result.hasException && !result.loading && result.data != null) {
      if (result.data['conversations'] != null) {
        _conversations = (result.data['conversations'] as List)
            .map((e) => Conversation.fromJson(e))
            .toList();
//        _conversations = new Map.fromIterable(result.data['conversations'], key: (v) => v['_id'], value: (v) => Conversation.fromJson(v));
        listenForMessage();
        notifyListeners();
      }
    }
  }

  void delete(id) {
    mutate(
      mutation: mutations.DELETE_CONVERSATION,
      variables: {'id': id},
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['deleteConversation'] != null) {
          if (resultData['deleteConversation']['success'] != null) {
            _conversations.removeWhere((conversation) => conversation.id == id);
            notifyListeners();
          }
        }
      },
      onError: (error) => print(error.toString()),
    );
  }

  void setActive(Conversation _c) {
    _active = _c;
    notifyListeners();
  }

  void listenForMessage() {
    _conversations.forEach((conversation) => _listenForMessage(conversation));
  }

//   void _listenForMessage(Conversation _conversation){
//     subscribe(
//           subscription: mutations.LISTEN_MESSAGE,
//           operationName: 'MessageSubscribe',
//           variables: {
//             'id': _conversation.id
//           },
//           listener: (event){
//             if(event.data != null && event.data['message'] != null){
//               final _message = Message.fromJson(event.data['message']);
//               if(_message.sender.id != userId){
//                 _conversation.messages.add(_message);
//                 _conversations.map((e) => e.id == _conversation.id ? _conversation : e);
//                 print('on new message');
//                 if(_onNewMessage != null){
// _onNewMessage(_message.content);
//                 }

//               }

//               notifyListeners();
//             }
//             print(event);
//           }
//       );
//   }

  // void listenForConversation() async {
  //   subscribe(
  //         subscription: mutations.LISTEN_CONVERSATION,
  //         operationName: 'ConversationSubscribe',
  //         variables: {
  //           'id': await getUserId()
  //         },
  //         listener: (event){
  //           if(event.data != null && event.data['conversation'] != null){
  //             final _conversation = Conversation.fromJson(event.data['conversation']);
  //             _conversations.add(_conversation);
  //             listenForData(conversation: _conversation);
  //             notifyListeners();
  //           }
  //           print(event);
  //         }
  //     );
  // }

  void _listenForMessage(conversation) async {
    subscribe(
        subscription: mutations.LISTEN_DATA,
        operationName: 'DataSubscribe',
        variables: {'id': conversation.id},
        listener: (event) {
          if (event.data != null && event.data['data'] != null) {
            var _data = event.data['data'];
            if (_data['message'] != null) {
              final _message = Message.fromJson(_data['message']);
              if (_message.sender.id != userId) {
                conversation.messages.add(_message);
                _conversations
                    .map((e) => e.id == conversation.id ? conversation : e);
                print('on new message');
                if (_onNewMessage != null) {
                  _onNewMessage(_message.content);
                }
                notifyListeners();
              }
            }
          }
          print(event);
        });
  }

  void listenForConversation() async {
    subscribe(
        subscription: mutations.LISTEN_DATA,
        operationName: 'DataSubscribe',
        variables: {'id': await getUserId()},
        listener: (event) {
          if (event.data != null && event.data['data'] != null) {
            var _data = event.data['data'];
            if (_data['conversation'] != null) {
              final _conversation =
                  Conversation.fromJson(_data['conversation']);
              if (_data['update']) {
                _conversations
                    .map((e) => e.id == _conversation.id ? _conversation : e);
              } else {
                _conversations.add(_conversation);
              }
              _listenForMessage(_conversation);
              notifyListeners();
            }
          }
          print(event);
        });
  }

  void onNewMessage(_callback) {
    _onNewMessage = _callback;
  }

//  void fetchAll(cId) async {
//    final result = await query(query: queries.MESSAGES, variables: {
//      'id': cId
//    });
//
//    if(!result.hasException && !result.loading && result.data != null){
//      if(result.data['messages'] != null){
//        _messages = (result.data['messages'] as List).map((e) => Message.fromJson(e)).toList();
//        notifyListeners();
//      }
//    }
//  }

  send(String content, String cId) {
    mutate(
      mutation: mutations.SEND_MESSAGE,
      variables: {
        'content': content,
        'files': _uploadFiles,
        'conversation': cId
      },
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['sendMessage'] != null) {
          _active.messages.add(Message.fromJson(resultData['sendMessage']));
          notifyListeners();
          _onNewMessage(null);
        }
      },
      onError: (error) => print(error.toString()),
    );
  }

  addConversation(context, List<String> users) {
    mutate(
      mutation: mutations.ADD_CONVERSATION,
      variables: {
        'users': users,
      },
      onUpdate: (Cache cache, QueryResult result) {
        return cache;
      },
      // or do something with the result.data on completion
      onCompleted: (dynamic resultData) async {
        if (resultData != null && resultData['addConversation'] != null) {
          _active = Conversation.fromJson(resultData['addConversation']);
          _conversations.add(_active);
          _listenForMessage(_active);
          notifyListeners();
          Navigator.of(context).pushReplacementNamed('/conversation');
        }
      },
      onError: (error) => print(error.toString()),
    );
  }

  void toggleEmoji() {
    _openEmoji = !_openEmoji;
    notifyListeners();
  }
}
