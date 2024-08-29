import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  Custominput({
    super.key,
    this.focusNode,
    this.labelText,
    this.onSubmitted,
    this.onEditingComplete,
    this.controller,
    this.readOnly,
  });

  TextEditingController? controller;
  String? labelText;
  Function(String)? onSubmitted;
  Function()? onEditingComplete;
  FocusNode? focusNode;
  bool? readOnly;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        readOnly: readOnly ?? false,
        enabled: readOnly != null
            ? readOnly!
                ? false
                : true
            : true,
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
