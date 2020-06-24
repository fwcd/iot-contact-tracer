import 'package:flutter/material.dart';

class NumberListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final double value;
  final Function(double value) onChanged;

  NumberListTile({Key key, this.title, this.subtitle, this.value, this.onChanged}) : super(key: key);

  // TODO: Currently not working due to
  // https://github.com/flutter/flutter/issues/40024

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: Container(
        width: 80.0,
        child: TextField(
          controller: TextEditingController(
            text: "$value"
          ),
          keyboardType: TextInputType.number,
          onChanged: (text) {
            onChanged(double.parse(text));
          }
        )
      )
    );
  }
}
