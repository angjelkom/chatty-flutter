import 'dart:async';
import 'dart:math';

import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/conversations.dart';
import 'package:chatty_flutter/widgets/chat_app_bar.dart';
import 'package:chatty_flutter/widgets/message_bubble.dart';
import 'package:provider/provider.dart';
import 'package:chatty_flutter/extensions/map_index.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _emojiPickerKey = GlobalKey();
  final _focusNode = FocusNode();
  String query = '';
  Timer _searchTimer;
  Timer _scrollTimer;
  bool _openEmoji = false;

  void onNewMessage(content) {
    print('content');
    if (_scrollController.hasClients &&
        _scrollController.offset + 150.0 >=
            _scrollController.position.maxScrollExtent) {
      _scrollTimer?.cancel();
      _scrollTimer = Timer(
          Duration(milliseconds: 300),
          () => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: new Duration(milliseconds: 200),
                curve: Curves.easeOut,
              ));
    } else if (content != null && _scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(content),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      print(
          "offset = ${_scrollController.offset} max: ${_scrollController.position.maxScrollExtent}");
    });
  }

  void toggleEmoji() {
    setState(() {
      _openEmoji = !_openEmoji || _focusNode.hasFocus;
      FocusScope.of(context).unfocus();
    });
  }

  void search(text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(Duration(seconds: 1), () {
      print("Yeah, this line is printed after 3 seconds");

      setState(() {
        query = text;
      });
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _scrollTimer?.cancel();
    _searchTimer?.cancel();
    _textController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_openEmoji) {
          setState(() {
            _openEmoji = false;
          });
        }
        FocusScope.of(context).unfocus();
      },
      child: Consumer<ConversationsProvider>(
        builder: (_, provider, __) {
          provider.onNewMessage(onNewMessage);

          final RenderBox box =
              _emojiPickerKey.currentContext?.findRenderObject();
          final size = box?.size;

          final _bottomPadding =
              MediaQuery.of(context).viewInsets.bottom - (size?.height ?? 0);

          final _bottomBar = Padding(
            padding: EdgeInsets.all(8.0).copyWith(
                bottom: max(0, _bottomPadding == 0 ? 0 : _bottomPadding + 8.0)),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.photo_library),
                      onPressed: () async {
                        provider.uploadFiles();
                      }),
                  IconButton(
                      icon: Icon(Icons.insert_emoticon),
                      onPressed: () async {
                        toggleEmoji();
                      }),
                  Flexible(
                    child: TextField(
                      autofocus: true,
                      focusNode: _focusNode,
                      controller: _textController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        hintStyle: TextStyle(fontSize: 12.0),
                        hintText: 'Enter Message..',
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100.0),
                            borderSide: BorderSide.none),
                      ),
                      onSubmitted: (value) {
                        provider.send(value, provider.active.id);
                        _textController.clear();
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      textInputAction: TextInputAction.send,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        provider.send(_textController.text, provider.active.id);
                        _textController.clear();
                        FocusScope.of(context).requestFocus(_focusNode);
                      })
                ]),
          );

          return Scaffold(
              key: _scaffoldKey,
              // resizeToAvoidBottomInset: false,
              bottomNavigationBar: BottomAppBar(
                  child: _openEmoji
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            _bottomBar,
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: EmojiPicker(
                                bgColor: Colors.transparent,
                                indicatorColor: Color(0xff46cdcf),
                                rows: 3,
                                columns: 7,
                                numRecommended: 10,
                                key: _emojiPickerKey,
                                onEmojiSelected: (emoji, category) {
                                  print(emoji);
                                  _textController.text += emoji.emoji;
                                  _textController.selection =
                                      TextSelection.collapsed(
                                          offset: _textController.text.length);
                                },
                              ),
                            )
                          ],
                        )
                      : _bottomBar),
              appBar: ChatAppBar(
                middle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      height: 30.0,
                      child: Stack(
                          alignment: Alignment.topLeft,
                          children: provider.active.users.mapIndex((user, i) {
                            return Positioned(
                              left: i == 0 ? 10.0 : 0.0,
                              top: i == 0 ? 0.0 : 10.0,
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.brown.shade800,
                                child: Text(
                                  '${user.name[0]}',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ),
                            );
                          }).toList()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        provider.active.users
                            .map((user) => user.name)
                            .join(', '),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              body: ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.active.messages.length,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (_, i) {
                    var message = provider.active.messages[i];
                    var prevMessage =
                        i == 0 ? null : provider.active.messages[i - 1];

                    return MessageBubble(
                        message: message,
                        showAvatar: i == 0 ||
                            prevMessage.sender.id != message.sender.id,
                        isLoggedUser: message.sender.id == provider.userId);
                  }));
        },
      ),
    );
  }
}
