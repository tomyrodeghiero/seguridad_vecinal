import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Tu perfil', style: TextStyle(color: Colors.black)),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.waterGreen400,
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        leadingWidth: 56,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        child: Column(
          children: <Widget>[
            SizedBox(height: 80), // Provide spacing from the top
            Stack(
              alignment:
                  Alignment.center, // Align the stack contents to the center
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors
                        .white, // Set the avatar background color to white
                    child: Stack(
                      children: <Widget>[
                        // If you have an image to display, it should go here
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Background color for the '+' icon
                              border: Border.all(
                                color: Colors
                                    .black, // Color of the border around the '+' icon
                              ),
                              borderRadius: BorderRadius.circular(
                                  12), // Circular border radius for the '+' icon background
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.black, // Icon color is black
                              size: 24, // Icon size can be adjusted
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Provide spacing between avatar and name
            Text(
              'Luciana González',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),

            SizedBox(height: 30),
            Text('Ciudad de Río Cuarto, Córdoba.',
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
            Text('Miembro desde Diciembre 2023.',
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
            SizedBox(height: 32.0), // Provide spacing before the button
            Container(
              height: 1.0,
              color: Colors.grey, // Top border color grey
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal:
                      16.0), // Adds margin vertically and horizontal padding around the button
              child: Center(
                // Center the button within the Padding
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors
                        .waterGreen400, // Set button background color to watergreen400
                    onPrimary: Colors.white, // Set text color to white
                    padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal:
                            32.0), // Add padding inside the button for height
                  ),
                  onPressed: () {
                    // Handle reports
                  },
                  child: Text(
                    'Reportes',
                    style: TextStyle(
                      fontSize: 18.0, // Increase font size here
                      // You can also adjust other text properties if needed
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 1.0,
              color:
                  AppColors.waterGreen400, // Bottom border color watergreen400
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0), // Horizontal padding around all cards
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio:
                      0.7, // Smaller value means wider cards, larger value means taller cards
                  crossAxisSpacing: 16, // Horizontal space between the cards
                  mainAxisSpacing: 16, // Vertical space between the cards
                  children: List.generate(2, (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Card background color
                        border: Border.all(color: Colors.black), // Black border
                        borderRadius:
                            BorderRadius.circular(32), // Border radius
                      ),
                      child: Center(),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.waterGreen400),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: AppColors.waterGreen400),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language, color: AppColors.waterGreen400),
            label: '',
          ),
        ],
        selectedItemColor: AppColors.waterGreen400,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
