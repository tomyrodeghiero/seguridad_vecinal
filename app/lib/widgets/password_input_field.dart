import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class PasswordField extends StatefulWidget {
  final bool isLabelFloating;
  final TextEditingController? controller;

  PasswordField({this.isLabelFloating = true, this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: widget.isLabelFloating
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never,
        hintText: widget.isLabelFloating ? null : 'Contraseña',
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.purple500, width: 2.0),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.purple500, width: 2.0),
          borderRadius: BorderRadius.circular(100.0),
        ),
        suffixIcon: IconButton(
          icon: _obscureText
              ? Image.asset('assets/password-not-visible.png', height: 16.0)
              : Image.asset('assets/password-visible.png', height: 15.0),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
