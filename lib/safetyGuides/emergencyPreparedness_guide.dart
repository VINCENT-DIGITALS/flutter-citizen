import 'package:flutter/material.dart';

class EmergencyPreparednessGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Emergency Preparedness Guide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Being prepared for emergencies can make all the difference when disaster strikes. This guide offers tips on how to prepare for various emergencies and what to include in your emergency kit.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Creating an Emergency Kit',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Water: Have at least one gallon of water per person per day for at least three days.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Food: Store at least a three-day supply of non-perishable food.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Medications: Include a supply of necessary medications, as well as basic first aid supplies.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '4. Tools: Keep a flashlight, extra batteries, a multi-tool, and a manual can opener.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '5. Important Documents: Keep copies of personal documents, including IDs, insurance policies, and bank information, in a waterproof container.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Developing a Family Communication Plan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Choose an out-of-town contact person whom all family members can check in with during an emergency.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Establish a meeting place near your home in case of a sudden emergency.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Make sure everyone in your household knows how to send text messages, as phone lines may be overloaded during a disaster.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Preparing Your Home',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Secure heavy items such as bookcases, refrigerators, televisions, and objects that hang on walls. These can cause injuries during an earthquake or other emergencies.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '2. Install smoke alarms and carbon monoxide detectors on every level of your home and check them regularly.',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '3. Know how to shut off utilities such as gas, water, and electricity.',
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
            'Ensure you have a list of emergency contacts, including local authorities, utility companies, and family members, easily accessible.',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
