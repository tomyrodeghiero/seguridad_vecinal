import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class CommunityPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Post Comunidad',
          style: TextStyle(
            fontSize: 20.0,
            color: AppColors.waterGreen400,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 28.0,
            ),
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: AppColors.waterGreen400,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              'Descripción.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 225.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: AppColors.waterGreen400,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
