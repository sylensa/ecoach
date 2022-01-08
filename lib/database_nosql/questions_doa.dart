import 'package:ecoach/database_nosql/sem_doa.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/question.dart';
import 'package:sembast/sembast.dart';

import 'answers_doa.dart';

class QuestionDao {
  static const String STORE_NAME = 'questions';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Question objects converted to Map
  StoreRef<int, Map<String, Object?>> _questionStore =
      intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SemDoa.instance.database;

  Future insert(Question question) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await _questionStore.add(txn, question.toJson());
      List<Answer> answers = question.answers!;
      if (answers.length > 0) {
        for (int i = 0; i < answers.length; i++) {
          await AnswerDao().insert(answers[i]);
        }
      }
    });
  }

  Future update(Question question) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", question.id));
    await _questionStore.update(
      await _db,
      question.toJson(),
      finder: finder,
    );
  }

  Future delete(Question question) async {
    final finder = Finder(filter: Filter.equals("id", question.id));
    await _questionStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<Question?> getQuestionById(int id) async {
    var map = await _questionStore.findFirst(await _db,
        finder: Finder(filter: Filter.equals("id", id)));
    Question? question = map == null ? null : Question.fromJson(map.value);
    if (question != null) {
      question.answers = await AnswerDao().questoinAnswers(question.id!);
    }

    return question;
  }

  Future<void> insertAll(txn, List<Question> questions) async {
    print("inser questions");
    List<Map<String, Object?>> jsons = [];
    List<Answer> answers = [];
    for (int i = 0; i < questions.length; i++) {
      jsons.add(questions[i].toJson());
      answers.addAll(questions[i].answers!);
    }
    print("questions = ${jsons.length}");

    // for (int i = 0; i < jsons.length; i++) {
    //   print("saving a question id = $i");
    //   await _questionStore.add(txn, jsons[i]);
    // }
    await _questionStore.addAll(txn, jsons);
    print("saving answers");
    if (answers.length > 0) {
      await AnswerDao().insertAll(txn, answers);
    }
  }

  Future<List<Question>> questions() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Question> out of List<RecordSnapshot>
    return recordSnapshots.map<Question>((snapshot) {
      final question = Question.fromJson(snapshot.value);

      question.key = snapshot.key;
      return question;
    }).toList();
  }

  Future<Map<int, String>> questionTopics(int courseId) async {
    final finder = Finder(
        sortOrders: [SortOrder("topic_name")],
        filter: Filter.and([
          Filter.equals('course_id', courseId),
          Filter.equals('qtype', 'SINGLE')
        ]));

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    Map<int, String> topicNames = Map();
    for (int i = 0; i < maps.length; i++) {
      topicNames[maps[i]['topic_id']] = maps[i]['topic_name'];
    }
    return topicNames;
  }

  Future<int> getTopicCount(int topicId) async {
    final finder = Finder(filter: Filter.equals('topic_id', topicId));

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    return maps.length;
  }

  Future<List<Question>> getTopicQuestions(List<int> topicIds, limit) async {
    final finder = Finder(
        sortOrders: [SortOrder('created_by', false)],
        filter: Filter.and([
          Filter.inList("topic_id", topicIds),
          Filter.equals('qtype', 'SINGLE')
        ]),
        limit: limit);

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );
    final List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDao().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getRandomQuestions(int courseId, int limit) async {
    final finder = Finder(
      filter: Filter.and([
        Filter.equals("course_id", courseId),
        Filter.equals('qtype', 'SINGLE')
      ]),
    );

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );
    List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    maps.shuffle();
    Iterable<Map<String, dynamic>> listMaps = maps.getRange(0, limit);
    maps = listMaps.toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDao().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMasteryQuestions(int courseId, int limit) async {
    final finder = Finder(
      filter: Filter.and(
        [
          Filter.equals("course_id", courseId),
          Filter.equals('qtype', 'SINGLE')
        ],
      ),
    );

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );
    List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    maps.shuffle();
    Iterable<Map<String, dynamic>> listMaps = maps.getRange(0, limit);
    maps = listMaps.toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDao().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getMasteryTopicQuestions(
      int topicId, int limit) async {
    final finder = Finder(
      filter: Filter.and(
        [Filter.equals("topic_id", topicId), Filter.equals('qtype', 'SINGLE')],
      ),
    );

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );
    List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    maps.shuffle();
    Iterable<Map<String, dynamic>> listMaps = maps.getRange(0, limit);
    maps = listMaps.toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDao().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<List<Question>> getQuestionsByType(
      int courseId, String type, int limit) async {
    final finder = Finder(
        filter: Filter.and(
          [Filter.equals("course_id", courseId), Filter.equals("qtype", type)],
        ),
        limit: limit);

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );

    List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question question = Question.fromJson(maps[i]);
      question.answers = await AnswerDao().questoinAnswers(question.id!);
      questions.add(question);
    }

    return questions;
  }

  Future<int> getTotalQuestionCount(int courseId) async {
    final finder = Finder(
      filter: Filter.equals("course_id", courseId),
    );

    final recordSnapshots = await _questionStore.find(
      await _db,
      finder: finder,
    );

    List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    return maps.length;
  }
}
