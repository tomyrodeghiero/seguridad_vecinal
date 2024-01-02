import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText:
          _obscureText, // El estado controla si la contraseña es visible o no
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.waterGreen200, width: 2.0),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.waterGreen200, width: 2.0),
          borderRadius: BorderRadius.circular(100.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            // Cambia el ícono basado en la visibilidad de la contraseña
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            // Actualiza el estado al presionar el ícono
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
