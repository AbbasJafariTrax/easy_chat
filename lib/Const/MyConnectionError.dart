import 'package:easy_chat/Const/Size.dart';
import 'package:flutter/material.dart';

Widget myErrorOccurred(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.only(
        top: mediaQuery(context).height * 0.2,
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.signal_cellular_connected_no_internet_4_bar,
            size: mediaQuery(context).height * 0.03,
          ),
          SizedBox(
            height: mediaQuery(context).height * 0.1,
          ),
          Text(
            "انترنت قطع است!",
            textScaleFactor: 1.4,
          )
        ],
      ),
    ),
  );
}
