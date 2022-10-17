import 'package:flutter/material.dart';

class PasswordTextInput extends StatefulWidget {

  bool isHidden;
  final TextEditingController passwordController;
  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;

  PasswordTextInput({Key key, this.isHidden, this.passwordController, this.inputType, this.icon, this.hint, this.inputAction}): super(key: key);

  @override
  _PasswordTextInputState createState() => _PasswordTextInputState();
}

class _PasswordTextInputState extends State<PasswordTextInput> {

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: const EdgeInsets.only(right: 8.0, left: 8),
      child: TextFormField(
          obscureText: widget.isHidden,
          controller: widget.passwordController,
          keyboardType: widget.inputType,
          cursorColor: Color(0xff000000),
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
          decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    widget.isHidden = !widget.isHidden;
                  });
                },
                child: Icon(
                    widget.isHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black87),
              ),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(10, 30, 30, 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Color(0xffbfbfbf),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Color(0xffbfbfbf),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Color(0xffbfbfbf),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Color(0xffbfbfbf),
                ),
              ),
              hintText: 'Password',
              hintStyle:
              TextStyle(color: Color(0xff656565), fontSize: 16),
              fillColor: Color(0xffffffff),
              filled: true)),
    );
  }
}
