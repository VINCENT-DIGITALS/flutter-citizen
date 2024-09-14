import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocaleData.EN),
  MapLocale("tl", LocaleData.TL),

];

mixin LocaleData {
  static const String title = 'title';
  static const String body = 'body';
  static const String welcomeMessage = 'welcomeMessage';
  static const String signInTextT = 'signInTextT';
  static const String signUpTextT = 'signUpTextT';
  static const String continueWith = 'continueWith';
  static const String forgotPass = 'forgotPass';
  static const String notAMember = 'notAMember';
  static const String registerNow = 'registerNow';
  static const String internetConnect = 'internetConnect';
  static const String internetDisconnect = 'internetDisconnect';
  static const String homeLocal = 'homeLocal';
  static const String createAccount = 'createAccount';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  static const String loginNow = 'loginNow';
  static const String completeForm = 'completeForm';

  static const Map<String, dynamic> EN = {
    title: 'ENGLISH',
    body: 'Welcome to this localized Flutter application, %a',
    welcomeMessage: 'Welcome to our BAYANi app!',
    signInTextT: 'Sign In',
    signUpTextT: 'Sign up',
    continueWith: ' Or continue with',
    forgotPass: 'Forgot Password?',
    notAMember: 'Not a member yet?',
    registerNow: 'Register now',
    internetConnect: 'You are connected to the internet',
    internetDisconnect: 'You are not connected to the internet.',
    homeLocal: 'Home',
    createAccount: 'Create Account',
    alreadyHaveAccount: 'Already Have an Account?',
    loginNow: 'Login here',
    completeForm: 'Complete the Form'

  };

  static const Map<String, dynamic> TL = {
    title: 'TAGALOG',
    body: 'Maligayang pagdating sa lokal na aplikasyong Flutter na ito, %a',
    welcomeMessage: 'Maligayang Pagdating sa BAYANi App!',
    signInTextT: 'Mag Sign In',
    signUpTextT: 'Mag Sign up',
    continueWith: ' O magpatuloy sa',
    forgotPass: 'Nakalimutan ang Password?',
    notAMember: 'Hindi pa miyembro?',
    registerNow: 'Magparehistro dito',
    internetConnect: 'Ikaw ay konektado sa internet',
    internetDisconnect: 'Ikaw ay hindi konektado sa internet.',
    homeLocal: 'Home',
    createAccount: 'Gumawa ng Account',
    alreadyHaveAccount: 'May Account na?',
    loginNow: 'Mag Login dito',
    completeForm: 'Kompletohin ang Pormularyo'
  };


}


