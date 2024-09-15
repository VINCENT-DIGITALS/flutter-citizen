import 'package:flutter/material.dart';

class PersonalSafetyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Safety'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Placeholder for future personal safety video/image
            Container(
              height: isLargeScreen ? 300 : 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  'Personal Safety Image/Video Placeholder',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Personal Safety Content
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Safety Tips',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. Always be aware of your surroundings, especially in unfamiliar areas.\n'
                      '2. Trust your instincts. If something doesn’t feel right, leave the situation.\n'
                      '3. Carry a personal safety device, such as a whistle or pepper spray, if needed.',
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
