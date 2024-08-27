import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.color,
    this.onPressed,
    this.text,
    this.icon,
  });
  Function()? onPressed;
  String? text;
  Color? color;
  IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "${text!}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
