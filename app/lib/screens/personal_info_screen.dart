import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? selectedGender;
  String?
      selectedNeighborhood; // Asumiendo que tienes esta variable para el barrio
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> registrationData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final String email = registrationData['email'] ?? 'No proporcionado';
    final String password = registrationData['password'] ?? 'No proporcionado';

    void _registerUser() async {
      if (_formKey.currentState!.validate()) {
        final String contactPhone1 = '';
        final String contactPhone2 = '';
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5001/api/register-user'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'email': email,
            'password': password,
            'neighborhood': selectedNeighborhood,
            'gender': selectedGender,
            'age': int.tryParse(ageController.text) ?? 0,
            'contactPhone': [contactPhone1, contactPhone2],
          }),
        );

        if (response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: "Usuario registrado con éxito",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pushNamed('/home');
        } else {
          Fluttertoast.showToast(
            msg: "Error al registrar el usuario: ${response.body}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Por favor, completa todos los campos obligatorios",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }

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
          child: Form(
            key: _formKey,
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
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
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
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
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '⚠️ Ingresar el nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Ej. Luciana Gonzales',
                    hintStyle: TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(color: AppColors.purple500),
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
                                color: AppColors.purple500, width: 1.0),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                              ),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(),
                              hint: Text('F | M | O',
                                  style: TextStyle(color: Colors.grey)),
                              value: selectedGender,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: Colors.purple),
                              items: <String>[
                                'Femenino',
                                'Masculino',
                                'No decir'
                              ].map((String value) {
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '⚠️ Por favor, selecciona tu género';
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                              color: AppColors.purple500, width: 1.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: ageController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: '18',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0),
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
                  items: <String>[
                    'Alberdi',
                    'Bimaco',
                    'Banda Norte',
                    'Micro centro',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                SizedBox(height: 20.0),
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
                    style:
                        TextStyle(color: AppColors.purple500, fontSize: 16.0),
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
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: _registerUser,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.purple500,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
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
