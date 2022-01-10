import 'package:ecoach/database_nosql/sem_doa.dart';
import 'package:ecoach/models/question.dart';
import 'package:sembast/sembast.dart';

class AnswerDao {
  static const String STORE_NAME = 'answers';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Answer objects converted to Map
  StoreRef<int, Map<String, Object?>> _answerStore =
      intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SemDoa.instance.database;

  Future insert(Answer answer) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await _answerStore.add(txn, answer.toJson());
    });
  }

  Future update(Answer answer) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", answer.id));
    await _answerStore.update(
      await _db,
      answer.toJson(),
      finder: finder,
    );
  }

  Future delete(Answer answer) async {
    final finder = Finder(filter: Filter.equals("id", answer.id));
    await _answerStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<Answer?> getAnswerById(int id) async {
    var map = await _answerStore.findFirst(await _db,
        finder: Finder(filter: Filter.equals("id", id)));
    return map == null ? null : Answer.fromJson(map.value);
  }

  Future<void> insertAll(txn, List<Answer> answers) async {
    print("save answer len=${answers.length}");
    List<Map<String, Object?>> jsons = [];
    for (int i = 0; i < answers.length; i++) {
      jsons.add(answers[i].toJson());
    }

    await _answerStore.addAll(txn, jsons);
    print("done");
  }

  Future<List<Answer>> answers() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('created_at', false),
    ]);

    final recordSnapshots = await _answerStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Answer> out of List<RecordSnapshot>
    return recordSnapshots.map<Answer>((snapshot) {
      final answer = Answer.fromJson(snapshot.value);

      answer.key = snapshot.key;
      return answer;
    }).toList();
  }

  Future<List<Answer>> questoinAnswers(int questionId) async {
    // Finder object can also sort data.
    final finder = Finder(filter: Filter.equals("question_id", questionId));
    print("getting answers");
    final recordSnapshots = await _answerStore.find(
      await _db,
      finder: finder,
    );
    print('making list');
    // Making a List<Answer> out of List<RecordSnapshot>
    List<Answer> answers = recordSnapshots.map<Answer>((snapshot) {
      final answer = Answer.fromJson(snapshot.value);

      answer.key = snapshot.key;
      return answer;
    }).toList();

    print('returning answers');
    return answers;
  }
}
