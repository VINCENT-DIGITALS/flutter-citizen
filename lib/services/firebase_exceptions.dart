// // custom exception to handle various authentication related errors
// class TFirebaseAuthException implements Exception{
//   //Error code associated with the exception
//   final String code;

//   //constructor that takes an error code
//   TFirebaseAuthException(this.code);

//   //Get the corresponding error message

// String get message{
//   switch (code) {
//     case 'auth/email-already-exists':
//       return 'The email already in use';
//       break;
//     case 'auth/invalid-email':
//       return'The emmail address is not valid';
//     case 'auth/invalid-password':
//       return'The emmail address is not valid';
//     default:
//     return 'Something went wrong, please try again';
//   }
// }
// }