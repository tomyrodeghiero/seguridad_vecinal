import 'package:cori/colors.dart';
import 'package:cori/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final int _numPages = 3;
  String _firstName = "Usuario"; // Valor por defecto

  _loadUserFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("prefs -> $prefs");
    final String fullName = prefs.getString('fullName') ?? '';
    setState(() {
      _firstName = fullName.split(' ')[0];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserFirstName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  OnboardingContent(
                    title: 'Bienvenido $_firstName',
                    description:
                        'Cori es una aplicación que te permitirá sentirte más seguro en tu ciudad',
                    currentPage: _currentPage,
                    numPages: _numPages,
                  ),
                  OnboardingContent(
                    title: '',
                    description:
                        'Con Cori podrás enterarte de las noticias más importantes contadas por los ciudadanos',
                    currentPage: _currentPage,
                    numPages: _numPages,
                  ),
                  OnboardingContent(
                    title: '',
                    description:
                        'Cuenta con un botón de emergencia para que lo presiones cuando te sientas en peligro',
                    currentPage: _currentPage,
                    numPages: _numPages,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: _currentPage != _numPages - 1
                    ? FloatingActionButton(
                        elevation: 0,
                        backgroundColor: AppColors.purple500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Container(
                          width:
                              56, // Tamaño estándar de un FloatingActionButton
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.purple500, // Color de fondo blanco
                            borderRadius: BorderRadius.circular(
                                100), // BorderRadius de 100
                          ),
                          child: Center(
                            // Centra el ícono en el Container
                            child: Image.asset(
                              'assets/forward-arrow.png',
                              height: 24.0,
                              width: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                      )
                    : FloatingActionButton(
                        elevation: 0,
                        backgroundColor: AppColors.purple500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Container(
                          width:
                              56, // Tamaño estándar de un FloatingActionButton
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.purple500, // Color de fondo blanco
                            borderRadius: BorderRadius.circular(
                                100), // BorderRadius de 100
                          ),
                          child: Center(
                            // Centra el ícono en el Container
                            child: Image.asset(
                              'assets/finish-icon.png',
                              height: 24.0,
                              width: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String description;
  final int currentPage;
  final int numPages;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.currentPage,
    required this.numPages,
  });

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 14.0 : 7.0,
      width: isCurrentPage ? 14.0 : 7.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? AppColors.purple500 : Colors.grey[300],
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == currentPage
          ? _buildPageIndicator(true)
          : _buildPageIndicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Icon(
                Icons.image,
                size: 128,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              height: 1.15,
            ),
          ),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicators(),
        ),
      ],
    );
  }
}
