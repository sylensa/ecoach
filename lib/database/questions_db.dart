import 'package:ecoach/database/answers.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/database.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/topic.dart';
import 'package:sqflite/sqflite.dart';

class QuestionDB {
  Future<void> insert(Question question) async {
    if (question == null) {
      return;
    }
    // print(question.toJson());
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Topic? topic = question.topic;
      if (topic != null) {
        await TopicDB().insert(topic);
      }
      List<Answer> answers = question.answers!;
      if (answers.length > 0) {
        for (int i = 0; i < answers.length; i++) {
          await AnswerDB().insert(answers[i]);
        }
      }
    });
  }

  Future<void> insertTestQuestion(Question question) async {
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'test_saved_questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<void> insertConquestQuestion(Question question) async {
    final Database? db = await DBProvider.database;
    db!.transaction((txn) async {
      txn.insert(
        'conquest_questions',
        question.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<Question?> getConquestQuestionById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("conquest_questions", where: "id = ?", whereArgs: [id]);
    Question? question =
    result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<List<Question>> getConquestQuestionByCorrectUnAttempted(int courseId,{int confirm = 0,bool unseen = false}) async {
    final Database? db = await DBProvider.database;
    final List<Map<String, dynamic>> maps;
    List<int> questionIds = [];
    List<Question> questions = [];
    if(unseen){
      maps = await db!.rawQuery("SELECT * FROM conquest_questions WHERE course_id = $courseId ORDER BY RANDOM()");
      // if(maps.isEmpty){
      //   questions = await QuestionDB().getQuestionsByCourseId(courseId);
      //   for (int i = 0; i < questions.length; i++) {
      //     questionIds.add(questions[i].id!);
      //   }
      // }
    }else{
       maps = await db!.rawQuery("SELECT * FROM conquest_questions WHERE course_id = $courseId and confirmed = $confirm ORDER BY RANDOM()");
    }

    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
      questionIds.add(question.id!);
    }
    if(unseen){
      questions.clear();
      questions = await getQuestionsByQuestionIds(questionIds,courseId);
      print("questions:${questions.length}");
    }
    return questions;
  }

  Future<void> batchInsert(Batch batch, Question question) async {
    if (question == null) {
      return;
    }
    batch.insert(
      'questions',
      question.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    List<Answer> answers = question.answers!;
    if (answers.length > 0) {
      for (int i = 0; i < answers.length; i++) {
        await AnswerDB().batchInsert(batch, answers[i]);
      }
    }
  }

  Future<Question?> getQuestionById(int id) async {
    final db = await DBProvider.database;
    var result = await db!.query("questions", where: "id = ?", whereArgs: [id]);
    Question? question =
        result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }
  Future<List<Question>> getQuestionByKeywordByTopic(String keyword,int topicId,{int currentQuestionCount = 0}) async {
    print("keyword:$keyword");
    print("currentQuestionCount:$currentQuestionCount");
    List<Question> questions = [];
    List<Question> allQuestions = [];
    final db = await DBProvider.database;
    var result = await db!.rawQuery("select * from questions where topic_id = $topicId");
    print("result:${result.length}");
    for(int i = 0; i < result.length; i++){
      Question question = Question.fromJson(result[i]) ;
      if(question.text!.toLowerCase().contains(keyword.toLowerCase())){
        question.answers = await AnswerDB().questoinAnswers(question.id!);
        questions.add(question);
      }
      if(question.resource!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }
      if(question.instructions!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }

      for(int t = 0; t < question.answers!.length; t++){
        if(question.answers![t].text!.toLowerCase().contains(keyword.toLowerCase())){
          questions.add(question);
        }
      }

    }
    if(currentQuestionCount <= questions.length ){
      for(int i = currentQuestionCount; i < questions.length; i++){
        allQuestions.add(questions[i]);
      }
    }

    print("questions:${allQuestions.length}");
    return allQuestions.isNotEmpty ? allQuestions : questions;
  }
  Future<List<Question>> getQuestionByKeyword(String keyword,int courseId,{int currentQuestionCount = 0}) async {
    print("keyword:$keyword");
    print("currentQuestionCount:$currentQuestionCount");
    List<Question> questions = [];
    List<Question> allQuestions = [];
    final db = await DBProvider.database;
    var result = await db!.rawQuery("select * from questions where course_id = $courseId");
    print("result:${result.length}");
    for(int i = 0; i < result.length; i++){
      Question question = Question.fromJson(result[i]) ;
      if(question.text!.toLowerCase().contains(keyword.toLowerCase())){
        question.answers = await AnswerDB().questoinAnswers(question.id!);
        questions.add(question);
      }
      if(question.resource!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }
      if(question.instructions!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }

      for(int t = 0; t < question.answers!.length; t++){
        if(question.answers![t].text!.toLowerCase().contains(keyword.toLowerCase())){
          questions.add(question);
        }
      }

    }
    if(currentQuestionCount <= questions.length ){
      for(int i = currentQuestionCount; i < questions.length; i++){
        allQuestions.add(questions[i]);
      }
    }

    print("questions:${allQuestions.length}");
    return allQuestions.isNotEmpty ? allQuestions : questions;
  }
  Future<List<Question>> getTotalQuestionByKeyword(String keyword, int courseId) async {
    print("keyword:$keyword");
    List<Question> questions = [];
    final db = await DBProvider.database;
    var result = await db!.rawQuery("select * from questions where course_id = $courseId");
    for(int i = 0; i < result.length; i++){
      Question question = Question.fromJson(result[i]) ;
      if(question.text!.toLowerCase().contains(keyword.toLowerCase())){
        question.answers = await AnswerDB().questoinAnswers(question.id!);
        questions.add(question);
      }
      if(question.resource!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }
      if(question.instructions!.toLowerCase().contains(keyword.toLowerCase())){
        questions.add(question);
      }

      for(int t = 0; t < question.answers!.length; t++){
        if(question.answers![t].text!.toLowerCase().contains(keyword.toLowerCase())){
          questions.add(question);
        }
      }
    }


    return  questions;
  }
  Future<Question?> getQuestionByIdTopicId(int qid,int tid) async {
    final db = await DBProvider.database;
    var result = await db!.query("questions", where: "id = ? AND topic_id = ?", whereArgs: [qid,tid]);
    Question? question =
        result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<List<Question>> getSavedTestQuestion() async {
    final db = await DBProvider.database;
    List<Question> listQuestion = [];
    // await db!.rawQuery("Delete from test_saved_questions");
    List<Map<String, dynamic>> timelineResponse =
        await db!.rawQuery("Select * from test_saved_questions");
    print("timelineResponse:$timelineResponse");
    if (timelineResponse.isNotEmpty) {
      for (int i = 0; i < timelineResponse.length; i++) {
        Question? question = Question.fromJson(timelineResponse[i]);
        if (question != null) {
          question.answers = await AnswerDB().questoinAnswers(question.id!);
        }
        listQuestion.add(question);
      }
    }

    return listQuestion;
  }

  Future<Question?> getSavedTestQuestionById(int id) async {
    final db = await DBProvider.database;
    var result = await db!
        .query("test_saved_questions", where: "id = ?", whereArgs: [id]);
    Question? question =
        result.isNotEmpty ? Question.fromJson(result.first) : null;
    if (question != null) {
      question.answers = await AnswerDB().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<List<Question>> getSavedTestQuestionsByType(int courseId,
      {int limit = 10}) async {
    final Database? db = await DBProvider.database;

    // final List<Map<String, dynamic>> maps = await db!.query('test_saved_questions',
    //     orderBy: "created_at DESC",
    //     where: "course_id = ?",
    //     whereArgs: [courseId],);

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM test_saved_questions WHERE course_id = $courseId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<void> insertAll(List<Question> questions) async {
    final Database? db = await DBProvider.database;
    Batch batch = db!.batch();
    questions.forEach((element) async {
      // print(element.toJson());
      batch.insert(
        'questions',
        element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Topic? topic = element.topic;
      if (topic != null) {
        await TopicDB().insert(topic);
      }
      List<Answer> answers = element.answers!;
      if (answers.length > 0) {
        answers.forEach((answer) async {
          await AnswerDB().insert(answer);
        });
      }
    });

    await batch.commit(noResult: true);
  }

  Future<List<Question>> questions() async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        where: "qtype = ?", whereArgs: ['SINGLE'], orderBy: "created_at DESC");

    return List.generate(maps.length, (i) {
      return Question(
        id: maps[i]["id"],
        courseId: maps[i]["course_id"],
        topicId: maps[i]["topic_id"],
        qid: maps[i]["qid"],
        text: maps[i]["text"],
        instructions: maps[i]["instructions"],
        resource: maps[i]["resource"],
        options: maps[i]["options"],
        position: maps[i]["position"],
        createdAt: DateTime.parse(maps[i]["created_at"]),
        updatedAt: DateTime.parse(maps[i]["updated_at"]),
        qtype: maps[i]["qtype"],
      );
    });
  }

  Future<Map<int, String>> questionTopics(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "topic_name ASC",
        columns: ["topic_id", "topic_name"],
        distinct: true,
        where: "course_id = ? AND qtype = ?",
        whereArgs: [courseId, 'SINGLE']);

    Map<int, String> topicNames = Map();
    for (int i = 0; i < maps.length; i++) {
      topicNames[maps[i]['topic_id']] = maps[i]['topic_name'];
    }
    return topicNames;
  }

  Future<int> getTopicCount(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'questions',
      where: "topic_id = ?",
      whereArgs: [topicId],
    );

    return maps.length;
  }

  Future<List<Question>> getTopicQuestions(List<int> topicIds, limit) async {
    final Database? db = await DBProvider.database;

    String amps = "";
    for (int i = 0; i < topicIds.length; i++) {
      amps += "${topicIds[i]}";
      if (i < topicIds.length - 1) {
        amps += ",";
      }
    }

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id IN ($amps) ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }
  Future<List<Question>> getQuestionsByQuestionIds(List<int> questionIds,int courseId) async {
    final Database? db = await DBProvider.database;

    String amps = "";
    for (int i = 0; i < questionIds.length; i++) {
      amps += "${questionIds[i]}";
      if (i < questionIds.length - 1) {
        amps += ",";
      }
    }

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND id NOT IN ($amps) AND course_id = $courseId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }
  Future<List<Question>> getQuestionsByQuestionsIDs(List<int> questionIds, bool isNotIn) async {
    final Database? db = await DBProvider.database;

    String amps = "";
    for (int i = 0; i < questionIds.length; i++) {
      amps += "${questionIds[i]}";
      if (i < questionIds.length - 1) {
        amps += ",";
      }
    }
    print("amps:$amps");
    final List<Map<String, dynamic>> maps;
    if(isNotIn){
      maps = await db!.rawQuery("SELECT * FROM questions WHERE qtype = 'SINGLE' AND id NOT IN ($amps) ORDER BY RANDOM() limit 5");
    }else{
      maps = await db!.rawQuery("SELECT * FROM questions WHERE qtype = 'SINGLE' AND id IN ($amps) ORDER BY RANDOM()");

    }

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getRandomQuestions(int courseId, int limit) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMasteryQuestions(int courseId, int limit) async {
    final Database? db = await DBProvider.database;

    Course? course = await CourseDB().getCourseById(courseId);
    // print("course ${course!.toJson()}");
    if (course == null) {
      return [];
    }
    List<Topic>? topics = await TopicDB().allCourseTopics(course);
    print("topic length=${topics.length}");
    List<Question> questions = [];
    for (int i = 0; i < topics.length; i++) {
      questions.addAll(await getMasteryTopicQuestions(topics[i].id!, 4));
    }

    return questions;
  }

  Future<List<Question>> getMasteryTopicQuestions(
      int topicId, int limit) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM() LIMIT $limit");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMarathonQuestions(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
      "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM()",
    );

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMarathonTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillQuestions(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
      "SELECT * FROM questions WHERE qtype = 'SINGLE' AND course_id = $courseId ORDER BY RANDOM()",
    );

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getTreadmillBankQuestions(int bankId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND bank_id = $bankId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getAutopilotTopicQuestions(int topicId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.rawQuery(
        "SELECT * FROM questions WHERE qtype = 'SINGLE' AND topic_id = $topicId ORDER BY RANDOM()");

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getQuestionsByType(
    int courseId,
    String type,
    int limit,
  ) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        where: "course_id = ? AND qtype = ?",
        whereArgs: [courseId, type],
        limit: limit);

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getQuestionsByCourseId(
      int courseId,
      ) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query('questions',
        orderBy: "created_at DESC",
        where: "course_id = ?",
        whereArgs: [courseId],);

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDB().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<int> getTotalQuestionCount(int courseId) async {
    final Database? db = await DBProvider.database;

    final List<Map<String, dynamic>> maps = await db!.query(
      'questions',
      where: "course_id = ?",
      whereArgs: [courseId],
    );

    return maps.length;
  }

  Future<void> update(Question question) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'questions',
      question.toJson(),
      where: "id = ?",
      whereArgs: [question.id],
    );
  }

  Future<void> updateConquest(Question question) async {
    // ignore: unused_local_variable
    final db = await DBProvider.database;

    await db!.update(
      'conquest_questions',
      question.toJson(),
      where: "id = ?",
      whereArgs: [question.id],
    );
  }

  delete(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAllQuestions() async {
    final db = await DBProvider.database;
    db!.delete('questions');
  }

  deleteSavedTest(int id) async {
    final db = await DBProvider.database;
    db!.delete(
      'test_saved_questions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  deleteAllSavedTest() async {
    final db = await DBProvider.database;
    db!.delete('test_saved_questions');
  }
  deleteAllConquestTest() async {
    final db = await DBProvider.database;
    db!.delete('conquest_questions');
  }

  deleteSavedTestByCourseId(int id) async {
    final db = await DBProvider.database;
    db!.rawQuery("Delete from test_saved_questions where course_id = $id");
  }

  // getRevisionLevelQuestions(Course course, ){

  // }
}
