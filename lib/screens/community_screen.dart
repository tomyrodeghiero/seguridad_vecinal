import 'package:flutter/material.dart';
import 'package:seguridad_vecinal/colors.dart';
import 'package:seguridad_vecinal/screens/community_detail_screen.dart';

class Community {
  final String name;
  final int memberCount;
  final IconData icon;

  Community(
      {required this.name, required this.memberCount, this.icon = Icons.image});
}

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Community> communities = [
    Community(name: 'Banda Norte', memberCount: 22),
    Community(name: 'Alberdi', memberCount: 17),
    Community(name: 'IPV Banda Norte', memberCount: 10),
    Community(name: 'Barrio Jardin', memberCount: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Comunidades',
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
      body: ListView.separated(
        itemCount: 4, // Adjust this number to match your number of communities
        itemBuilder: (context, index) {
          // Access the community using the index
          Community community = communities[index];

          return InkWell(
            onTap: () {
              // Navegar a la página de detalles de la comunidad
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
                  top: BorderSide(
                      width: 1.0,
                      color: Colors.grey), // Top border for each item
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.white, // Background color for the image
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Colors.grey)),
                      child: Icon(
                        Icons.image, // Replace with the community image
                        size: 60.0, // Increased size for the icon
                        color: Colors.grey[600],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.start, // Changed alignment here
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              community.name, // Real community name
                              style: TextStyle(
                                color: AppColors.waterGreen400,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              '${community.memberCount} members', // Real member count
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
    );
  }
}
