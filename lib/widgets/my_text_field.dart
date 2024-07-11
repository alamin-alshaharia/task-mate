import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? label;
  final int? maxLines;
  final int? minLines;
  final Icon? icon;

  final TextEditingController? textController;
  final void Function()? ontap;
  MyTextField(
      {this.label,
      this.maxLines = 1,
      this.minLines = 1,
      this.icon,
      this.ontap,
      this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: textController,
        readOnly: icon == null ? false : true,
        style: TextStyle(color: Colors.black),
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: icon == null ? null : icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlueAccent)),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
