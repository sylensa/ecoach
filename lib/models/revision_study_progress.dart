class RevisionStudyProgress {
   int? id;
   int? studyId;
   int? topicId;
   int? courseId;
   int? level;
   DateTime? createdAt;
   DateTime? updatedAt;

  RevisionStudyProgress({
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
      "updated_at": this.updatedAt!.toIso8601String(),
    };
  }

  RevisionStudyProgress.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.studyId = map['study_id'],
        this.courseId = map["course_id"],
        this.topicId = map['topic_id'],
        this.createdAt = DateTime.parse(map["created_at"]) ,
        this.updatedAt = DateTime.parse( map['updated_at']),
        this.level = map['level'];
}


//  ("""CREATE TABLE 'revision_study_progress' (
//         id INTEGER PRIMARY KEY, 
//         'study_id' int NOT NULL,
//         'topic_id' int DEFAULT NULL,
//         'course_id' int DEFAULT NULL,
//         'level' int DEFAULT NULL,
//         'created_at' timestamp NULL DEFAULT NULL,
//         'updated_at' timestamp NULL DEFAULT NULL
//       ) """);