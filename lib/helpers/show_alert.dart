import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlert( BuildContext context, String title, String subTitle) {
  if ( Platform.isAndroid ) {
    return showDialog(
      context: context, 
      builder: ( _ ) => AlertDialog(
        title: Text(title),
        content: Text(subTitle),
        actions: [
          MaterialButton(
            child: const Text('ok'),
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context)
          )
        ],
      )
    );
  }
  return showCupertinoDialog(
    context: context, 
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subTitle),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    )
  );
}