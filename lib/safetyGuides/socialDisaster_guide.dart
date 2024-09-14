import 'package:flutter/material.dart';

class SocialDisasterGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Social Disaster Guide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Social disasters such as civil unrest, mass gatherings, or pandemics can have significant impacts on communities. This guide provides strategies for staying safe and informed.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Before a Social Disaster',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Stay informed about potential social disruptions in your area through news outlets and social media.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Develop a communication plan with your family in case of an emergency.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Keep an emergency kit ready, including masks, sanitizers, and non-perishable food.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'During a Social Disaster',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Avoid areas where large crowds are gathering to reduce the risk of injury or exposure to dangerous situations.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Follow local authorities’ instructions, including curfews and evacuation orders.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Stay connected with friends and family to ensure everyone’s safety.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'After a Social Disaster',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Check on your family and neighbors, especially those who are elderly or disabled.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Report any damage or suspicious activity to local authorities.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Seek support from community organizations if you are in need of assistance.',
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
            'Keep a list of important contacts, including local authorities, emergency services, and family members, readily available.',
            style: TextStyle(fontSize: 18),
          ),
          // Add more detailed sections if needed
        ],
      ),
    );
  }
}
