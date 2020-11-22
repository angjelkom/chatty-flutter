import 'package:chatty_flutter/constants/other.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:chatty_flutter/entities/conversation.dart';
import 'package:chatty_flutter/entities/user.dart';
import 'package:chatty_flutter/extensions/map_index.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;
  final Function onDelete;
  final Function onTap;

  const ConversationItem(
      {Key key, this.conversation, this.onDelete, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 58.0,
          child: conversation.users.length == 1
              ? getAvatar(conversation.users.first)
              : Stack(
                  alignment: Alignment.topLeft,
                  children: conversation.users.mapIndex((user, i) {
                    return Positioned(
                      left: i == 0 ? 10.0 : 0.0,
                      top: i == 0 ? 0.0 : 10.0,
                      child: getAvatar(user),
                    );
                  }).toList()),
        ),
        title: Text(
          conversation.users.map((user) => user.name).join(', '),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(conversation.messages.length > 0
            ? conversation.messages.last.content
            : 'No Message tap to start conversaion'),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(32.0)),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              )),
          onTap: onDelete,
        )
      ],
    );
  }
}

CircleAvatar getAvatar(User user) {
  return (user.profilePhoto == null
      ? CircleAvatar(
          backgroundColor: Colors.brown.shade800,
          child: Text('${user.name[0]}'),
        )
      : CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage:
              NetworkImage('$graphQLEndPoint/${user.profilePhoto}'),
          radius: 50.0,
        ));
}
