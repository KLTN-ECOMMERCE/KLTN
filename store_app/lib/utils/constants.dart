import 'package:flutter/material.dart';

const host = 'kltn-web.onrender.com';
const addOneSignalId = '944be109-15b7-4931-8e75-4ceb3905843e';
const ggMapApiKey = 'AIzaSyAwNIFrBjwMQnnYK2Inr6kX2N5NxrVaVQc';
const stripePublishableKey =
    'pk_test_51PLoaDItb7fygiE0KMgBVEtUBNvnO8tketOozqKfjoq3veNz4T07mWJenDf1qycKqwIEKEUxsob5EWhYzsd92SEM00eh7YbYAs';
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 190);

// Form Error
final RegExp emailValidatorRegExp = RegExp(
  r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);
final RegExp specialCharacters = RegExp(
  r'[!@#$%^&*(),.?":{}|<>]',
);
final RegExp allowCharacters = RegExp(
  '[a-z A-Z á-ú Á-Ú 0-9]',
);
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kOtpNullError = "Please Enter your OTP";
const String kInvalidOtpError = "Please Enter Valid OTP code";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kNullError = "Please Enter full of section";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kSpecialCharactersNullError =
    "Please Re-enter without Special Characters";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kTextColor),
  );
}
