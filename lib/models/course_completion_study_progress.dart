class CourseCompletionStudyProgress {
  int? id;
  int? studyId;
  int? topicId;
  int? courseId;
  int? level;
  DateTime? createdAt;
  DateTime? updatedAt;

  CourseCompletionStudyProgress({
    this.courseId,
    this.createdAt,
    this.id,
    this.level,
    this.studyId,
    this.topicId,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "study_id": this.studyId,
      "topic_id": this.topicId,
      "course_id": this.courseId,
      "level": this.level,
      "created_at": this.createdAt!.toIso8601String(),
      "updated_at": this.updatedAt!.toIso8601String()
    };
  }

  CourseCompletionStudyProgress.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.studyId = map['study_id'],
        this.courseId = map["course_id"],
        this.topicId = map['topic_id'],
        this.createdAt = DateTime.parse(map["created_at"]),
        this.updatedAt = DateTime.parse(map['updated_at']),
        this.level = map['level'];
}
