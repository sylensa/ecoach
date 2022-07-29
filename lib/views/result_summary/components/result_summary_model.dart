import 'package:ecoach/models/test_taken.dart';

class ResultSummaryModel {
  final double? courseScore;
  final int? courseId;

  final List<TestTaken> tests = [];

  ResultSummaryModel({this.courseScore, this.courseId});
}
