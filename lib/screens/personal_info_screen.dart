import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart'; // Asegúrate de tener este archivo con la definición de los colores

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  String? selectedGender; // null indica que no hay selección inicial
  TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.waterGreen300, // Fondo blanco
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
              SizedBox(height: 16), // Espacio entre los botones
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Subir imagen',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.waterGreen300, // Fondo blanco
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

              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Nombre y apellido',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.waterGreen400,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText:
                      'Ej. Luciana Gonzales', // Texto de ejemplo dentro del campo
                  hintStyle: TextStyle(
                      color: Colors.grey), // Estilo del texto de ejemplo
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                      color: AppColors
                          .waterGreen300), // Estilo de la etiqueta flotante
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.waterGreen300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.waterGreen200, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.waterGreen300, width: 1.0),
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
                            color: AppColors.waterGreen400, width: 1.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('F | M | O',
                              style: TextStyle(color: Colors.grey)),
                          value: selectedGender,
                          icon: Icon(Icons.arrow_drop_down,
                              color: AppColors.waterGreen400),
                          items: <String>['F', 'M', 'O'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: AppColors.waterGreen400)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue;
                            });
                          },
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
                            color: AppColors.waterGreen400, width: 1.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder
                                    .none, // Elimina el borde en todas las situaciones
                                enabledBorder: InputBorder
                                    .none, // Específicamente, cuando el TextField está habilitado
                                focusedBorder: InputBorder
                                    .none, // Cuando el TextField está enfocado
                                hintText: '18',
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical:
                                        10.0), // Ajusta el padding vertical como sea necesario
                              ),
                              style: TextStyle(color: AppColors.waterGreen400),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.waterGreen400),
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
          onTap: () {
            Navigator.of(context).pushNamed('/onboarding'); // Añade esta línea
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.arrow_forward,
              color: AppColors.waterGreen300,
            ),
          ),
        ),
      ),
    );
  }
}
