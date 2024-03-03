import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seguridad_vecinal/colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? selectedGender;
  String? selectedNeighborhood;
  final _formKey = GlobalKey<FormState>();
  XFile? _imageSelected;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImageFromGallery() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageSelected =
            image; // Correctamente actualiza la imagen seleccionada
      });
    }

    Future<void> _takePicture() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      setState(() {
        _imageSelected = image; // Correctamente actualiza la imagen capturada
      });
    }

    final Map<String, dynamic> registrationData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final String email = registrationData['email'] ?? 'No proporcionado';
    final String password = registrationData['password'] ?? 'No proporcionado';

    void _registerUser() async {
      // Verifica si los campos del formulario son válidos
      if (_formKey.currentState!.validate()) {
        // Verifica si los campos obligatorios están llenos
        bool hasName = nameController.text.trim().isNotEmpty;
        bool hasGender = selectedGender != null && selectedGender!.isNotEmpty;
        bool hasAge = ageController.text.trim().isNotEmpty;
        bool hasNeighborhood =
            selectedNeighborhood != null && selectedNeighborhood!.isNotEmpty;

        // Si todos los campos obligatorios están llenos, intenta registrar al usuario
        print("$hasName");
        print("$hasGender");
        print("$hasAge");
        print("$hasNeighborhood");
        if (hasName && hasGender && hasAge && hasNeighborhood) {
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
            }),
          );

          // Si el registro fue exitoso, muestra un toast y navega a la siguiente pantalla
          if (response.statusCode == 201) {
            Fluttertoast.showToast(
              msg: "✅ Usuario registrado con éxito",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.of(context).pushNamed('/onboarding');
          } else {
            Fluttertoast.showToast(
              msg: "❌ Error al registrar el usuario: ${response.body}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          // Si no todos los campos obligatorios están llenos, muestra un toast
          Fluttertoast.showToast(
            msg: "⚠️ Por favor, completa todos los campos obligatorios",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
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
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 132.0,
                      height: 132.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        image: _imageSelected != null
                            ? DecorationImage(
                                image: FileImage(File(_imageSelected!.path)),
                                fit: BoxFit.cover,
                              )
                            : null,
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
                            onPressed: _takePicture,
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
                            onPressed:
                                _pickImageFromGallery, // Usar la función para seleccionar una imagen de la galería
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
                    'Nombre y apellido *',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: AppColors.purple500,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                TextFormField(
                  controller: nameController,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Género *',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.purple500,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Edad *',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.purple500,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
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
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: AppColors.purple500),
                              ],
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
                    'Barrio *',
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
                  value: selectedNeighborhood,
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
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedNeighborhood = newValue;
                    });
                  },
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
