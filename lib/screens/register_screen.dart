import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart'; // Asegúrate de tener este archivo con la definición de los colores
import 'package:seguridad_vecinal/widgets/password_input_field.dart'; // Asegúrate de que este widget esté definido

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.waterGreen300, // Fondo waterGreen300
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Elimina la sombra del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: AppColors.waterGreen400), // Icono con color waterGreen400
          onPressed: () {
            Navigator.of(context).pop(); // Regresa a la pantalla anterior
          },
        ),
        title: Text(
          'Registro de cuenta',
          style: TextStyle(
              color: AppColors.waterGreen400), // Texto con color waterGreen400
        ),
        centerTitle: true, // Centrar el título
      ),
      body: SingleChildScrollView(
        // Asegura que la pantalla sea desplazable cuando el teclado esté visible
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 64.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Ingresa tu mail',
                  labelStyle: TextStyle(color: Colors.grey),
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
                      color: AppColors.waterGreen200,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: AppColors.waterGreen200,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              PasswordField(), // Widget personalizado para el campo de contraseña
              SizedBox(height: 16.0),
              Text(
                '*Debe contener mínimo 6 caracteres, un carácter numérico y no debe ser idéntico al nombre de usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),

              SizedBox(height: 32.0),
              PasswordField(), // Puedes reutilizar este widget para "Verificar contraseña"

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
                    style: TextStyle(
                        color: AppColors
                            .waterGreen300), // Establece el color del texto
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
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.waterGreen300, // Ícono con color waterGreen300
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Posiciona el FAB a la derecha
    );
  }
}
