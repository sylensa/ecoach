import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ecoach/database/test_taken_db.dart';

class AdeoBarChart {
  double? courseScore;
  String? courseName;
  final charts.Color? color;

  final TestTakenDB testTakenDb = TestTakenDB();

  AdeoBarChart({
    this.courseScore,
    this.courseName,
    this.color,
  });
}
