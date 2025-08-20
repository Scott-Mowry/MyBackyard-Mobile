class Regex {
  // ignore: constant_identifier_names
  static const String EMAIL_PATTERN =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // ignore: constant_identifier_names
  static const String PHONE_PATTERN = r'^[0-9]+$';

  // ignore: constant_identifier_names
  static const String LATITUDE_PATTERN =
      r'^(\+|-)?((\d((\.)|\.\d{1,10})?)|(0*?[0-8]\d((\.)|\.\d{1,10})?)|(0*?90((\.)|\.0{1,10})?))$';

  // ignore: constant_identifier_names
  static const String LONGITUDE_PATTERN  =
      r'^(\+|-)?((\d((\.)|\.\d{1,10})?)|(0*?\d\d((\.)|\.\d{1,10})?)|(0*?1[0-7]\d((\.)|\.\d{1,10})?)|(0*?180((\.)|\.0{1,10})?))$';

  // ignore: constant_identifier_names
  static const String PASSWORD_PATTERN =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
}
