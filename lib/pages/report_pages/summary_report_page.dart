import 'package:citizen/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

import '../../components/bottom_bar.dart';
import '../../components/custom_drawer.dart';
import 'report_detail_page.dart'; // For accessing the report detail page

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

  Stream<QuerySnapshot<Map<String, dynamic>>>? _reportsStream;

  @override
  void initState() {
    super.initState();
    _initReportsStream();
  }

  void _initReportsStream() {
    final user = _auth.currentUser;

    if (user != null) {
      _reportsStream = _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: user.uid)
          .orderBy('timestamp',
              descending: true) // Order by timestamp in descending order
          .snapshots();
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, y h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(LocaleData.myHistoryReport.getString(context)),
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: _reportsStream == null
          ? Center(
              child: Text(LocaleData.pleaseLoginReports.getString(context)))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _reportsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading reports.'));
                }

                final userReports = snapshot.data?.docs
                        .where((doc) {
                          final data = doc.data();
                          return data['archived'] == null ||
                              data['archived'] == false;
                        })
                        .map((doc) => doc.data())
                        .toList() ??
                    [];

                if (userReports.isEmpty) {
                  return Center(
                      child: Text(
                    LocaleData.noReportsSubmitted.getString(context),
                  ));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: userReports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final report = userReports[index];
                    report['id'] = snapshot
                        .data?.docs[index].id; // Assign the document ID.
                    return _buildReportCard(report);
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavBar(currentPage: widget.currentPage),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          LocaleData.incidenttype.getString(context) +
              ': ${report['incidentType'] ?? 'N/A'}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailText(LocaleData.dateandTime.getString(context),
                _formatTimestamp(report['timestamp'])),
            _buildDetailText(LocaleData.location.getString(context),
                report['address'] ?? 'N/A'),
            _buildDetailText(LocaleData.landmark.getString(context),
                report['landmark'] ?? 'N/A'),
            _buildDetailText(LocaleData.severity.getString(context),
                report['seriousness'] ?? 'N/A'),
            _buildStatusText(report['status']),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailPage(reportId: report['id']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text('$label: $value'),
    );
  }

  Widget _buildStatusText(String? status) {
    final statusColor = _getStatusColor(status ?? 'Pending');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        LocaleData.status.getString(context) + ': ${status ?? 'Pending'}',
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
