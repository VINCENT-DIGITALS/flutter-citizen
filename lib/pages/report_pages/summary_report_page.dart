import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';
import 'report_detail_page.dart'; // For accessing the logged-in user

class ReportsSummaryPage extends StatefulWidget {
  final String currentPage;
  const ReportsSummaryPage({Key? key, this.currentPage = 'SummaryReport'})
      : super(key: key);

  @override
  _ReportsSummaryPageState createState() => _ReportsSummaryPageState();
}

class _ReportsSummaryPageState extends State<ReportsSummaryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List of reports
  List<Map<String, dynamic>> userReports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserReports(); // Load user reports on page initialization
  }

  // Fetch reports submitted by the logged-in user
  Future<void> _loadUserReports() async {
    try {
      User? user = _auth.currentUser; // Get the current logged-in user
      if (user == null) {
        // If no user is logged in, return
        return;
      }

      // Query Firestore for reports submitted by the user
      QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: user.uid)
          .get();

      setState(() {
        userReports = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load reports: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Convert Firestore Timestamp to formatted DateTime string
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A'; // Return 'N/A' if timestamp is null
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a')
        .format(dateTime); // Format the DateTime
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('My Incident Reports'),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userReports.isEmpty
              ? const Center(child: Text('No reports submitted yet.'))
              : ListView.builder(
                  itemCount: userReports.length,
                  itemBuilder: (context, index) {
                    final report = userReports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          'Incident Type: ${report['incidentType'] ?? 'N/A'}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Date & Time: ${_formatTimestamp(report['timestamp'])}'),
                            Text('Location: ${report['address'] ?? 'N/A'}'),
                            Text('Landmark: ${report['landmark'] ?? 'N/A'}'),
                            Text('Severity: ${report['seriousness'] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          // Navigate to detailed report page when the item is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReportDetailPage(report: report),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }
}
