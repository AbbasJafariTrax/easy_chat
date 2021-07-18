import 'package:easy_chat/Const/Colors.dart';
import 'package:easy_chat/MyAPI/ContactsListAPI.dart';
import 'package:easy_chat/MyAPI/MessageListAPI.dart';
import 'package:easy_chat/Pages/Auth/SignupPage.dart';
import 'package:easy_chat/Pages/Tabs/ChatTabs/ChatList.dart';
import 'package:easy_chat/Pages/Tabs/ChatTabs/MessageList.dart';
import 'package:easy_chat/Pages/Tabs/TabPages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Pages/Auth/SignInPage.dart';
import './Pages/Auth/MySplashScreen.dart';
import 'TestFile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<ContactsList>(create: (_) => ContactsList()),
        ListenableProvider<MessageListListener>(
            create: (_) => MessageListListener()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User mUser;

  @override
  void initState() {
    super.initState();
    mUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: btnColor,
        primarySwatch: Colors.blue,
      ),
      // home: TabPages(),
      home: mUser != null ? TabPages() : SignInPage(),
      routes: {
        MySplashScreen.routeName: (context) => MySplashScreen(),
        SignUpPage.routeName: (context) => SignUpPage(),
        SignInPage.routeName: (context) => SignInPage(),
        ChatList.routeName: (context) => ChatList(),
        MessageList.routeName: (context) => MessageList(),
      },
    );
  }
}
