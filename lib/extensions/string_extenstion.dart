extension StringExtension on String {
  String captialFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
