import 'package:flutter/material.dart';

class LifeSafetyGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Life Safety Guide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Life safety involves taking precautions to protect yourself and others from accidents, injuries, and other emergencies. This guide covers essential tips and best practices.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'First Aid Basics',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Learn basic first aid skills, including CPR, wound care, and how to treat burns.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Keep a well-stocked first aid kit at home, in your car, and at work.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Know the emergency numbers for your area and when to call for professional help.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Traffic Accident Response',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. If you witness an accident, pull over safely and call emergency services immediately.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Provide assistance if it is safe to do so, such as moving victims out of immediate danger and administering first aid.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Stay on the scene until help arrives and provide information to authorities.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Home Safety Tips',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Install smoke detectors on every floor of your home and test them monthly.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Create and practice a fire escape plan with your family, ensuring everyone knows at least two ways to exit every room.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Keep a fire extinguisher in an accessible location and learn how to use it properly.',
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
            'Ensure you have a list of emergency contacts, including local emergency services, family members, and nearby neighbors who can assist in an emergency.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
