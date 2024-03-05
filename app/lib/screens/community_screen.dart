import 'package:flutter/material.dart';
import 'package:cori/colors.dart';
import 'package:cori/components/custom_drawer.dart';
import 'package:cori/screens/community_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Community {
  final String name;
  final int memberCount;
  final String imagePath;

  Community({
    required this.name,
    required this.memberCount,
    this.imagePath = '',
  });
}

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Community>> fetchCommunitiesFromApi() async {
    final url = Uri.parse(
        'https://cori-backend.vercel.app/api/get-communities-from-users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> apiData = json.decode(response.body);

      return apiData.map<Community>((data) {
        return Community(
          name: data['neighborhood'],
          memberCount: data['membersCount'],
          imagePath: getImagePathForNeighborhood(data['neighborhood']),
        );
      }).toList();
    } else {
      throw Exception('Failed to load communities from API');
    }
  }

  String getImagePathForNeighborhood(String neighborhood) {
    switch (neighborhood) {
      case 'Banda Norte':
        return 'assets/banda-norte.png';
      case 'Alberdi':
        return 'assets/alberdi.png';
      case 'Bimaco':
        return 'assets/bimaco.png';
      case 'Barrio Jardín':
        return 'assets/barrio-jardin.png';
      case 'Micro centro':
        return 'assets/micro-centro.png';
      default:
        return 'assets/otro-barrio.png';
    }
  }

  String _fullName = '';
  String _imageUrl = '';

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Nombre no disponible';
      _imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        fullName: _fullName,
        imageUrl: _imageUrl,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
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
            ),
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: FutureBuilder<List<Community>>(
        future: fetchCommunitiesFromApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final communities = snapshot.data!;
            return ListView.separated(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityDetailScreen(
                            neighborhoodName: community.name,
                            memberCount: community.memberCount),
                      ),
                    ).then((value) {
                      if (value == true) {
                        fetchCommunitiesFromApi().then((_) {
                          setState(() {});
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150.0,
                            height: 150.0,
                            child: Image.asset(
                              community.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                    '${community.memberCount} ${community.memberCount == 1 ? "miembro" : "miembros"}',
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
            );
          } else {
            return Center(child: Text("No hay datos disponibles"));
          }
        },
      ),
    );
  }
}
