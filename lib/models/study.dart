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

  static Study fromJson(Map<String, dynamic> map) {
    return Study(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        courseId: map['course_id'],
        userId: map['user_id'],
        currentTopicId: map['current_topic_id'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'user_id': userId,
      'course_id': courseId,
      'current_topic_id': currentTopicId,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String()
    };
  }
}

class StudyProgress {
  int? id;
  int? studyId;
  int? topicId;
  int? testId;
  int? level;
  int? section;
  String? name;
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
      this.section,
      this.name,
      this.score,
      this.passed = false,
      this.createdAt,
      this.updatedAt,
      this.completedAt});

  static StudyProgress fromJson(Map<String, dynamic> map) {
    return StudyProgress(
        id: map['id'],
        studyId: map['study_id'],
        level: map['level'],
        section: map['section'],
        testId: map['test_id'],
        topicId: map['topic_id'],
        name: map['name'],
        passed: map['passed'] == 1 ? true : false,
        score: map['score'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'study_id': studyId,
      'level': level,
      'section': section,
      'test_id': testId,
      'topic_id': topicId,
      'name': name,
      'passed': passed,
      'score': score,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String()
    };
  }
}
