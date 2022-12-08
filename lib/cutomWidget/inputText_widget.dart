import 'package:flutter/material.dart';

class InputText_widget extends StatelessWidget {
  InputText_widget(this.textEditingController,this.textChanged, this.title, this.maxLine, {Key? key})
      : super(key: key);
  TextEditingController? textEditingController;
  final int maxLine;
  final String title;
  final Function(String text) textChanged;

  Widget build(BuildContext context) {
    print("TetEditingcontroller = ${textEditingController?.text}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: textEditingController,
        maxLines: maxLine,
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
