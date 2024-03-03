import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart'; // Asegúrate de tener este archivo con la definición de los colores
import 'package:seguridad_vecinal/widgets/password_input_field.dart'; // Asegúrate de que este widget esté definido

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Ingresa tu mail',
                  labelStyle: TextStyle(color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .never, // Previene que el label flote
                  hintText:
                      'Ingresa tu mail', // Muestra el texto del label como placeholder
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
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              PasswordField(isLabelFloating: false),
              SizedBox(height: 16.0),
              Text(
                '*Debe contener mínimo 6 caracteres, un carácter numérico y no debe ser idéntico al nombre de usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Verificar contraseña',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              PasswordField(isLabelFloating: false),
              SizedBox(height: 48.0),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
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
                    style:
                        TextStyle(color: AppColors.purple500, fontSize: 16.0),
                  ),
                  onPressed: () {
                    // Aquí manejarías el registro
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Fondo blanco
                    onPrimary: AppColors
                        .waterGreen300, // Color de la letra cuando se presiona el botón
                    elevation: 0, // No sombra
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(100.0), // Borde redondeado
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
          onTap: () {
            Navigator.of(context).pushNamed(
                '/personalInfoScreen'); // Navega a la pantalla de información personal
          },
          child: Container(
            width: 56, // Tamaño estándar de un FloatingActionButton
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo blanco
              borderRadius: BorderRadius.circular(100), // BorderRadius de 100
            ),
            child: Center(
              // Centra el ícono en el Container
              child: Image.asset(
                'assets/forward-arrow.png',
                height: 24.0, // Ajusta el tamaño como sea necesario
                width: 24.0, // Ajusta el tamaño como sea necesario
              ),
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Posiciona el FAB a la derecha
    );
  }
}
