import 'dart:io';
import 'package:citizen/models/forgot_password.dart';
import 'package:citizen/pages/login_page.dart';
import 'package:citizen/services/database_service.dart';
import 'package:citizen/services/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/locales.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseService _dbService = DatabaseService();
  bool _isAuthenticated = false; // Track authentication status

  SharedPreferences? _prefs;
  Map<String, String> _userData = {};
  bool _isPhoneNumberRevealed = false;
  bool _isAddressRevealed = false;
  bool _isEditing = false;
  File? _image;
  String? _imageUrl;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _checkAuthenticationStatus();
  }

  void _checkAuthenticationStatus() {
    setState(() {
      _isAuthenticated = _dbService.isAuthenticated();
    });
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _fetchAndDisplayUserData();
  }

  Future<void> _fetchAndDisplayUserData() async {
    try {
      setState(() {
        _userData = {
          'uid': _prefs?.getString('uid') ?? '',
          'email': _prefs?.getString('email') ?? '',
          'displayName': _prefs?.getString('displayName') ?? '',
          'photoURL': _prefs?.getString('photoURL') ?? '',
          'phoneNum': _prefs?.getString('phoneNum') ?? '',
          'createdAt': _prefs?.getString('createdAt') ?? '',
          'address': _prefs?.getString('address') ?? '',
          'status': _prefs?.getString('status') ?? '',
        };
      });
      setState(() {
        usernameController.text = _userData['displayName'] ?? '';
        emailController.text = _userData['email'] ?? '';
        phoneController.text = _userData['phoneNum'] ?? '';
        addressController.text = _userData['address'] ?? '';
        _isEditing = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      final updatedData = {
        'displayName': usernameController.text,
        'email': emailController.text,
        'phoneNum': phoneController.text,
        'address': addressController.text,
      };
      await _dbService.updateUserData(updatedFields: updatedData);

      final prefs = await SharedPreferencesService.getInstance();
      prefs.saveUserData(updatedData);

      setState(() {
        _userData = updatedData;
        _isEditing = false;
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      usernameController.text = _userData['displayName'] ?? '';
      emailController.text = _userData['email'] ?? '';
      phoneController.text = _userData['phoneNum'] ?? '';
      addressController.text = _userData['address'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = _userData['displayName']?.isNotEmpty == true
        ? _userData['displayName']!.substring(0, 1)
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.aboutCDRRMOGuideDesc.getString(context)),
        backgroundColor: const Color.fromARGB(255, 219, 180, 39),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          bool isLargeScreen = maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isLargeScreen ? 600 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isAuthenticated) ...[
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                  child: Text(
                                    firstLetter.isEmpty ? '?' : firstLetter,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isEditing ? Icons.save : Icons.edit,
                                    color: _isEditing
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_isEditing) {
                                        _saveUserData();
                                      } else {
                                        _isEditing = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildProfileInfoRow(
                              title: LocaleData.fullName.getString(context),
                              controller: usernameController,
                              content: _userData['displayName'] ??
                                  'No name available',
                              hidden: false,
                            ),
                            const SizedBox(height: 8),
                            _buildProfileInfoRow(
                                title: LocaleData.email.getString(context),
                                controller: emailController,
                                content:
                                    _userData['email'] ?? 'No email available',
                                hidden: false,
                                isEmail: true),
                            const SizedBox(height: 8),
                            _buildProfileInfoRow(
                              title: LocaleData.phonenumber.getString(context),
                              controller: phoneController,
                              content: _isPhoneNumberRevealed
                                  ? _userData['phoneNum'] ??
                                      'No Number available'
                                  : '**********',
                              hidden: true,
                              onRevealPressed: () {
                                setState(() {
                                  _isPhoneNumberRevealed =
                                      !_isPhoneNumberRevealed;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildProfileInfoRow(
                              title: LocaleData.Address.getString(context),
                              controller: addressController,
                              content: _isAddressRevealed
                                  ? _userData['address'] ??
                                      'No Address available'
                                  : '**********',
                              hidden: true,
                              onRevealPressed: () {
                                setState(() {
                                  _isAddressRevealed = !_isAddressRevealed;
                                });
                              },
                            ),
                            if (_isEditing)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _saveUserData,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 12),
                                      ),
                                      child: Text(
                                          LocaleData.Save.getString(context)),
                                    ),
                                    ElevatedButton(
                                      onPressed: _cancelEditing,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 12),
                                      ),
                                      child: Text(
                                          LocaleData.cancel.getString(context)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: LocaleData.UserTypeg.getString(context),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: _isAuthenticated
                                  ? 'Authenticated User'
                                  : 'Guest',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleData.AccountManagement.getString(context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_isAuthenticated) ...[
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ForgotPasswordDialog();
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 168, 168, 168),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: Text(LocaleData.changePass.getString(context)),
                      ),
                    ],
                    if (!_isAuthenticated) ...[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoRow({
    required String title,
    required TextEditingController controller,
    required String content,
    required bool hidden,
    VoidCallback? onRevealPressed,
    bool isEmail = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        _isEditing && !isEmail
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            : Row(
                children: [
                  Expanded(child: Text(content)),
                  if (hidden)
                    IconButton(
                      onPressed: onRevealPressed,
                      icon: Icon(
                        content == '**********'
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
      ],
    );
  }
}
