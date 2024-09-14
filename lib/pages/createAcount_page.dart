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
import '/components/my_button.dart';

import 'package:citizen/services/database_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  // Password visibility
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

 // Instance of AuthService
final DatabaseService _dbService = DatabaseService();

  // sign user up method
  void signUserup() async {
    LoadingIndicatorDialog().show(context);
    //creating user
    try {
      if (passwordController.text == confirmpasswordController.text) {
        
        UserCredential userCredential = await _dbService.registerWithEmailAndPassword(
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
          msg: "Account Successfully Created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 54, 244, 57),
          textColor: Colors.white,
          fontSize: 16.0
        );
        
      } else {
        setState(() {
          errorMessage = 'Password did not match. Please try again.';
        });
      }
    } catch (e) {
      print("Something went wrong: $e");
    } finally{
      LoadingIndicatorDialog().dismiss();

    }
  }



  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8; // 80% of the screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 130, 3),
        automaticallyImplyLeading: false,
        title: const Text(
          'BAYANi',
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color.fromRGBO(251, 216, 93, 100),
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                      child: Container(
                        width: containerWidth,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    LocaleData.createAccount.getString(context),
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
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          child: IconButton(
                                            icon: const FaIcon(
                                              FontAwesomeIcons.circleExclamation,
                                              color: Color(0xFFC72525),
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              print('IconButton pressed ...');
                                            },
                                          ),
                                        ),
                                        AutoSizeText(
                                          LocaleData.completeForm.getString(context),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                        child: TextFormField(
                                          controller: emailController,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: const InputDecoration(
                                            labelText: 'Email Address',
                                            labelStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            alignLabelWithHint: false,
                                            hintStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF018203),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                        child: TextFormField(
                                          controller: usernameController,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: const InputDecoration(
                                            labelText: 'Full Name',
                                            labelStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            alignLabelWithHint: false,
                                            hintStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF018203),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                        child: TextFormField(
                                          controller: phoneController,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: const InputDecoration(
                                            labelText: 'Phone Number',
                                            labelStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            alignLabelWithHint: false,
                                            hintStyle: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF018203),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                        child: TextFormField(
                                          controller: passwordController,
                                          autofocus: false,
                                          obscureText: !_passwordVisible,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            alignLabelWithHint: false,
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF018203),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            focusedErrorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(() {
                                                _passwordVisible = !_passwordVisible;
                                              }),
                                              focusNode: FocusNode(skipTraversal: true),
                                              child: Icon(
                                                _passwordVisible
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: const Color(0xFF57636C),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                        child: TextFormField(
                                          controller: confirmpasswordController,
                                          autofocus: false,
                                          obscureText: !_confirmPasswordVisible,
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password',
                                            labelStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            alignLabelWithHint: false,
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF018203),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            focusedErrorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFFF5963),
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                            suffixIcon: InkWell(
                                              onTap: () => setState(() {
                                                _confirmPasswordVisible = !_confirmPasswordVisible;
                                              }),
                                              focusNode: FocusNode(skipTraversal: true),
                                              child: Icon(
                                                _confirmPasswordVisible
                                                    ? Icons.visibility_outlined
                                                    : Icons.visibility_off_outlined,
                                                color: const Color(0xFF57636C),
                                                size: 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (errorMessage.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                          child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                             AutoSizeText(
                                              errorMessage,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                color: Colors.red,
                                                fontSize: 11,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      MyButton(
                                        text: LocaleData.signUpTextT.getString(context),
                                         onTap: signUserup,  //Sign in Button
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                thickness: 1.5,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Text(
                                                LocaleData.continueWith.getString(context),
                                                style: TextStyle(color: Colors.grey[700]),
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
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Usage
                                             SquareTile(
                                              onTap: () async {
                                                LoadingIndicatorDialog().show(context);
                                                
                                                String? result = await DatabaseService().createGoogleUser();
                                  
                                                if (result != null) {
                                                  // Show toast message if sign-in failed
                                                  Fluttertoast.showToast(
                                                    msg: result,
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    backgroundColor: const Color.fromARGB(255, 114, 244, 54),
                                                    textColor: Colors.white,
                                                  );
                                                }
                                                LoadingIndicatorDialog().dismiss();
                                                await DatabaseService().signOut();
                                              },
                                              imagePath: 'lib/images/google.png',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              LocaleData.alreadyHaveAccount.getString(context),
                                              style: TextStyle(color: Colors.grey[700]),
                                            ),
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () {
                                            
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const AuthPage()),
                                                );
                                              },
                                              child: Text(
                                                LocaleData.loginNow.getString(context),
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
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
                      ),
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
