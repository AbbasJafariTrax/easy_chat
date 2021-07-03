import 'dart:ui';

import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MProgressDialog.dart';
import 'package:easy_chat/Const/MToast.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/MessageListAPI.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class ChatItemML extends StatelessWidget {
  final String message;
  final String msgId;
  final String userId;
  final String receiverId;
  final String senderId;
  final bool isEdited;

  ChatItemML({
    Key key,
    this.message,
    this.msgId,
    this.userId,
    this.receiverId,
    this.senderId,
    this.isEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = senderId == userId;
    return Directionality(
      textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(isMe ? 0 : 5),
                  topLeft: Radius.circular(isMe ? 5 : 0),
                  // topLeft: Radius.circular(5),
                ),
                color: isMe ? btnColor : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minWidth: mediaQuery(context).width * 0.1,
                      maxWidth: mediaQuery(context).width * 0.9,
                      minHeight: mediaQuery(context).height * 0.03,
                      maxHeight: mediaQuery(context).height,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  isEdited
                      ? SizedBox(
                          height: mediaQuery(context).height * 0.025,
                          child: Text(
                            "edited",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
