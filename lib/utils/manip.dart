String kCapitalizeString(str) {
  final String firstLetter = str.trim().substring(0, 1).toUpperCase();
  final String remainingLetters = str.trim().substring(1);

  return '$firstLetter$remainingLetters';
}
