dynamic enumFromString(List values, String? comp) {
  dynamic enumValue = null;
  values.forEach((item) {
    if (item.toString() == comp) {
      enumValue = item;
    }
  });
  return enumValue;
}

calculatePercentage(dynamic totalNumberOfQuestions, dynamic correctlyAnswered) {
  double fraction = correctlyAnswered / totalNumberOfQuestions;
  double percentage = fraction * 100;
  return percentage.toStringAsFixed(1) + '%';
}
