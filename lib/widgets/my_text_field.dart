import 'dart:math';

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
        onTap: ontap,
        controller: textController,
        readOnly: icon == null ? false : true,
        style: TextStyle(color: Colors.black),
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          suffixIcon: icon == null ? null : icon,
          labelText: label,
          labelStyle:
              TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
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

_getDate(context) async {
  DateTime? pickDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2125),
      initialDate: DateTime.now());
  if (pickDate != null) {}
}
