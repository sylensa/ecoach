import 'package:intl/intl.dart';

String getDurationTime(Duration duration) {
  int min = (duration.inSeconds / 60).floor();
  int sec = duration.inSeconds % 60;
  return "${NumberFormat('00').format(min)}:${NumberFormat('00').format(sec)}";
}

String getRevisionDuration(Duration duration) {
  if (duration.inDays >= 1) {
    return '${duration.inDays} days';
  } else if (duration.inHours >= 1) {
    return '${duration.inHours} hours';
  } else if (duration.inMinutes >= 1) {
    return '${duration.inHours} mins';
  } else {
    return '${duration.inMinutes} sec';
  }
}
