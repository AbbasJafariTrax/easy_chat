import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MProgressDialog.dart';
import 'package:easy_chat/Const/MToast.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/MessageListAPI.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ChatItemML extends StatefulWidget {
  final String message;
  final String msgId;
  final String userId;
  final String receiverId;
  final bool isMe;

  ChatItemML({
    Key key,
    this.message,
    this.isMe,
    this.msgId,
    this.userId,
    this.receiverId,
  }) : super(key: key);

  @override
  _ChatItemMLState createState() => _ChatItemMLState();
}

class _ChatItemMLState extends State<ChatItemML> {
  var _tapPosition;
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = ProgressDialog(context);
  }

  void _showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      context: context,
      color: btnColor,
      items: [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black.withOpacity(0.5)),
              SizedBox(width: 5),
              Text(
                'Edit',
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.black.withOpacity(0.5)),
              SizedBox(width: 5),
              Text(
                'Delete',
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ],
      position: RelativeRect.fromRect(
        _tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
    ).then<void>((int delta) {
      if (delta == null)
        return;
      else if (delta == 1) {
        mProgressDialog(pr: pr, msg: "Deleting Message");
        pr.show();
        Provider.of<MessageListListener>(context, listen: false)
            .deleteSingleMessage(
          msgId: widget.msgId,
          receiverId: widget.receiverId,
          userId: widget.userId,
        )
            .whenComplete(() {
          if (pr.isShowing()) pr.hide();
          mToast(msg: "Message Deleted");
        });
      }
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isMe ? _showCustomMenu : null,
      onTapDown: _storePosition,
      child: Directionality(
        textDirection: widget.isMe ? TextDirection.rtl : TextDirection.ltr,
        child: Row(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(
                mediaQuery(context).height * 0.01,
              ),
              child: Container(
                padding: EdgeInsets.all(
                  mediaQuery(context).height * 0.01,
                ),
                constraints: BoxConstraints(
                  minWidth: mediaQuery(context).width * 0.1,
                  maxWidth: mediaQuery(context).width * 0.9,
                  minHeight: mediaQuery(context).height * 0.03,
                  maxHeight: mediaQuery(context).height,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(widget.isMe ? 0 : 5),
                    topLeft: Radius.circular(widget.isMe ? 5 : 0),
                    // topLeft: Radius.circular(5),
                  ),
                  color: widget.isMe ? btnColor : Colors.white,
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
