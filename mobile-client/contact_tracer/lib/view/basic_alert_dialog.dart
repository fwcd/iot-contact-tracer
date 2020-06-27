import 'package:flutter/material.dart';

class BasicAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  BasicAlertDialog({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
