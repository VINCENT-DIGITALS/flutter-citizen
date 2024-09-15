import 'package:flutter/material.dart';

class MentalHealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Placeholder for future mental health image or video
            Container(
              height: isLargeScreen ? 300 : 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  'Mental Health Image/Video Placeholder',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Mental Health Overview
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
                      'Mental Health Awareness',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mental health is just as important as physical health. It includes our emotional, psychological, and social well-being. Mental health affects how we think, feel, and act, and it plays a role in how we handle stress, relate to others, and make choices.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Self-Care Tips
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
                      'Self-Care Tips for Mental Health',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. **Stay Connected**: Reach out to family and friends, and try not to isolate yourself.\n'
                      '2. **Exercise Regularly**: Physical activity can help reduce anxiety and improve mood.\n'
                      '3. **Practice Mindfulness**: Meditation, deep breathing, and yoga can help you stay grounded.\n'
                      '4. **Get Enough Sleep**: Make sure to have a regular sleep schedule and get enough rest.\n'
                      '5. **Seek Help**: If you feel overwhelmed, don’t hesitate to talk to a professional.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Placeholder for Mental Health Resources image/video
            Container(
              height: isLargeScreen ? 250 : 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  'Mental Health Resources Image/Video Placeholder',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card for Mental Health Resources
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
                      'Mental Health Resources',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'If you or someone you know is struggling with mental health, consider the following resources:\n'
                      '- National Suicide Prevention Hotline: 1-800-273-TALK (8255)\n'
                      '- Crisis Text Line: Text HOME to 741741\n'
                      '- Online Therapy Platforms: BetterHelp, Talkspace\n'
                      '- Local mental health clinics and therapists.',
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
