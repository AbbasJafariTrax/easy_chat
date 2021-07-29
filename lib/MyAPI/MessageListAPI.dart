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
  Map<String, dynamic> _messageList = {};

  Map<String, dynamic> get messageList {
    return _messageList;
  }

  final DBRef = FirebaseDatabase.instance.reference().child('ChatList');

  //TODO Set
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
          .set({
        "message": message,
        "senderId": userId,
        "edited": false,
      });
    } catch (e) {
      print("Mahdi: addContact: error: $e");
    }
  }

  Future<void> deleteSingleMessage({
    String msgId,
    String userId,
    String receiverId,
  }) async {
    String route = "";

    print(
        "Mahdi: deleteSingleMessage: $userId : $receiverId : ${DateTime.now().millisecondsSinceEpoch.toString()}");

    if (userId.compareTo(receiverId) == -1) {
      route = userId + receiverId;
    } else {
      route = receiverId + userId;
    }
    try {
      await DBRef.child(route).child(msgId).remove();
    } catch (e) {
      print("Mahdi: deleteSingleMessage: error: $e");
    }
  }

  Future<void> editSingleMessage({
    String msgId,
    String userId,
    String receiverId,
    String senderId,
    String msg,
  }) async {
    String route = "";

    print(
        "Mahdi: editSingleMessage: $userId : $receiverId : ${DateTime.now().millisecondsSinceEpoch.toString()}");

    if (userId.compareTo(receiverId) == -1) {
      route = userId + receiverId;
    } else {
      route = receiverId + userId;
    }
    try {
      await DBRef.child(route).child(msgId).set({
        "message": msg,
        "senderId": senderId,
        "edited": true,
      });
    } catch (e) {
      print("Mahdi: editSingleMessage: error: $e");
    }
  }

  //TODO get and listen
  Future<MessageListListener> getAllMessage({
    String userId,
    String receiverId,
  }) async {
    try {
      String route = "";

      print("Mahdi: getAllMessage: $userId : $receiverId");

      if (_messageList.isNotEmpty) {
        _messageList.clear();
      }

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
                    "edited": value["edited"],
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

      print("Mahdi: messageAddListener: $userId : $receiverId");

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
                  "edited": event.snapshot.value["edited"],
                });
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: messageAddListener: error: $e");
    }
  }

  void messageDeleteListener({String userId, String receiverId}) {
    try {
      String route = "";

      print("Mahdi: messageDeleteListener: $userId : $receiverId");

      if (userId.compareTo(receiverId) == -1) {
        route = userId + receiverId;
      } else {
        route = receiverId + userId;
      }

      DBRef.child(route).onChildRemoved.listen((event) {
        print(
            "Mahdi: messageDeleteListener 1 ${event.snapshot.key} : ${event.snapshot.value}");
        print("Mahdi: messageDeleteListener 2 ${DBRef.child(route).path}");

        _messageList.remove(event.snapshot.key);
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: messageAddListener: error: $e");
    }
  }

  void messageEditListener({String userId, String receiverId}) {
    try {
      String route = "";

      print("Mahdi: messageEditListener: $userId : $receiverId");

      if (userId.compareTo(receiverId) == -1) {
        route = userId + receiverId;
      } else {
        route = receiverId + userId;
      }

      DBRef.child(route).onChildChanged.listen((event) {
        print(
            "Mahdi: messageEditListener 1 ${event.snapshot.key} : ${event.snapshot.value}");
        print("Mahdi: messageEditListener 2 ${DBRef.child(route).path}");

        if (_messageList.containsKey(event.snapshot.key)) {
          _messageList[event.snapshot.key] = {
            "message": event.snapshot.value["message"],
            "senderId": event.snapshot.value["senderId"],
            "edited": event.snapshot.value["edited"],
          };
        }
        notifyListeners();
      });
    } catch (e) {
      print("Mahdi: messageEditListener: error: $e");
    }
  }
}
