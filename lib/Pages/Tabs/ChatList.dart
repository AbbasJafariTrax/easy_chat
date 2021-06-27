import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/Const/MyConnectionError.dart';
import 'package:easy_chat/Const/Size.dart';
import 'package:easy_chat/MyAPI/ContactsListAPI.dart';
import 'package:easy_chat/Pages/Auth/SignInPage.dart';
import 'package:easy_chat/Pages/Tabs/MessageList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  static const routeName = "Chat list";

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ContactsList>(context, listen: false).contactAddListener();
    Provider.of<ContactsList>(context, listen: false).contactEditListener();
    // Provider.of<ContactsList>(context, listen: false).contactDeleteListener();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<ContactsList>(context, listen: false).disposeAllListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: btnColor,
        title: Text("Contact List"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: Icon(Icons.exit_to_app, color: Colors.white),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  SignInPage.routeName,
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<ContactsList>(context, listen: false).getAllContacts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
              return Consumer<ContactsList>(
                builder: (BuildContext context, value, Widget child) {
                  List<String> listKeys = [];
                  value.userList.keys.forEach((element) {
                    listKeys.add(element);
                  });
                  print("Mahdi: ChatList: ${value.userList}");
                  return ListView.builder(
                    itemCount: value.userList.length,
                    itemBuilder: (ctx, index) {
                      return FirebaseAuth.instance.currentUser.uid ==
                              listKeys[index]
                          ? SizedBox.shrink()
                          : ContactItems(
                              isAvailable: value.userList[listKeys[index]]
                                  ["isOnline"],
                              contactName: value.userList[listKeys[index]]
                                  ["userName"],
                              imageUrl: "assets/images/empty_profile.jpg",
                              contactId: listKeys[index],
                            );
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

class ContactItems extends StatelessWidget {
  final String imageUrl;
  final bool isAvailable;
  final String contactName;
  final String contactId;

  const ContactItems({
    Key key,
    this.imageUrl,
    this.isAvailable,
    this.contactName,
    this.contactId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          MessageList.routeName,
          arguments: contactId,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery(context).height * 0.02,
          left: mediaQuery(context).height * 0.01,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    imageUrl,
                    // "assets/images/empty_profile.jpg",
                    height: mediaQuery(context).height * 0.08,
                    width: mediaQuery(context).height * 0.08,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(
                        mediaQuery(context).height * 0.02 / 2,
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    height: mediaQuery(context).height * 0.02,
                    width: mediaQuery(context).height * 0.02,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: mediaQuery(context).height * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  contactName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: mediaQuery(context).height * 0.01,
                ),
                Text(
                  isAvailable ? "Available" : "Unavailable",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: txtColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
