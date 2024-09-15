import 'package:flutter/material.dart';

class FirstAidTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isLargeScreen = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('First Aid Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section for CPR Tips
            _buildSection(
              context,
              isLargeScreen,
              'CPR (Cardiopulmonary Resuscitation)',
              'CPR Image/Video Placeholder',
              '1. Call for help immediately.\n'
                  '2. Push hard and fast in the center of the chest (100-120 compressions per minute).\n'
                  '3. Open the airway and give rescue breaths if trained.',
            ),
            SizedBox(height: 20),

            // Section for Bleeding Tips
            _buildSection(
              context,
              isLargeScreen,
              'Bleeding',
              'Bleeding Image/Video Placeholder',
              '1. Apply direct pressure to the wound with a clean cloth or bandage.\n'
                  '2. Elevate the injured area above the heart if possible.\n'
                  '3. Seek medical attention if bleeding does not stop.',
            ),
            SizedBox(height: 20),

            // Section for Burns Tips
            _buildSection(
              context,
              isLargeScreen,
              'Burns',
              'Burns Image/Video Placeholder',
              '1. Cool the burn with running water for at least 10 minutes.\n'
                  '2. Cover the burn with a sterile, non-stick bandage or cloth.\n'
                  '3. Avoid using ice, as it can cause further damage.',
            ),
            SizedBox(height: 20),

            // Section for Choking Tips
            _buildSection(
              context,
              isLargeScreen,
              'Choking',
              'Choking Image/Video Placeholder',
              '1. Encourage the person to keep coughing if they can.\n'
                  '2. Perform back blows and abdominal thrusts (Heimlich maneuver) if the person cannot breathe.\n'
                  '3. Call for emergency help if the obstruction persists.',
            ),
            SizedBox(height: 20),

            // Section for Poisoning Tips
            _buildSection(
              context,
              isLargeScreen,
              'Poisoning',
              'Poisoning Image/Video Placeholder',
              '1. Call emergency services or a poison control center immediately.\n'
                  '2. Do not induce vomiting unless directed by a healthcare professional.\n'
                  '3. Provide as much information as possible about the substance ingested.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, bool isLargeScreen, String title, String placeholderText, String details) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slidable Placeholder for images/videos
          Container(
            height: isLargeScreen ? 250 : 150, // Responsive height
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
            ),
            child: PageView(
              children: [
                Center(
                  child: Text(
                    placeholderText,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                // Additional slides can be added here
                Center(
                  child: Text(
                    'Another Image/Video Placeholder',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Card for details
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
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    details,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
