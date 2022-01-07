import 'package:ecoach/database_nosql/questions_doa.dart';
import 'package:ecoach/database_nosql/sem_doa.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:sembast/sembast.dart';

class CourseDao {
  static const String STORE_NAME = 'courses';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Course objects converted to Map
  StoreRef<int, Map<String, Object?>> _courseStore =
      intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SemDoa.instance.database;

  Future insert(Course course) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await _courseStore.add(txn, course.toJson());

      List<Question> questions = course.questions!;
      if (questions.length > 0) {
        QuestionDao().insertAll(questions);
      }
    });
  }

  Future update(Course course) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", course.id));
    await _courseStore.update(
      await _db,
      course.toJson(),
      finder: finder,
    );
  }

  Future delete(Course course) async {
    final finder = Finder(filter: Filter.equals("id", course.id));
    await _courseStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<Course?> getCourseById(int id) async {
    var map = await _courseStore.findFirst(await _db,
        finder: Finder(filter: Filter.equals("id", id)));
    return map == null ? null : Course.fromJson(map.value);
  }

  Future<void> insertAll(List<Course> courses) async {
    List<Map<String, Object?>> jsons = [];
    for (int i = 0; i < courses.length; i++) {
      jsons.add(courses[i].toJson());
    }
    await _courseStore.addAll(await _db, jsons);
  }

  Future<List<Course>> courses() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _courseStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Course> out of List<RecordSnapshot>
    return recordSnapshots.map<Course>((snapshot) {
      final course = Course.fromJson(snapshot.value);

      course.key = snapshot.key;
      return course;
    }).toList();
  }

  Future<List<Course>> levelCourses(int levelId) async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ], filter: Filter.equals("level_id", levelId));

    final levelCourses = await _courseStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = levelCourses.map((snapshot) {
      return snapshot.value;
    }).toList();

    List<Course> courses = [];
    for (int i = 0; i < maps.length; i++) {
      Course? course = await getCourseById(maps[i]["course_id"]);
      if (course != null) {
        print(course.toJson());
        courses.add(course);
      }
    }

    return courses;
  }
}
