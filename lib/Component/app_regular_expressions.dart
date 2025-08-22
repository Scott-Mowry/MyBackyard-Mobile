class RegularExpressions {
  RegularExpressions._();
  static RegExp passwordValidRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static RegExp emailValidRegex = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
  );

  static RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{4,16}$');

  static RegExp specialCharactersRegex = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\|]');
}
