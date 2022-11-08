class MasteryCourse {
  int? id;
  int? studyId;
  int? topicId;
  int? level;
  String? topicName;
  bool? passed;
  DateTime? createdAt;
  DateTime? updatedAt;

  MasteryCourse({
    this.id,
    this.studyId,
    this.topicId,
    this.level,
    this.topicName,
    this.passed = false,
    this.createdAt,
    this.updatedAt,
  });

  static MasteryCourse fromJson(Map<String, dynamic> map) {
    return MasteryCourse(
        id: map['id'],
        studyId: map['study_id'],
        level: map['level'],
        topicId: map['topic_id'],
        topicName: map['topic_name'],
        passed: map['passed'] == 1 ? true : false,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'study_id': studyId,
      'level': level,
      'topic_id': topicId,
      'topic_name': topicName,
      'passed': passed! ? 1 : 0,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String()
    };
  }
}

class MasteryCourseUpgrade {
  int? id;
  int? studyId;
  int? topicId;
  int? courseId;
  int? level;
  String? topicName;
  bool? passed;
  DateTime? createdAt;
  DateTime? updatedAt;

  MasteryCourseUpgrade({
    this.courseId,
    this.id,
    this.studyId,
    this.topicId,
    this.level,
    this.topicName,
    this.passed = false,
    this.createdAt,
    this.updatedAt,
  });

  static MasteryCourseUpgrade fromJson(Map<String, dynamic> map) {
    return MasteryCourseUpgrade(
        id: map['id'],
        studyId: map['study_id'],
        courseId: map['course_id'],
        level: map['level'],
        topicId: map['topic_id'],
        topicName: map['topic_name'],
        passed: map['passed'] == 1 ? true : false,
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']));
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'study_id': studyId,
      'level': level,
      'topic_id': topicId,
      'course_id': courseId,
      'topic_name': topicName,
      'passed': passed! ? 1 : 0,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String()
    };
  }
}
