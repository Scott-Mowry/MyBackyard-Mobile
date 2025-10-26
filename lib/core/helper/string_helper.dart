extension StringExtension on String {
  String get capitalizeFirst {
    if (this.isEmpty) return this;
    if (this.length == 1) return this[0].toUpperCase();
    return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  }

  String get capitalize => this.split(' ').map((e) => e.capitalizeFirst).join(' ');

  String get cleanForMatching => this.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), ' ').trim();
}
