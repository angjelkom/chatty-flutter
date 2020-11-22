import 'package:flutter/material.dart';
import 'package:chatty_flutter/constants/colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget middle;
  final List<Widget> actions;
  ChatAppBar({this.middle, this.actions});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      decoration: BoxDecoration(gradient: BLUE_GRADIENT),
      child: NavigationToolbar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(Icons.arrow_back_ios),
              )
            : null,
        trailing: actions != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: actions)
            : null,
        centerMiddle: true,
        middle: middle,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
