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
          icon: Image.asset(
            'assets/back-arrow.png',
            height: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Datos personales',
          style: TextStyle(color: AppColors.purple500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '¡Agrega una imagen!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: AppColors.purple500,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            'Tomar imagen',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.purple500,
                            onPrimary: AppColors.purple500,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        ElevatedButton(
                          child: Text(
                            'Subir imagen',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.purple500,
                            onPrimary: AppColors.purple500,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Nombre y apellido',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.purple500,
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ej. Luciana Gonzales',
                  hintStyle: TextStyle(color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: AppColors.purple500),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0), // Ajusta el padding aquí
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.purple500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
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
                        border:
                            Border.all(color: AppColors.purple500, width: 1.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('F | M | O',
                              style: TextStyle(color: Colors.grey)),
                          value: selectedGender,
                          icon: Icon(Icons.arrow_drop_down,
                              color: AppColors.purple500),
                          items: <String>['Femenino', 'Masculino', 'No decir']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(color: Colors.black)),
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
                        border:
                            Border.all(color: AppColors.purple500, width: 1.0),
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
                              style: TextStyle(color: AppColors.purple500),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.purple500),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

// Agrega un título para el desplegable de Barrio
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Barrio',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.purple500,
                      fontWeight: FontWeight.w500),
                ),
              ),

              // Desplegable para seleccionar el Barrio
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: AppColors.purple500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                ),
                hint: Text('Selecciona tu barrio'),
                items: <String>['Barrio 1', 'Barrio 2', 'Barrio 3']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Añade tu lógica para manejar el cambio de selección
                },
              ),

              SizedBox(height: 20.0),

              // Agrega los campos para Contactos directos
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Contactos directos',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.purple500,
                      fontWeight: FontWeight.w500),
                ),
              ),

              // Primer campo de Contactos directos
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ej. 358 513 5564',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.purple500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 10.0),

// Segundo campo de Contactos directos
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Ej. 358 511 5548',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: AppColors.purple500),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        BorderSide(color: AppColors.purple500, width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 24.0),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(color: AppColors.purple500, fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'Elegir contactos de vínculos cercano para en el caso de enviar una alarma puedan ayudar'),
                  ],
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
                '/onboarding'); // Navega a la pantalla de información personal
          },
          child: Container(
            width: 56, // Tamaño estándar de un FloatingActionButton
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.purple500, // Color de fondo blanco
              borderRadius: BorderRadius.circular(100), // BorderRadius de 100
            ),
            child: Center(
              // Centra el ícono en el Container
              child: Image.asset(
                'assets/forward-arrow.png',
                height: 24.0,
                width: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
