extension CapitalizeExtension on String {
  String capitalizeFirstLetters() {
    return split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String capitalizeLastLetter() {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    return substring(0, length - 1) + this[length - 1].toUpperCase();
  }

  String getInitials() {
    if (isEmpty) {
      return this;
    }
    final words = split(' ');
    if (words.length > 1) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return this[0].toUpperCase();
  }
}
