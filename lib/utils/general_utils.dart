dynamic enumFromString(List values, String? comp) {
  dynamic enumValue = null;
  values.forEach((item) {
    if (item.toString() == comp) {
      enumValue = item;
    }
  });
  return enumValue;
}


