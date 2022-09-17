import 'package:flutter/material.dart';

class Utils {
  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static showScaffoldNotification(
      {required BuildContext context,
      String title = '',
      String message = '',
      Color textColor = Colors.white,
      Color textColorDescription = Colors.black,
      String type = 'info'}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: type == 'success'
            ? Colors.green
            : type == 'error'
                ? const Color.fromARGB(255, 243, 112, 103)
                : type == 'info'
                    ? Colors.blue
                    : Colors.green,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            message.isNotEmpty
                ? Text(
                    message,
                    style: TextStyle(color: textColorDescription),
                  )
                : Container()
          ],
        )));
  }
}
