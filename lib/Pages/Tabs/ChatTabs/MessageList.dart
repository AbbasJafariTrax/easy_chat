import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MProgressDialog.dart';
import 'package:easy_chat/Const/MToast.dart';
import 'package:easy_chat/Const/MyConnectionError.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/MessageListAPI.dart';
import 'package:easy_chat/Widgets/ChatTabsWidget/MessageListWidget/ChatItemML.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  static const routeName = "Message list";

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TextEditingController sendCtrl = TextEditingController();
  FocusNode sendFocus = FocusNode();

  Future<MessageListListener> _mFuture;
  String args;
  bool isLoading = true;
  String mUserId;
  var _tapPosition;
  ProgressDialog pr;
  bool isEdit = false;
  String mSenderId, mMsgId;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sendCtrl.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mUserId = FirebaseAuth.instance.currentUser.uid;
    pr = ProgressDialog(context);

    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context).settings.arguments;

      _mFuture = Provider.of<MessageListListener>(
        context,
        listen: false,
      )
          .getAllMessage(
        receiverId: args,
        userId: mUserId,
      )
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

      //TODO Listener
      Provider.of<MessageListListener>(context, listen: false)
          .messageAddListener(
        receiverId: args,
        userId: mUserId,
      );

      Provider.of<MessageListListener>(context, listen: false)
          .messageDeleteListener(
        receiverId: args,
        userId: mUserId,
      );

      Provider.of<MessageListListener>(context, listen: false)
          .messageEditListener(
        receiverId: args,
        userId: mUserId,
      );
    });
  }

  void _showCustomMenu({String msgId, String msgTxt, String senderId}) {
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
          msgId: msgId,
          receiverId: args,
          userId: mUserId,
        )
            .whenComplete(() {
          if (pr.isShowing()) pr.hide();
          mToast(msg: "Message Deleted");
        });
      } else if (delta == 0) {
        if (!sendFocus.hasFocus) sendFocus.requestFocus();
        sendCtrl.text = msgTxt;
        isEdit = true;
        mSenderId = senderId;
        mMsgId = msgId;
      }
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: btnColor,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  // imageUrl,
                  "assets/images/empty_profile.jpg",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            Text("Name"),
          ],
        ),
      ),
      body: FutureBuilder<MessageListListener>(
        future: _mFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: mediaQuery(context).height * 0.2,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          } else {
            if (snapshot.hasError) {
              return myErrorOccurred(context);
            } else {
              return Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Consumer<MessageListListener>(
                      builder: (BuildContext context, value, Widget child) {
                        List<String> listKeys = [];
                        value.messageList.keys.forEach((element) {
                          listKeys.add(element);
                        });
                        listKeys.sort((a, b) => b.compareTo(a));
                        return ListView.builder(
                          itemCount: value.messageList.length,
                          reverse: true,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: value.messageList[listKeys[index]]
                                          ["senderId"] ==
                                      mUserId
                                  ? () => _showCustomMenu(
                                        msgId: listKeys[index],
                                        msgTxt:
                                            value.messageList[listKeys[index]]
                                                ["message"],
                                        senderId:
                                            value.messageList[listKeys[index]]
                                                ["senderId"],
                                      )
                                  : null,
                              onTapDown: _storePosition,
                              child: ChatItemML(
                                senderId: value.messageList[listKeys[index]]
                                    ["senderId"],
                                message: value.messageList[listKeys[index]]
                                    ["message"],
                                isEdited: value.messageList[listKeys[index]]
                                            ["edited"] ==
                                        true
                                    ? true
                                    : false,
                                msgId: listKeys[index],
                                receiverId: args,
                                userId: mUserId,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    color: btnColor,
                    height: 57,
                    width: mediaQuery(context).width,
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery(context).width * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 45,
                          width: mediaQuery(context).width * 0.85,
                          child: TextField(
                            controller: sendCtrl,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Message...",
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isEdit) {
                              isEdit = false;
                              Provider.of<MessageListListener>(context,
                                      listen: false)
                                  .editSingleMessage(
                                msg: sendCtrl.text,
                                senderId: mSenderId,
                                msgId: mMsgId,
                                userId: mUserId,
                                receiverId: args,
                              );
                            } else {
                              Provider.of<MessageListListener>(
                                context,
                                listen: false,
                              ).sendMessage(
                                userId: mUserId,
                                message: sendCtrl.text,
                                receiverId: args,
                              );
                            }
                            sendCtrl.text = "";
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: mediaQuery(context).width * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}

// class PlusMinusEntry extends PopupMenuEntry<int> {
//   @override
//   double height = 200;
//
//   // height doesn't matter, as long as we are not giving
//   // initialValue to showMenu().
//
//   @override
//   bool represents(int n) => n == 1 || n == -1;
//
//   @override
//   PlusMinusEntryState createState() => PlusMinusEntryState();
// }
//
// class PlusMinusEntryState extends State<PlusMinusEntry> {
//   void _plus1() {
//     // This is how you close the popup menu and return user selection.
//     Navigator.pop<int>(context, 1);
//   }
//
//   void _minus1() {
//     Navigator.pop<int>(context, -1);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Text('+1'),
//         Text('-1'),
//       ],
//     );
//   }
// }

// return SizedBox(
//   width: 10,
//   height: 10,
//   child: Card(
//     // constraints: BoxConstraints(
//     //   // minWidth: 100,
//     //   // maxWidth: 120,
//     //   minHeight: mediaQuery(context).height * 0.03,
//     //   maxHeight: mediaQuery(context).height,
//     // ),
//     // decoration: BoxDecoration(
//     //   borderRadius: BorderRadius.circular(5),
//     // ),
//     color: btnColor,
//     child: Text(
//       "Helo",
//       // loremIpsum,
//       style: TextStyle(color: Colors.black.withOpacity(0.6)),
//     ),
//   ),
// );
