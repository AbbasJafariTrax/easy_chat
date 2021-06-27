import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MyConnectionError.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/MessageListAPI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  static const routeName = "Message list";

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TextEditingController sendCtrl = TextEditingController();
  Future<MessageListListener> _mFuture;
  String args;
  bool isLoading = true;

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

    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context).settings.arguments;

      Provider.of<MessageListListener>(context, listen: false)
          .messageAddListener(
        receiverId: args,
        userId: FirebaseAuth.instance.currentUser.uid,
      );

      _mFuture = Provider.of<MessageListListener>(
        context,
        listen: false,
      )
          .getAllMessage(
        receiverId: args,
        userId: FirebaseAuth.instance.currentUser.uid,
      )
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    });
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Consumer<MessageListListener>(
                    builder: (BuildContext context, value, Widget child) {
                      List<String> listKeys = [];
                      value.messageList.keys.forEach((element) {
                        listKeys.add(element);
                      });
                      listKeys.sort((a, b) => b.compareTo(a));
                      return Expanded(
                        child: ListView.builder(
                          itemCount: value.messageList.length,
                          reverse: true,
                          itemBuilder: (ctx, index) {
                            return ChatItemML(
                              isMe: value.messageList[listKeys[index]]
                                      ["senderId"] ==
                                  FirebaseAuth.instance.currentUser.uid,
                              message: value.messageList[listKeys[index]]
                                  ["message"],
                            );
                          },
                        ),
                      );
                    },
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
                            Provider.of<MessageListListener>(context,
                                    listen: false)
                                .sendMessage(
                              userId: FirebaseAuth.instance.currentUser.uid,
                              message: sendCtrl.text,
                              receiverId: args,
                            );
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

class ChatItemML extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatItemML({
    Key key,
    this.message,
    this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  topRight: Radius.circular(isMe ? 0 : 5),
                  topLeft: Radius.circular(isMe ? 5 : 0),
                  // topLeft: Radius.circular(5),
                ),
                color: isMe ? btnColor : Colors.white,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
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
