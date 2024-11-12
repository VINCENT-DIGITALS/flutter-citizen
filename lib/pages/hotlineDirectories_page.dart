import 'package:citizen/components/bottom_bar.dart';
import 'package:citizen/components/custom_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/locales.dart';

class HotlineDirectoriesPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(LocaleData.hotlineDirectories
                              .getString(context),),
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
            HotlineCard(
              iconColor: Colors.red,
              title: 'CDRRMO',
              subtitle:
                  'City Disaster Risk Reduction & Management Office (CDRRMO) (AVAILABLE 24/7)',
              telNo: '(044) 456 3119',
              phoneNumbers: {
                'GLOBE': '0966 774 6951',
                'SMART': '0912 846 6896'
              },
              email: 'scmunozcdrrmo@gmail.com',
              fbPage: 'https://web.facebook.com/scm.drrmo',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.orange,
              title: 'OsLAM',
              subtitle:
                  'Ospital ng Lungsod Agham ng Muñoz (OsLAM) (AVAILABLE 24/7)Purok Cabiawan, Brgy. Rizal, Science City of Muñoz, Nueva Ecija',
              telNo: '(044) 511 6234',
              phoneNumbers: {'DITO': '0993 994 0748'},
              email: 'oslamscm@gmail.com',
              fbPage: 'https://web.facebook.com/OsLAMunoz',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.green,
              title: 'CHO',
              subtitle: 'City Health Office (8:00AM-4:00PM Monday-Friday)',
              telNo: '(044) 940 6886',
              phoneNumbers: {},
              email: '',
              fbPage: 'https://web.facebook.com/Munoz.CityHealthOffice',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.purple,
              title: 'BFP',
              subtitle:
                  'Bureau of Fire Protection (BFP) - Muñoz Station (AVAILABLE 24/7)',
              telNo: '(044) 456 5893',
              phoneNumbers: {'SUN': '0922 735 9848'},
              email: 'almasiganebfp@yahoo.com',
              fbPage: 'https://web.facebook.com/profile.php?id=100064633845833',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.red,
              title: 'OCM',
              subtitle: 'Office of the City Mayor',
              telNo: '(044) 951 0008',
              phoneNumbers: {},
              email: '',
              fbPage: '',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.red,
              title: 'PNP',
              subtitle: 'Science City of Muñoz PNP Station',
              telNo: '(044) 456 0104',
              phoneNumbers: {'TM': '0915 599 1424', 'TNT': '0998 596 5417'},
              email: '',
              fbPage: 'https://web.facebook.com/profile.php?id=100063768863589',
            ),
            SizedBox(height: 20),
            HotlineCard(
              iconColor: Colors.red,
              title: 'CLSU Infirmary',
              subtitle: 'Central Luzon State University Infirmary',
              telNo: '(044) 456 0104',
              phoneNumbers: {'TNT': '0938 126 9326', 'GLOBE': '0926 565 1830'},
              email: '',
              fbPage: '',
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(currentPage: 'Hotlines'),
      ),
    );
  }
}

class HotlineCard extends StatefulWidget {
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? telNo;
  final Map<String, String>
      phoneNumbers; // Updated to handle labeled phone numbers
  final String? email;
  final String? fbPage;

  const HotlineCard({
    Key? key,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.telNo,
    required this.phoneNumbers,
    this.email,
    this.fbPage,
  }) : super(key: key);

  @override
  _HotlineCardState createState() => _HotlineCardState();
}

class _HotlineCardState extends State<HotlineCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: widget.iconColor,
                child: Text(
                  widget.title[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(widget.subtitle),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue,
                ),
                onPressed: _toggleExpanded,
              ),
              isThreeLine: true,
            ),
            Divider(),
            // Display telNo if phoneNumbers is empty
            if (widget.phoneNumbers.isEmpty && widget.telNo != null)
              _buildContactTile(
                label: 'Tel No.',
                value: widget.telNo!,
                icon: Icons.phone,
                link: 'tel:${widget.telNo}',
              ),
            // Display labeled phone numbers if available
            if (widget.phoneNumbers.isNotEmpty)
              for (var entry in widget.phoneNumbers.entries)
                _buildContactTile(
                  label: entry.key,
                  value: entry.value,
                  icon: Icons.phone_android,
                  link: 'tel:${entry.value}',
                  isSimType: true,
                ),
            // Conditionally show telNo, email, and fbPage if expanded
            if (_isExpanded) ...[
              if (widget.telNo != null && widget.phoneNumbers.isNotEmpty)
                _buildContactTile(
                  label: 'Tel No.',
                  value: widget.telNo!,
                  icon: Icons.phone,
                  link: 'tel:${widget.telNo}',
                ),
              if (widget.email != null && widget.email!.isNotEmpty)
                _buildContactTile(
                  label: 'Email',
                  value: widget.email!,
                  icon: Icons.email,
                  link: 'mailto:${widget.email}',
                  showLinkText: true,
                ),
              if (widget.fbPage != null && widget.fbPage!.isNotEmpty)
                _buildContactTile(
                  label: 'FB PAGE',
                  value: widget.fbPage!,
                  icon: Icons.facebook,
                  link: widget.fbPage!,
                  showLinkText: true,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required String label,
    required String value,
    required IconData icon,
    required String link,
    bool showLinkText = false,
    bool isSimType = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: RichText(
        text: TextSpan(
          children: [
            if (isSimType)
              TextSpan(
                text: '$label: ',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            TextSpan(
              text: showLinkText ? label : value,
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    print('Could not launch $link');
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}