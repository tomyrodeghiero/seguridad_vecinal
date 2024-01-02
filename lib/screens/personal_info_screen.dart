import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart'; // Asegúrate de tener este archivo con la definición de los colores

class PersonalInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String selectedGender = 'F';
    String selectedAge = '18';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.waterGreen400),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Datos personales',
          style: TextStyle(color: AppColors.waterGreen400),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 160.0, // El diámetro del círculo
                height: 160.0, // El diámetro del círculo
                decoration: BoxDecoration(
                  color: Colors.transparent, // Fondo transparente
                  shape: BoxShape.circle, // Forma circular
                  border: Border.all(
                    color: Colors.black, // Color del borde
                    width: 2.0, // Ancho del borde
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0), // Esto agrega padding vertical
                child: Text(
                  '¡Agrega una imagen!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.waterGreen100,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Tomar imagen',
                    style: TextStyle(
                        color: Colors
                            .white), // Establece el color del texto a blanco
                  ),
                  onPressed: () {
                    // Implementa la funcionalidad para tomar una imagen
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        AppColors.waterGreen300, // Color de fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Borde redondeado
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16), // Ajusta el padding aquí
                  ),
                ),
              ),
              SizedBox(height: 16), // Espacio entre los botones
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Subir imagen',
                    style: TextStyle(
                        color: Colors
                            .white), // Establece el color del texto a blanco
                  ),
                  onPressed: () {
                    // Implementa la funcionalidad para subir una imagen
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        AppColors.waterGreen300, // Color de fondo del botón
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Borde redondeado
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16), // Ajusta el padding aquí
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText:
                      'Ej. Luciana Gonzales', // Texto de ejemplo dentro del campo
                  hintStyle: TextStyle(
                      color: Colors.grey), // Estilo del texto de ejemplo
                  labelText: 'Nombre y apellido',
                  labelStyle: TextStyle(
                      color: AppColors
                          .waterGreen300), // Estilo de la etiqueta flotante
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always, // La etiqueta siempre es visible
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.waterGreen300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.waterGreen200, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.waterGreen300, width: 2.0),
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                            color: AppColors.waterGreen300, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedGender,
                          icon: Icon(Icons.arrow_drop_down,
                              color: AppColors.waterGreen300),
                          items: <String>['F', 'M', 'O']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: AppColors.waterGreen300)),
                            );
                          }).toList(),
                          onChanged: (String? value) {},
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                            color: AppColors.waterGreen300, width: 2),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              selectedAge,
                              style: TextStyle(color: AppColors.waterGreen300),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: AppColors.waterGreen300),
                            onPressed: () {
                              // Implement the action when the arrow is tapped
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () {},
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
