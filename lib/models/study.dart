class Study {
  int? id;
  String? type;
  String? name;
  int? currentTopicId;
  int? courseId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<StudyProgress>? progress;

  Study({
    this.id,
    this.type,
    this.name,
    this.currentTopicId,
    this.courseId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });
}

class StudyProgress {
  int? id;
  int? studyId;
  int? topicId;
  int? testId;
  int? level;
  double? score;
  bool? passed;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? completedAt;

  StudyProgress(
      {this.id,
      this.studyId,
      this.topicId,
      this.testId,
      this.level,
      this.score,
      this.passed,
      this.createdAt,
      this.updatedAt,
      this.completedAt});
}
