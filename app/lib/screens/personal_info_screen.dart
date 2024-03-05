import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cori/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  String? selectedGender;
  String? selectedNeighborhood;
  final _formKey = GlobalKey<FormState>();
  XFile? _imageSelected;

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImageFromGallery() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _imageSelected = image;
      });
    }

    Future<void> _takePicture() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      setState(() {
        _imageSelected = image;
      });
    }

    final Map<String, dynamic> registrationData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final String email = registrationData['email'] ?? 'No proporcionado';
    final String password = registrationData['password'] ?? 'No proporcionado';

    void _registerUser() async {
      if (_formKey.currentState!.validate()) {
        if (_imageSelected == null) {
          Fluttertoast.showToast(
            msg: "⚠️ Por favor, agrega una imagen para continuar",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          return;
        }

        var uri =
            Uri.parse('https://cori-backend.vercel.app/api/register-user');
        var request = http.MultipartRequest('POST', uri);

        request.fields['email'] = email;
        request.fields['fullName'] = fullNameController.text;
        request.fields['password'] = password;
        request.fields['neighborhood'] = selectedNeighborhood ?? '';
        request.fields['gender'] = selectedGender ?? '';
        request.fields['age'] = ageController.text;

        if (_imageSelected != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            _imageSelected!.path,
            contentType: MediaType('image', basename(_imageSelected!.path)),
          ));
        }

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final userData = data['data'];
          await prefs.setString('userEmail', userData['userEmail'] ?? '');
          await prefs.setString('fullName', userData['fullName'] ?? '');
          await prefs.setString('imageUrl', userData['imageUrl'] ?? '');

          Fluttertoast.showToast(
            msg: "✅ Usuario registrado con éxito",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          Navigator.of(context).pushNamed('/onboarding');
        } else {
          Fluttertoast.showToast(
            msg: "❌ Error al registrar el usuario.",
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
                          width: 1.0,
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
                  controller: fullNameController,
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
                                      vertical: 10.0, horizontal: 8.0),
                                ),
                              ),
                              child: DropdownButtonFormField<String>(
                                borderRadius: BorderRadius.circular(20.0),
                                decoration: InputDecoration(),
                                hint: Text('F | M | O',
                                    style: TextStyle(color: Colors.grey)),
                                value: selectedGender,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: Colors.purple),
                                items: <String>[
                                  '♀️ Femenino',
                                  '♂️ Masculino',
                                  '⚥ No decir'
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
                    'Barrio Jardín',
                    'Banda Norte',
                    'Bimaco',
                    'Micro centro',
                    'Otro',
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
                    hintText: 'Ej. 358 513 556 4',
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
                    hintText: 'Ej. 358 511 554 8',
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
