import 'package:auto_size_text/auto_size_text.dart';
import 'package:citizen/components/loading.dart';
import 'package:citizen/localization/locales.dart';
import 'package:citizen/models/forgot_password.dart';
import 'package:citizen/pages/createAcount_page.dart';
import 'package:citizen/pages/home_page.dart';
import 'package:citizen/services/auth_page.dart';
import 'package:citizen/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/splash_screen.dart';
import '../privacyPolicyWidget/privacyPolicyPrompt.dart';
import '/components/my_button.dart';
import '/components/square_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final DatabaseService _dbService = DatabaseService();
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  final String phoneNumber =
      "09667746951"; // Replace with the phone number you want
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  // Password visibility
  bool _passwordVisible = false;
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
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = 'en'; // Set a default value
    _loadLocale();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  // error message
  //String errorMessage = '';

  // sign user in method
  Future<void> signUserIn() async {
    setState(() {
      isLoading = true;
    });
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Fields must not be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (!DatabaseService().isValidEmail(emailController.text)) {
      Fluttertoast.showToast(
        msg: LocaleData.validEmail.getString(context),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    // LoadingIndicatorDialog().show(context);

    try {
      String? user = await _dbService.signInWithEmail(
        emailController.text,
        passwordController.text,
      );
      // If user is null, sign in failed
      if (user != null) {
        // Display the error message in a toast
        Fluttertoast.showToast(
          msg: user,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        // setState(() {
        //   errorMessage = user;
        // });
      } else {
        // This creates an error, app stops working after sign in
        // Fluttertoast.showToast(
        //   msg: 'LogIn Sucess, Redirecting...',
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        // );
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthPage()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   errorMessage = 'Incorrect email or password. Please try again.';
      // });
    } finally {
      // LoadingIndicatorDialog().dismiss();
      setState(() {
        isLoading = false;
      });
    }
  }

void signInWithGoogle() async {
  // Show the loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    },
  );

  try {
    // Sign out any existing sessions and start the sign-in process
    await DatabaseService().signOut();
    String? result = await DatabaseService().signInWithGoogle();

    // Check the result and show an error toast if needed
    if (result != null) {
      Fluttertoast.showToast(
        msg: result,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      // Ensure that the widget is still mounted before navigating
      if (!mounted) return;

      // Optional delay to give the loading indicator time to display
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to AuthPage if sign-in is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  } catch (e) {
    // Handle errors (e.g., show error toast or log error)
    Fluttertoast.showToast(
      msg: 'An error occurred: $e',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  } finally {
    // Hide the loading dialog
    // Navigator.of(context, rootNavigator: true).pop();
  }
}


  late AnimationController _controller;
  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _navigateToAuthPage() async {
    await _controller.forward(); // Start the animation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locale = prefs.getString('locale') ?? 'en';
    setState(() {
      _currentLocale = locale;
    });
    _flutterLocalization.translate(locale);
  }

  Future<void> _setLocale(String? value) async {
    if (value == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
    setState(() {
      _currentLocale = value;
    });
    _flutterLocalization.translate(value);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.8; // 80% of the screen width
    String logoPath = 'lib/images/LOGODESC.png'; // logo

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
                      HomePage()), // Replace `HomePage` with your target page
            );
          },
          child: const Text(' '),
        ),
        centerTitle: false,
        elevation: 2,
        actions: [
          DropdownButton<String>(
            value: _currentLocale,
            items: const [
              DropdownMenuItem(
                value: "en",
                child: Text("English"),
              ),
              DropdownMenuItem(
                value: "tl",
                child: Text("Tagalog"),
              ),
            ],
            onChanged: (value) {
              _setLocale(value);
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Column(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10, 10, 10, 10),
                        child: Image.asset(
                          logoPath,
                          width: constraints.maxWidth *
                              0.5, // Adjust width based on screen size
                          height: constraints.maxHeight *
                              0.5, // Adjust height based on screen size
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildLoginForm(containerWidth),
                      ),
                    ),
                  ],
                ))
              ],
            );
          } else {
            return Center(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 10, 10, 10),
                            child: Image.asset(
                              logoPath,
                              width: MediaQuery.of(context).size.width *
                                  1.6, // Adjust width based on screen size
                              height: MediaQuery.of(context).size.height *
                                  0.2, // Adjust height based on screen size
                            ),
                          ),
                          _buildLoginForm(containerWidth)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildLoginForm(containerWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
          width: containerWidth,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              // Positioned widget to place the refresh icon in the top-right corner
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
                      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
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
                      children: [
                        AutoSizeText(
                          LocaleData.loginNow.getString(context),
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF14181B),
                            fontSize: 25,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 10),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 10),
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF5963),
                                        width: 2,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
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
                              // if (errorMessage.isNotEmpty)
                              //   Padding(
                              //     padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         AutoSizeText(
                              //           errorMessage,
                              //           maxLines: 2,
                              //           softWrap: true,
                              //           overflow: TextOverflow.ellipsis,
                              //           minFontSize: 8,
                              //           stepGranularity: 1,
                              //           style: const TextStyle(
                              //             fontFamily: 'Inter',
                              //             color: Colors.red,
                              //             fontSize: 11,
                              //             letterSpacing: 0,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle the forgot password action
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const ForgotPasswordDialog();
                                          },
                                        );
                                      },
                                      child: Text(
                                        LocaleData.forgotPass
                                            .getString(context),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 13, 102, 227),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() =>
                                            isLoading = true); // Start loading
                                        await signUserIn();
                                        setState(() =>
                                            isLoading = false); // Stop loading
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 15),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return const Color.fromARGB(255, 93,
                                                255, 68); // Pressed color
                                          }
                                          return Colors.blue; // Default color
                                        }),
                                      ),
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors
                                                  .white) // Loading indicator
                                          : Text(
                                              LocaleData.signInTextT
                                                  .getString(context),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),

// Existing Row widget code
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _dbService.signOut();

                                        // Navigate to HomePage after sign out or if no user was signed in
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage()),
                                        );
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Colors.grey[
                                                700]!; // Color when button is pressed
                                          }
                                          return Colors.grey; // Default color
                                        }),
                                      ),
                                      child: Text(
                                        LocaleData.guest.getString(context),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 1.5,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        LocaleData.continueWith
                                            .getString(context),
                                        style:
                                            TextStyle(color: Colors.grey[700]),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Usage
                                    SquareTile(
                                      onTap: () async {
                                        signInWithGoogle();
                                      },
                                      imagePath: 'lib/images/google.png',
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      LocaleData.notAMember.getString(context),
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                        fontSize: 10,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          AutoSizeText(
                                            LocaleData.registerNow
                                                .getString(context),
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              color: Colors.blue,
                                              fontSize: 10,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
