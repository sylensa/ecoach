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

String getBarPercentage(double) {
  if (double >= 90) {
    return "assets/images/learn_mode2/bars4.png";
  } else if (double >= 70) {
    return "assets/images/learn_mode2/bars3.png";
  } else if (double >= 45) {
    return "assets/images/learn_mode2/bars2.png";
  } else {
    return "assets/images/learn_mode2/bars1.png";
  }
}

String courseRankPosition(String position){
  if(position.endsWith("1") && position != "11"){
    return "st";
  }else if (position.endsWith("2") && position != "12"){
    return "nd";
  }else if (position.endsWith("3") && position != "13"){
    return "rd";
  }else{
    return "th";
  }
}
