import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart'; // Asumiendo que tus colores personalizados están aquí

class PasswordField extends StatefulWidget {
  final bool isLabelFloating; // Nuevo parámetro

  PasswordField({this.isLabelFloating = true}); // Valor por defecto es true

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: widget.isLabelFloating
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never, // Usar el parámetro aquí
        hintText: widget.isLabelFloating
            ? null
            : 'Contraseña', // Si el label no flota, mostrar el hintText
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
              ? Image.asset('assets/password-not-visible.png',
                  height: 16.0) // Icono cuando la contraseña está oculta
              : Image.asset('assets/password-visible.png',
                  height: 15.0), // Icono cuando la contraseña está visible
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
