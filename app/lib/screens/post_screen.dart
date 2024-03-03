import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList;
  final TextEditingController _textController = TextEditingController();

  void _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    setState(() {
      _imageFileList = selectedImages;
    });
  }

  Future<void> _publishPost() async {
    var uri = Uri.parse('http://127.0.0.1:5001/api/create-report');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = 'Un título aquí';
    request.fields['description'] = _textController.text;
    request.fields['neighborhood'] = 'Un vecindario aquí';

    for (var imageFile in _imageFileList!) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
        contentType:
            MediaType('image', basename(imageFile.path).split('.').last),
      ));
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Reporte creado con éxito.");
      } else {
        print("Falló la creación del reporte.");
      }
    } catch (e) {
      print("Error al enviar el reporte: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          TextButton(
            onPressed: _publishPost,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                color: AppColors.purple500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    'Publicar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.purple500,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: '¿Qué está pasando?',
                            border: InputBorder.none,
                          ),
                          autofocus: true,
                        ),
                      ),
                    ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.file(File(imageFile.path)),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
