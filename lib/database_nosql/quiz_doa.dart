import 'package:ecoach/database_nosql/questions_doa.dart';
import 'package:ecoach/database_nosql/sem_doa.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/question.dart';
import 'package:sembast/sembast.dart';

class QuizDao {
  static const String STORE_NAME = 'quizzes';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Quiz objects converted to Map
  StoreRef<int, Map<String, Object?>> _quizStore =
      intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SemDoa.instance.database;

  Future insert(Quiz quizze) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await _quizStore.add(txn, quizze.toJson());

      List<Question> questions = quizze.questions!;
      if (questions.length > 0) {
        await QuestionDao().insertAll(txn, questions);
      }
    });
  }

  Future update(Quiz quizze) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", quizze.id));
    await _quizStore.update(
      await _db,
      quizze.toJson(),
      finder: finder,
    );
  }

  Future delete(Quiz quizze) async {
    final finder = Finder(filter: Filter.equals("id", quizze.id));
    await _quizStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<Quiz?> getQuizById(int id) async {
    var map = await _quizStore.findFirst(await _db,
        finder: Finder(filter: Filter.equals("id", id)));
    return map == null ? null : Quiz.fromJson(map.value);
  }

  Future<void> insertAll(List<Quiz> quizzes) async {
    print("inserting all quizzes");
    List<Map<String, Object?>> jsons = [];
    List<Map<String, Object?>> quizItems = [];
    for (int i = 0; i < quizzes.length; i++) {
      jsons.add(quizzes[i].toJson());
      List<Question> questions = quizzes[i].questions!;
      if (questions.length > 0) {
        for (int j = 0; j < questions.length; j++) {
          Question question = questions[j];
          quizItems.add({'quiz_id': quizzes[i].id, 'question_id': question.id});
        }
      }
    }
    Database db = await _db;
    await db.transaction((txn) async {
      await _quizStore.addAll(txn, jsons);

      StoreRef<int, Map<String, Object?>> _quizItemStore =
          intMapStoreFactory.store("quiz_items");
      await _quizItemStore.addAll(txn, quizItems);
    });
  }

  Future<List<Quiz>> quizzes() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('created_at', false),
    ]);

    final recordSnapshots = await _quizStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Quiz> out of List<RecordSnapshot>
    return recordSnapshots.map<Quiz>((snapshot) {
      final quizze = Quiz.fromJson(snapshot.value);
      quizze.key = snapshot.key;
      return quizze;
    }).toList();
  }

  Future<List<Quiz>> getQuizzesByType(int courseId, String type) async {
    final finder = Finder(
        sortOrders: [
          SortOrder('name'),
        ],
        filter: Filter.and([
          Filter.equals("course_id", courseId),
          Filter.equals("type", type)
        ]));

    final levelQuizs = await _quizStore.find(
      await _db,
      finder: finder,
    );

    final List<Quiz> quizzes = levelQuizs.map<Quiz>((snapshot) {
      final quizze = Quiz.fromJson(snapshot.value);
      quizze.key = snapshot.key;
      return quizze;
    }).toList();

    return quizzes;
  }

  Future<List<Quiz>> getQuizzesByName(int courseId, String name) async {
    final finder = Finder(
        sortOrders: [
          SortOrder('name'),
        ],
        filter: Filter.and([
          Filter.equals("course_id", courseId),
          Filter.matches("name", name)
        ]));

    final levelQuizs = await _quizStore.find(
      await _db,
      finder: finder,
    );

    final List<Quiz> quizzes = levelQuizs.map<Quiz>((snapshot) {
      final quizze = Quiz.fromJson(snapshot.value);
      quizze.key = snapshot.key;
      return quizze;
    }).toList();

    return quizzes;
  }

  Future<List<Question>> getQuestions(int quizId, int limit) async {
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ], filter: Filter.equals("quiz_id", quizId));

    StoreRef<int, Map<String, Object?>> _quizItemStore =
        intMapStoreFactory.store("quiz_items");

    final quizItem = await _quizItemStore.find(
      await _db,
      finder: finder,
    );

    List<Map<String, dynamic>> maps = quizItem.map((snapshot) {
      return snapshot.value;
    }).toList();

    maps.shuffle();
    Iterable<Map<String, dynamic>> listMaps = maps.getRange(0, limit);
    maps = listMaps.toList();

    List<Question> questions = [];
    for (int i = 0; i < maps.length; i++) {
      Question? question =
          await QuestionDao().getQuestionById(maps[i]['question_id']);
      if (question != null) {
        questions.add(question);
      }
    }

    return questions;
  }

  Future<int> quizCount(int courseId) async {
    final finder = Finder(filter: Filter.equals("course_id", courseId));

    final quizzes = await _quizStore.find(
      await _db,
      finder: finder,
    );

    List<Map<String, dynamic>> maps = quizzes.map((snapshot) {
      return snapshot.value;
    }).toList();

    return maps.length;
  }

  Future<int> getQuestionsCount(int quizId) async {
    final finder = Finder(filter: Filter.equals("quiz_id", quizId));

    StoreRef<int, Map<String, Object?>> _quizItemStore =
        intMapStoreFactory.store("quiz_items");

    final quizItem = await _quizItemStore.find(
      await _db,
      finder: finder,
    );

    List<Map<String, dynamic>> maps = quizItem.map((snapshot) {
      return snapshot.value;
    }).toList();

    return maps.length;
  }
}
