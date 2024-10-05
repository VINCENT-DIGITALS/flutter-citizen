import 'package:citizen/pages/announcement_page.dart';
import 'package:citizen/pages/home_page.dart';

import 'package:citizen/pages/weather_page.dart';
import 'package:citizen/pages/map_page.dart';
import 'package:citizen/pages/login_page.dart';
import 'package:citizen/components/setting.dart';
import 'package:citizen/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/report_pages/summary_report_page.dart';

class BottomNavBar extends StatefulWidget {
  final String currentPage;

  const BottomNavBar({Key? key, required this.currentPage}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final DatabaseService _dbService = DatabaseService();

  void _onItemTapped(String page) {
    if (page == widget.currentPage) return;

    switch (page) {
      case 'home':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(currentPage: 'home')),
        );
        break;
      case 'map':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage(currentPage: 'map')),
        );
        break;
      case 'settings':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SettingsWidget(),
            );
          },
        );
        break;
      case 'report':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ReportsSummaryPage(currentPage: 'SummaryReport')),
        );
        break;
      case 'announcement':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AnnouncementsPage(currentPage: 'announcement')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getSelectedIndex(widget.currentPage),
      onTap: (index) {
        String page = _getPageFromIndex(index);
        _onItemTapped(page);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
    );
  }

  int _getSelectedIndex(String page) {
    switch (page) {
      case 'home':
        return 0;
      case 'SummaryReport':
        return 1;
      case 'announcement':
        return 2;
      case 'map':
        return 3;
      case 'settings':
        return 4;

      default:
        return 0;
    }
  }

  String _getPageFromIndex(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'report';
      case 2:
        return 'announcement';
      case 3:
        return 'map';
      case 4:
        return 'settings';

      default:
        return 'home';
    }
  }
}
