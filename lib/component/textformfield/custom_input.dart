import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  Custominput({
    super.key,
    this.focusNode,
    this.labelText,
    this.onSubmitted,
    this.onEditingComplete,
    this.controller,
  });

  TextEditingController? controller;
  String? labelText;
  Function(String)? onSubmitted;
  Function()? onEditingComplete;
  FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
