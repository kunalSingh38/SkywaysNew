import 'package:flutter/material.dart';


class TextInput extends StatelessWidget {
  const TextInput({
    Key key,
    this.icon,
    this.hint,
    this.inputType,
    this.inputAction,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 45.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300].withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            border: InputBorder.none,
            hintText: hint,
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                icon,
                color: Colors.grey[500].withOpacity(0.5),
                size: 24,
              ),
            ),
            hintStyle: TextStyle(),
          ),
          style: TextStyle(),
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}