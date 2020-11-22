import 'package:bubble/bubble.dart';
import 'package:chatty_flutter/constants/other.dart';
import 'package:flutter/material.dart';
import 'package:chatty_flutter/entities/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final bool showAvatar;
  final bool isLoggedUser;

  MessageBubble({this.message, this.showAvatar, this.isLoggedUser});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print("Rebuild for ${widget.message.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var noNip = widget.isLoggedUser || !widget.showAvatar;
    var bubble = Bubble(
      nipOffset: 12.0,
      color: widget.isLoggedUser ? Color(0xff6369D1) : Color(0xffB2FFD6),
      padding: BubbleEdges.all(8.0),
      margin: BubbleEdges.fromLTRB(noNip ? 38.0 : 8.0, 8.0, 8.0, 8.0),
      alignment: widget.isLoggedUser ? Alignment.topRight : Alignment.topLeft,
      nip: noNip ? BubbleNip.no : BubbleNip.leftTop,
      child: widget.message.files != null && widget.message.files.length > 0
          ? Column(
              children: widget.message.files
                  .map((e) => Image.network('$graphQLEndPoint/${e.thumbnail}'))
                  .toList(),
            )
          : Text(
              widget.message.content,
              style: TextStyle(
                  color: widget.isLoggedUser ? Colors.white : Colors.black),
            ),
    );

    if (noNip) {
      return bubble;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.brown.shade800,
              child: Text(
                '${widget.message.sender.name[0]}',
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            bubble
          ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
