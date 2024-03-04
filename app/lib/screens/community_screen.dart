import 'package:cori/components/custom_bottom_nav_bar.dart';
import 'package:cori/screens/home_screen.dart';
import 'package:cori/screens/map_screen.dart';
import 'package:cori/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:cori/screens/community_detail_screen.dart';

class Community {
  final String name;
  final int memberCount;
  final String imagePath; // Nueva propiedad para la ruta de la imagen

  Community({
    required this.name,
    required this.memberCount,
    this.imagePath = '', // Valor predeterminado vacío o una imagen genérica
  });
}

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CommunityScreen()),
        );
        break;
    }
  }

  int _selectedIndex = 2;
  final List<Community> communities = [
    Community(
        name: 'Banda Norte',
        memberCount: 22,
        imagePath: 'assets/banda-norte.png'),
    Community(
        name: 'Alberdi', memberCount: 17, imagePath: 'assets/alberdi.png'),
    Community(
        name: 'IPV Banda Norte',
        memberCount: 10,
        imagePath: 'assets/bimaco.png'),
    Community(
        name: 'Barrio Jardin',
        memberCount: 25,
        imagePath: 'assets/micro-centro.png'),
  ];

  @override
  void initState() {
    super.initState();
    // Programar la apertura del drawer para el próximo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              Icon(Icons.menu, color: Colors.black), // Cambiado a ícono de menú
          onPressed: () => Scaffold.of(context).openDrawer(), // Abre el Drawer
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Comunidades',
          style: TextStyle(
            fontSize: 22.0,
            color: AppColors.purple500,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/search.png',
              width: 24,
              height: 24,
            ), // Imagen personalizada para la búsqueda
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: ListView.separated(
        itemCount: communities.length, // Use communities list length
        itemBuilder: (context, index) {
          Community community = communities[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommunityDetailScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align children to the start of cross axis
                  children: [
                    Container(
                        width: 150.0,
                        height: 150.0,
                        child: Image.asset(
                          community.imagePath,
                          fit: BoxFit.cover,
                        )),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align column contents to the start of main axis
                          children: [
                            Text(
                              community.name,
                              style: TextStyle(
                                color: AppColors.purple500,
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                              ),
                            ),
                            Text(
                              '${community.memberCount} miembros', // Changed 'members' to 'miembros'
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          color: Colors.transparent,
          height: 0,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
