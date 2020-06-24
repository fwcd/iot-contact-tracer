import 'package:flutter/material.dart';

class NumberListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final double value;
  final Function(double value) onEditingComplete;

  NumberListTile({Key key, this.title, this.subtitle, this.value, this.onEditingComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(
      text: '$value',
    );
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: Container(
        width: 80.0,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onEditingComplete: () {
            onEditingComplete(double.parse(controller.text));
            FocusScope.of(context).unfocus();
          }
        )
      )
    );
  }
}
