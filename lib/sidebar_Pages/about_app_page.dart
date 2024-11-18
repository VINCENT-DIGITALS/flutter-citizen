import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../localization/locales.dart';

class AboutAppPage extends StatefulWidget {
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  final ScrollController _scrollController = ScrollController();
  int _bottomReachCount = 0;
  bool _showFab = false;
  late ConfettiController _confettiController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;

      if (isBottom) {
        setState(() {
          _bottomReachCount += 1;
          if (_bottomReachCount >= 10) {
            _showFab = true;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _confettiController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.aboutApp.getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          controller: _scrollController,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 5.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/LOGOAPP0.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                height: isLargeScreen ? 200 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage('assets/images/LOGOAPP0.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleData.aboutAppguide.getString(context),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),                     ),
                    SizedBox(height: 10),
                    Text(
                      LocaleData.aboutAppguideDesc.getString(context),
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 20),
                    Text(
                      LocaleData.aboutAppKeyfeatures.getString(context),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 10),
                    Text(
                      LocaleData.aboutAppKeyfeaturesDesc.getString(context),
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 20),
                    Text(
                      LocaleData.aboutAppMission.getString(context),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 10),
                    Text(
                      LocaleData.aboutAppMissionDesc.getString(context),
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 20),
                    Text(
                      LocaleData.aboutAppContactUs.getString(context),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.justify, // Justify the text here
                    ),
                    SizedBox(height: 10),
                    Text(
                      'For feedback, suggestions, or assistance, please reach out to us at:\n'
                      'Email: support\n'
                      'Phone: +63\n'
                      'Address: Muñoz CDRRMO Rescue\nEmergency Operation Center, Science City of Muñoz, 3120 Nueva Ecija',
                      style: TextStyle(fontSize: 16), textAlign: TextAlign.justify, // Justify the text here
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _confettiController.play();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Stack(
                        children: [
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: screenSize.height * 0.5,
                                    child: PageView(
                                      controller: _pageController,
                                      children: [
                                        ImageDialogContent(
                                          imagePath: 'assets/images/30.png',
                                          name: "John Vincent T. Macayanan",
                                          role: "Developer",
                                          textScaleFactor:
                                              screenSize.width > 600 ? 1.2 : 0.8,
                                        ),
                                        ImageDialogContent(
                                          imagePath: 'assets/images/32.png',
                                          name: "Noaim U. Piti-ilan",
                                          role: "Team Leader",
                                          textScaleFactor:
                                              screenSize.width > 600 ? 1.2 : 0.8,
                                        ),
                                        ImageDialogContent(
                                          imagePath: 'assets/images/31.png',
                                          name: "Kyle Timothy D.P. Masinas",
                                          role: "Documentation Specialist/QA Tester",
                                          textScaleFactor:
                                              screenSize.width > 600 ? 1.2 : 0.8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  SmoothPageIndicator(
                                    controller: _pageController,
                                    count: 3,
                                    effect: WormEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      type: WormType.thin,
                                      spacing: 8,
                                      activeDotColor: Colors.blueAccent,
                                      dotColor: Colors.grey[300]!,
                                    ),
                                  ),
                                  Divider(thickness: 1, color: Colors.grey[300]),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "This application was created by a dedicated team of BSIT students. "
                                      "Initially developed as a capstone project, it also serves as a step toward building the next-generation Emergency Response App.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: ConfettiWidget(
                              confettiController: _confettiController,
                              blastDirectionality:
                                  BlastDirectionality.explosive,
                              numberOfParticles: 30,
                              maxBlastForce: 10,
                              minBlastForce: 5,
                              gravity: 0.2,
                              colors: [
                                Colors.blue,
                                Colors.orange,
                                Colors.pink,
                                Colors.green
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.info, color: Colors.white),
                label: Text(
                  "Meet the Creators",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.blueAccent,
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            )
          : null,
    );
  }
}

class ImageDialogContent extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final double textScaleFactor;

  const ImageDialogContent({
    required this.imagePath,
    required this.name,
    required this.role,
    required this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blueAccent.withOpacity(0.3), Colors.transparent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(0, 4), // Shadow position
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 20 * textScaleFactor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            role,
            style: TextStyle(
              fontSize: 16 * textScaleFactor,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
