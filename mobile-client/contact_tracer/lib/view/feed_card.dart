import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final Color color;
  final Widget child;

  FeedCard({Key key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: child,
        )
      )
    );
  }
}
