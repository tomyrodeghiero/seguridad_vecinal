import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cori/colors.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  List<XFile>? _imageFileList;
  String? _selectedNeighborhood;
  bool _isLoading = false;

  void _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    setState(() {
      _imageFileList = selectedImages;
    });
  }

  String? _userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  void _loadUserImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userImageUrl = prefs.getString('imageUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Future<void> _publishPost() async {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _isLoading = true;
        });

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userEmail = prefs.getString('userEmail');

        if (userEmail == null) {
          Fluttertoast.showToast(
            msg: "No se encontró el email del usuario.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }

        if (_selectedNeighborhood == null ||
            _textController.text.isEmpty ||
            _messageController.text.isEmpty) {
          _isLoading = false;
          Fluttertoast.showToast(
            msg:
                "Por favor, completa todos los campos requeridos: barrio, título y descripción.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }

        var uri =
            Uri.parse('https://cori-backend.vercel.app/api/create-report');
        var request = http.MultipartRequest('POST', uri);

        request.fields['senderEmail'] = userEmail;
        request.fields['title'] = _textController.text;
        request.fields['message'] = _messageController.text;
        request.fields['neighborhood'] =
            _selectedNeighborhood ?? "No especificado";

        for (var imageFile in _imageFileList ?? []) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            imageFile.path,
            contentType:
                MediaType('image', basename(imageFile.path).split('.').last),
          ));
        }

        if (_messageController.text.isEmpty) {
          Fluttertoast.showToast(
            msg: "El campo de descripción no puede estar vacío.",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        try {
          Navigator.pushNamed(context, "/feedback");

          // var response = await request.send();

          // if (response.statusCode == 200) {
          //   print("Reporte creado con éxito.");

          //   Fluttertoast.showToast(
          //     msg: "¡Gracias! Tu reporte fue creado correctamente.",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 2,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0,
          //   );

          // } else {
          //   print("Falló la creación del reporte.");
          //   Fluttertoast.showToast(
          //     msg: "Error al guardar el reporte, intenta nuevamente.",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0,
          //   );
          // }
        } catch (e) {
          print("Error al enviar el reporte: $e");
          Fluttertoast.showToast(
            msg: "Error al enviar el reporte, verifica tu conexión.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/cancel.png',
            height: 20.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28.0),
                    borderSide: BorderSide(color: AppColors.purple500),
                  ),
                ),
                hint: Text(
                  '¿Dónde sucede?',
                  style: TextStyle(fontSize: 16.0), // Aumentado de 18.0 a 22.0
                ),
                borderRadius: BorderRadius.circular(20.0),
                value: _selectedNeighborhood,
                onChanged: (newValue) {
                  setState(() {
                    _selectedNeighborhood = newValue;
                  });
                },
                items: <String>[
                  'Alberdi',
                  'Banda Norte',
                  'Barrio Jardín',
                  'Bimaco',
                  'Micro centro',
                  'Otro',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 16.0)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: _isLoading
                  ? 40
                  : 120, // Especifica un ancho fijo para el botón
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.purple500), // Color púrpura para el spinner
                    )
                  : TextButton(
                      onPressed: _publishPost, // Tu lógica para publicar
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        backgroundColor: AppColors.purple500,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                      child: Text(
                        'Publicar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[
                                  400], // Puedes quitar este color si siempre tendrás una imagen
                              shape: BoxShape.circle,
                              image: _userImageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_userImageUrl!),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: '¿Qué está pasando?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(),
                            ),
                            style: TextStyle(
                                fontSize: 22.0,
                                color: AppColors.purple500,
                                fontWeight: FontWeight.w700),
                            autofocus: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa un título';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Describe lo que sucedió...',
                          border: InputBorder.none,
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _pickImage,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset('assets/camera.png'),
                      ),
                    ),
                    if (_imageFileList != null)
                      for (var imageFile in _imageFileList!)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 100.0, // Ancho fijo para la imagen
                            height: 100.0, // Alto fijo para la imagen
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.purple500, // Color del borde
                                width: 1.0, // Ancho del borde
                              ),
                              borderRadius: BorderRadius.circular(
                                  8.0), // Radio del borde para esquinas redondeadas
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Radio del borde para el clip de la imagen
                              child: Image.file(
                                File(imageFile.path),
                                fit: BoxFit
                                    .cover, // Asegura que la imagen cubra todo el espacio disponible
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
