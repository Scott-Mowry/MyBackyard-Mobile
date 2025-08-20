class RegularExpressions {
  RegularExpressions._();
  static RegExp PASSWORD_VALID_REGIX =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp EMAIL_VALID_REGIX = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  static RegExp USER_NAME_REGEX = RegExp(r'^[a-zA-Z0-9_]{4,16}$');

  static RegExp SPECIAL_CHARACTERS_REGEX =
      RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\|]');
}
