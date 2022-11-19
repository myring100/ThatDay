import 'package:flutter/material.dart';

class InputText_widget extends StatelessWidget {
  const InputText_widget(this.textChanged, this.title, {Key? key})
      : super(key: key);
  final String title;
  final Function(String text) textChanged;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: title,
          ),
          onChanged: (input) {
            textChanged(input);
          }
      ),
    );
  }
}
