import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class MessageListModel {
  final String senderId;
  final String message;
  final String date;

  MessageListModel({
    this.senderId,
    this.message,
    this.date,
  });
}

class MessageListListener extends ChangeNotifier {
  // StreamSubscription<Event> addListenerVar;
  // StreamSubscription<Event> editListenerVar;
  // StreamSubscription<Event> deleteListenerVar;

  Map<String, dynamic> _messageList = {};

  // List<MessageListModel> _messageList = [];

  Map<String, dynamic> get messageList {
    return _messageList;
  }

  final DBRef = FirebaseDatabase.instance.reference().child('ChatList');

  Future<void> sendMessage({
    String message,
    String userId,
    String receiverId,
  }) async {
    String route = "";

    print(
        "Mahdi: sendMessage: $userId : $receiverId : ${DateTime.now().millisecondsSinceEpoch.toString()}");

    if (userId.compareTo(receiverId) == -1) {
      route = userId + receiverId;
    } else {
      route = receiverId + userId;
    }

    try {
      await DBRef.child(route)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set(
        {
          "message": message,
          "senderId": userId,
        },
      );
    } catch (e) {
      print("Mahdi: addContact: error: $e");
    }
  }

  Future<MessageListListener> getAllMessage(
      {String userId, String receiverId}) async {
    try {
      String route = "";

      print("Mahdi: sendMessage: $userId : $receiverId");

      if (userId.compareTo(receiverId) == -1) {
        route = userId + receiverId;
      } else {
        route = receiverId + userId;
      }
      Map<String, dynamic> _tempMsgList = {};

      await DBRef.child(route).once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          _tempMsgList.putIfAbsent(
              key,
              () => {
                    "message": value["message"],
                    "senderId": value["senderId"],
                  });
        });
      });
      _messageList = _tempMsgList;
      notifyListeners();
    } catch (e) {
      print("Mahdi: getAllMessage: error: $e");
    }
  }

  void messageAddListener({String userId, String receiverId}) {
    try {
      String route = "";

      print("Mahdi: sendMessage: $userId : $receiverId");

      if (userId.compareTo(receiverId) == -1) {
        route = userId + receiverId;
      } else {
        route = receiverId + userId;
      }

      DBRef.child(route).limitToLast(1).onChildAdded.listen((event) {
        print(
            "Mahdi: messageAddListener 1 ${event.snapshot.key} : ${event.snapshot.value}");
        print("Mahdi: messageAddListener 2 ${DBRef.child(route).path}");

        _messageList.putIfAbsent(
            event.snapshot.key,
            () => {
                  "message": event.snapshot.value["message"],
                  "senderId": event.snapshot.value["senderId"],
                });
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: messageAddListener: error: $e");
    }
  }
}
