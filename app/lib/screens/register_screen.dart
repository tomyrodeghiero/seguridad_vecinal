import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cori/colors.dart';
import 'package:cori/widgets/password_input_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _hasAcceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final email = args?['email'] ?? '';

    void _attemptRegistration() {
      if (_passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "⚠️ Por favor, complete todos los campos de contraseña");
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        Fluttertoast.showToast(msg: "Las contraseñas no coinciden");
        return;
      }

      String pattern = r'^(?=.*[0-9]).{6,}$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(_passwordController.text)) {
        Fluttertoast.showToast(
            msg:
                "La contraseña debe tener al menos 6 caracteres y contener al menos un número",
            timeInSecForIosWeb: 2,
            fontSize: 18.0);
        return;
      }

      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final email = args?['email'] ?? '';
      if (_passwordController.text == email) {
        Fluttertoast.showToast(
            msg: "La contraseña no debe ser idéntica al correo electrónico",
            timeInSecForIosWeb: 2,
            fontSize: 18.0);
        return;
      }

      if (!_hasAcceptedTerms) {
        Fluttertoast.showToast(
            msg: "Debe aceptar los términos y condiciones",
            timeInSecForIosWeb: 2,
            fontSize: 18.0);
        return;
      }

      final Map<String, String> registrationData = {
        'email': email,
        'password': _passwordController.text,
      };

      Navigator.of(context).pushNamed(
        '/personalInfoScreen',
        arguments: registrationData,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.purple500,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back-arrow.png',
            height: 24.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Registro de cuenta',
          style: TextStyle(color: AppColors.purple500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 64.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Mail',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              TextFormField(
                initialValue: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabled: false,
                  hintText: 'Ingresa tu Email',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: AppColors.purple500,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: AppColors.purple500,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Contraseña',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              PasswordField(
                controller: _passwordController,
                isLabelFloating: false,
              ),
              SizedBox(height: 16.0),
              Text(
                '*Debe contener mínimo 6 caracteres, un carácter numérico y no debe ser idéntico al nombre de usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Verificar contraseña',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              PasswordField(
                controller: _confirmPasswordController,
                isLabelFloating: false,
              ),
              SizedBox(height: 48.0),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'Acepta los términos y condiciones de uso y el procesamiento, tratamiento y transferencia de tus datos personales conforme a lo dispuesto en las Política de Privacidad'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: _hasAcceptedTerms
                          ? Colors.white
                          : AppColors.purple500,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _hasAcceptedTerms = !_hasAcceptedTerms;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: _hasAcceptedTerms
                        ? AppColors.turquoiseBlue500
                        : Colors.white,
                    onPrimary: _hasAcceptedTerms
                        ? AppColors.purple500
                        : AppColors.waterGreen300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: _attemptRegistration,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image.asset(
                'assets/forward-arrow.png',
                height: 24.0,
                width: 24.0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
