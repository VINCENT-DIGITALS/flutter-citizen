import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:flutter/material.dart';

class HotlineDirectoriesPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Hotline Directories'),
          shadowColor: Colors.black,
          elevation: 2.0,
        ),
        drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Science City of Muñoz Hotlines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildHotlineCard(
              context,
              iconColor: Colors.red,
              title: 'Philippine National Police',
              subtitle:
                  'Science City of Muñoz, Nueva Ecija, Region 3\n1.2 Kilometers away',
              distance: '1.2 Kilometers away',
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.orange,
              title: 'Bureau of Fire Protection',
              subtitle:
                  'Science City of Muñoz, Nueva Ecija, Region 3\n1.0 Kilometers away',
              distance: '1.0 Kilometers away',
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.green,
              title: 'Disaster Risk Reduction Management',
              subtitle:
                  'Science City of Muñoz, Nueva Ecija, Region 3\n1.2 Kilometers away',
              distance: '1.2 Kilometers away',
            ),
            _buildHotlineCard(
              context,
              iconColor: Colors.purple,
              title: 'OSLAM',
              subtitle: 'Requesting Help\n5.4 Kilometers away',
              distance: '5.4 Kilometers away',
            ),
            // Add more hotline cards as needed
          ],
        ),
        bottomNavigationBar: BottomNavBar(currentPage: 'Hotlines'),
      ),
    );
  }

  Widget _buildHotlineCard(BuildContext context, {
    required Color iconColor,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor,
          child: Text(
            title[0],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          // Handle tap event, possibly show more details or make a call
        },
      ),
    );
  }
}
