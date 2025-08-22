// import 'regex.dart';

// class Validations {
//   var error = 0;
//   static String? emailValidation(String? email) {
//     if (email!.isEmpty) {
//       return 'email_null'.tr;
//     } else if (RegExp(Regex.EMAIL_PATTERN).hasMatch(email)) {
//       return null;
//     }
//     // The pattern of the email didn't match the regex above.
//     return 'invalid_email'.tr;
//   }

//   static String? passwordValidation(String? password) {
//     if (password!.isEmpty) {
//       return 'enter_pass'.tr;
//     } else if (RegExp(Regex.PASSWORD_PATTERN).hasMatch(password)) {
//       return null;
//     }
//     return 'invalid_pass'.tr;
//   }

//   static String? confirmPasswordValidation(
//       {String? password, String? confirmPassword}) {
//     if (password!.isEmpty) {
//       return 'enter_pass'.tr;
//     }
//     if (confirmPassword != password) {
//       return 'pass_not_match'.tr;
//     }
//     return null;
//   }

//   static String? fieldValidation({String? value, String? field}) {
//     if (value!.isEmpty) {
//       return "$field ${'cannot_be_empty'.tr}";
//     }
//     return null;
//   }

//   static String? dropDownValidation(
//       {dynamic value, String? field, List<String>? list}) {
//     if (value == null || value == "") {
//       return "${'set'.tr} $field";
//     } else if (list == null) {
//       return null;
//     } else {
//       if (list.contains(value)) {
//         return null;
//       } else {
//         return "${'set'.tr} $field";
//       }
//     }
//   }
// }

import 'package:backyard/legacy/Component/app_regular_expressions.dart';
import 'package:flutter/services.dart';

extension AppValidator on String {
  //-------------- Password Validator -------------------
  String? get validatePass {
    if (!RegularExpressions.passwordValidRegex.hasMatch(this) && isNotEmpty) {
      return 'Password must be of 8 characters long and contain atleast 1 uppercase, 1 lowercase, 1 digit and 1 special character';
    } else if (isEmpty) {
      return "Password field can't be empty.";
    }
    return null;
  }

  //-------------- Email Validator -------------------
  String? get validateEmail {
    if (!RegularExpressions.emailValidRegex.hasMatch(this) && isNotEmpty) {
      return 'Please enter valid email address';
    } else if (isEmpty) {
      return 'Email field cannot be empty';
    }
    return null;
  }

  String? get validateZipCOde {
    // if (RegExp(r'^\d{5}(-\d{4})?$').hasMatch(this) && isNotEmpty) {
    //   return "Please enter valid Zip Code";
    // } else
    // if (RegExp(r'^.{5,6}$').hasMatch(this) && isNotEmpty) {
    //   return "Please enter valid Zip Code";
    // } else
    if (isEmpty) {
      return 'Zip Code field cannot be empty';
    }
    return null;
  }

  //---------------- Empty Validator -----------------
  String? validateEmpty(String message) {
    if (isEmpty) {
      // return '$message field_cant_be_empty'.tr();
      final returningString = 'field cannot be empty';
      return '$message $returningString';
    } else {
      return null;
    }
  }

  //---------------- OTP Validator ---------------
  String? get validateOtp {
    if (length < 6) {
      return 'Password must be of 6 characters';
    }
    return null;
  }
}

class CreditCardNumberFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    final enteredData = newValue.text; // get data enter by used in textField
    final buffer = StringBuffer();

    for (var i = 0; i < enteredData.length; i++) {
      // add each character into String buffer
      buffer.write(enteredData[i]);
      final index = i + 1;
      if (index % 4 == 0 && enteredData.length != index) {
        // add space after 4th digit
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(), // final generated credit card number
      selection: TextSelection.collapsed(offset: buffer.toString().length), // keep the cursor at end
    );
  }
}

extension TypeCase on String {
  String titleCase() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
