import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('About BAYANi App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // App Logo Placeholder
            Container(
              height: isLargeScreen ? 200 : 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'App Logo Placeholder',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),

            // App Description
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
                      'BAYANi - Emergency Response App',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'BAYANi is a mobile application designed specifically for the residents of Science City of Muñoz. '
                      'This emergency response app aims to provide fast and reliable assistance during various emergencies, '
                      'including natural disasters, medical situations, fire incidents, and other critical situations.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Features Section
                    Text(
                      'Key Features:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Quick emergency contact with local authorities and responders.\n'
                      '• Real-time notifications and alerts for city-wide emergencies.\n'
                      '• First aid guides and safety tips for various emergency situations.\n'
                      '• GPS location sharing for fast and accurate response.\n'
                      '• Access to important resources like evacuation maps and emergency hotlines.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Mission Statement
                    Text(
                      'Our Mission:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'BAYANi aims to empower the community of Science City of Muñoz by providing a reliable, easy-to-use tool '
                      'that ensures immediate response and proper guidance during emergencies. We believe in the importance of '
                      'community safety and preparedness, striving to be a beacon of help in times of need.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),

                    // Contact Information
                    Text(
                      'Contact Us:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'For feedback, suggestions, or assistance, please reach out to us at:\n'
                      'Email: support@bayaniapp.com\n'
                      'Phone: +63 123 456 7890\n'
                      'Address: Muñoz CDRRMO Rescue\nEmergency Operation Center, Science City of Muñoz, 3120 Nueva Ecija',
                      style: TextStyle(fontSize: 16),
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
