import 'package:flutter/material.dart';

class NaturalDisasterGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Natural Disaster Guide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Natural disasters such as earthquakes, hurricanes, and floods can strike with little or no warning. This guide will help you prepare for, respond to, and recover from these events.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Preparation',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Create an emergency plan for your family, including evacuation routes and communication methods.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Prepare an emergency kit with essentials such as water, food, medications, and important documents.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Stay informed about the risks in your area and sign up for emergency alerts.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'During a Natural Disaster',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Follow evacuation orders and move to higher ground if necessary.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Stay indoors and away from windows during severe weather.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Listen to local authorities and follow their instructions.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'After a Natural Disaster',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Check for injuries and provide first aid as needed.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Avoid downed power lines and flooded areas.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Contact your insurance company to report any damage.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Keep a list of emergency contacts, including local authorities, hospitals, and family members, in your emergency kit.',
            style: TextStyle(fontSize: 18),
          ),
          // Add more detailed sections if needed
        ],
      ),
    );
  }
}
