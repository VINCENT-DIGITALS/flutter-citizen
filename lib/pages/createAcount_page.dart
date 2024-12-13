import 'package:auto_size_text/auto_size_text.dart';
import 'package:citizen/components/loading.dart';
import 'package:citizen/components/square_tile.dart';
import 'package:citizen/localization/locales.dart';
import 'package:citizen/pages/login_page.dart';
import 'package:citizen/services/auth_page.dart';
import 'package:citizen/services/firebase_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/splash_screen.dart';
import '/components/my_button.dart';

import 'package:citizen/services/database_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // text editing controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  // error message
  String errorMessage = '';

  late AnimationController _controller;
  // Password visibility
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Instance of AuthService
  final DatabaseService _dbService = DatabaseService();

  // sign user up method
  void signUserup() async {
    // LoadingIndicatorDialog().show(context);
    //creating user
    try {
      if (passwordController.text == confirmpasswordController.text) {
        UserCredential userCredential =
            await _dbService.registerWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          usernameController.text,
          phoneController.text,
        );

        // Clear the form fields and error message
        emailController.clear();
        phoneController.clear();
        usernameController.clear();
        passwordController.clear();
        confirmpasswordController.clear();

        Fluttertoast.showToast(
            msg: LocaleData.accountCreated.getString(context),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: const Color.fromARGB(255, 54, 244, 57),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          errorMessage = LocaleData.passwordNotMatch.getString(context);
        });
      }
    } catch (e) {
      print("Something went wrong: $e");
    } finally {
      // LoadingIndicatorDialog().dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToAuthPage() async {
    await _controller.forward(); // Start the animation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  final String phoneNumber =
      "09667746951"; // Replace with the phone number you want
  void _dialNumber(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8; // 80% of the screen width

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 219, 180, 39),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.phone, color: Colors.green, size: 40),
          onPressed: () => _dialNumber(phoneNumber),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AuthPage()), // Replace `HomePage` with your target page
            );
          },
          child: const Text(' '),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                      child: Container(
                          width: containerWidth,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 6,
                                        offset: Offset(2, 3),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: RotationTransition(
                                      turns: Tween(begin: 0.0, end: 1.0)
                                          .animate(_controller),
                                      child: Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.blue.shade700,
                                        size: 26,
                                      ),
                                    ),
                                    onPressed: _navigateToAuthPage,
                                    tooltip: 'Refresh',
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          LocaleData.createAccount
                                              .getString(context),
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            color: Color(0xFF14181B),
                                            fontSize: 25,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                child: IconButton(
                                                  icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .circleExclamation,
                                                    color: Color(0xFFC72525),
                                                    size: 15,
                                                  ),
                                                  onPressed: () {
                                                    print(
                                                        'IconButton pressed ...');
                                                  },
                                                ),
                                              ),
                                              AutoSizeText(
                                                LocaleData.completeForm
                                                    .getString(context),
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: Color(0xFF054806),
                                                  fontSize: 10,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// Form here
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 10),
                                              child: TextFormField(
                                                controller: emailController,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Email Address',
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF018203),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 10),
                                              child: TextFormField(
                                                controller: usernameController,
                                                autofocus: false,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: LocaleData.fullName
                                                      .getString(context),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF018203),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 10),
                                              child: TextFormField(
                                                controller: phoneController,
                                                autofocus: false,
                                                obscureText: false,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration: InputDecoration(
                                                  labelText: LocaleData
                                                      .phonenumber
                                                      .getString(context),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintText:
                                                      "Enter a valid phone number",
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF018203),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  // Regular expression for validating Philippine phone numbers
                                                  String pattern =
                                                      r'^(?:\+639|09|9)(\d{9})$'; // Accepts +639, 09, or 9 as the starting pattern
                                                  RegExp regex =
                                                      RegExp(pattern);

                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Phone number is required.';
                                                  } else if (!regex
                                                      .hasMatch(value)) {
                                                    return 'Enter a valid Philippine phone number.';
                                                  }

                                                  // Normalize the phone number to the format 09497918144
                                                  if (value
                                                      .startsWith('+639')) {
                                                    value = value.replaceFirst(
                                                        '+639', '09');
                                                  } else if (value
                                                      .startsWith('9')) {
                                                    value = '09' + value;
                                                  }

                                                  // Update the controller value to save the normalized number
                                                  phoneController.text = value;

                                                  return null;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 10),
                                              child: TextFormField(
                                                controller: passwordController,
                                                autofocus: false,
                                                obscureText: !_passwordVisible,
                                                decoration: InputDecoration(
                                                  labelText: 'Password',
                                                  labelStyle: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintStyle: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF018203),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  focusedErrorBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  errorBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () => setState(() {
                                                      _passwordVisible =
                                                          !_passwordVisible;
                                                    }),
                                                    focusNode: FocusNode(
                                                        skipTraversal: true),
                                                    child: Icon(
                                                      _passwordVisible
                                                          ? Icons
                                                              .visibility_outlined
                                                          : Icons
                                                              .visibility_off_outlined,
                                                      color: const Color(
                                                          0xFF57636C),
                                                      size: 22,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 10),
                                              child: TextFormField(
                                                controller:
                                                    confirmpasswordController,
                                                autofocus: false,
                                                obscureText:
                                                    !_confirmPasswordVisible,
                                                decoration: InputDecoration(
                                                  labelText: LocaleData
                                                      .confirmPass
                                                      .getString(context),
                                                  labelStyle: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  alignLabelWithHint: false,
                                                  hintStyle: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 14,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFF018203),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  focusedErrorBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  errorBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFFF5963),
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                  ),
                                                  suffixIcon: InkWell(
                                                    onTap: () => setState(() {
                                                      _confirmPasswordVisible =
                                                          !_confirmPasswordVisible;
                                                    }),
                                                    focusNode: FocusNode(
                                                        skipTraversal: true),
                                                    child: Icon(
                                                      _confirmPasswordVisible
                                                          ? Icons
                                                              .visibility_outlined
                                                          : Icons
                                                              .visibility_off_outlined,
                                                      color: const Color(
                                                          0xFF57636C),
                                                      size: 22,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (errorMessage.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AutoSizeText(
                                                      errorMessage,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Colors.red,
                                                        fontSize: 11,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            MyButton(
                                              text: LocaleData.signUpTextT
                                                  .getString(context),
                                              onTap:
                                                  signUserup, //Sign in Button
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Divider(
                                                      thickness: 1.5,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: Text(
                                                      LocaleData.continueWith
                                                          .getString(context),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Divider(
                                                      thickness: 1.5,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Usage
                                                  SquareTile(
                                                    onTap: () async {
                                                      LoadingIndicatorDialog()
                                                          .show(context);

                                                      String? result =
                                                          await DatabaseService()
                                                              .createGoogleUser();

                                                      if (result != null) {
                                                        // Show toast message if sign-in failed
                                                        Fluttertoast.showToast(
                                                          msg: result,
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  114, 244, 54),
                                                          textColor:
                                                              Colors.white,
                                                        );
                                                      }
                                                      LoadingIndicatorDialog()
                                                          .dismiss();
                                                      await DatabaseService()
                                                          .signOut();
                                                    },
                                                    imagePath:
                                                        'lib/images/google.png',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    LocaleData
                                                        .alreadyHaveAccount
                                                        .getString(context),
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[700]),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginPage()),
                                                      );
                                                    },
                                                    child: Text(
                                                      LocaleData.loginNow
                                                          .getString(context),
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
