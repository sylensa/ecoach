class GlossaryProgressData {
  GlossaryProgressData({
    this.id,
    this.searchTerm,
    this.selectedCharacter,
    this.topicId,
    this.courseId,
    this.progressIndex,
    this.correct,
    this.count,
    this.wrong,

  });

  int? id;
  String? searchTerm;
  String? selectedCharacter;
  int? topicId;
  int? courseId;
  int? progressIndex;
  int? correct;
  int? wrong;
  int? count;



  glossaryProgressDataMap(){
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['course_id'] = courseId;
    mapping['topic_id'] = topicId;
    mapping['search_term'] = searchTerm;
    mapping['selected_character'] = selectedCharacter;
    mapping['progress_index'] = progressIndex;
    mapping['correct'] = correct;
    mapping['count'] = count;
    mapping['wrong'] = wrong;
    return mapping;
  }

  factory GlossaryProgressData.fromJson(Map<String, dynamic> json) => GlossaryProgressData(
    id: json["id"] == null ? null : json["id"],
    searchTerm: json["search_term"] == null ? null : json["search_term"],
    selectedCharacter: json["selected_character"] == null ? null : json["selected_character"],
    topicId: json["topic_id"] == null ? null : json["topic_id"],
    progressIndex: json["progress_index"] == null ? 0 : json["progress_index"],
    courseId: json["course_id"] == null ? null : json["course_id"],
    correct: json["correct"] == null ? null : json["correct"],
    wrong: json["wrong"] == null ? null : json["wrong"],
    count: json["count"] == null ? null : json["count"],

  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "search_term": searchTerm == null ? null : searchTerm,
    "selected_character": selectedCharacter == null ? null : selectedCharacter,
    "topic_id": topicId == null ? null : topicId,
    "progress_index": progressIndex == null ? 0 : progressIndex,
    "course_id": courseId == null ? null : courseId,
    "correct": correct == null ? null : correct,
    "wrong": wrong == null ? null : wrong,
    "count": count == null ? null : count,
  };
}