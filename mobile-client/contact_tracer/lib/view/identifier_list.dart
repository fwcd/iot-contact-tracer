import 'package:flutter/material.dart';

class IdentifierList extends StatelessWidget {
  final String title;
  final Function() onClear;
  final List<String> identifiers;

  IdentifierList({this.title, this.onClear, this.identifiers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title),
        Wrap(
          children: identifiers.map((ident) => Chip(
            label: Text(ident)
          )).toList(),
        ),
      ] + (onClear != null ? [
        FlatButton(
          child: Text('Clear'),
          onPressed: onClear,
        )
      ] : []),
    );
  }
}
