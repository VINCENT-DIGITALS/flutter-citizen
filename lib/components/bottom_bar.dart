import 'package:citizen/localization/locales.dart';
import 'package:citizen/pages/announcement_page.dart';
import 'package:citizen/pages/home_page.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../pages/friends/friends_circle_page.dart';
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
    // Only check authentication for the friends page
    if (page == 'friends') {
      if (!_dbService.isAuthenticated()) {
        _dbService.redirectToLogin(context);
        return;
      }
    }
    switch (page) {
      case 'home':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(currentPage: 'home')),
        );
        break;
      case 'friends':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CircleHomePage(currentPage: 'friends')),
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

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: LocaleData.general.getString(context),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.report),
        label: LocaleData.reports.getString(context),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
        label: LocaleData.updates.getString(context),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_rounded),
        label: LocaleData.friends.getString(context),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: LocaleData.settings.getString(context),
      ),
    ];
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
      selectedItemColor: Colors.orange, // Set your selected color here
      unselectedItemColor: Colors.grey, // Set your unselected color here
      showSelectedLabels: true, // Show label for selected item
      showUnselectedLabels: true, // Show label for unselected items
      items: _buildBottomNavigationBarItems(),
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
      case 'friends':
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
        return 'friends';
      case 4:
        return 'settings';

      default:
        return 'home';
    }
  }
}
