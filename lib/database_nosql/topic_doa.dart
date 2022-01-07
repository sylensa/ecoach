import 'package:ecoach/database_nosql/sem_doa.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/topic.dart';
import 'package:sembast/sembast.dart';

class TopicDao {
  static const String STORE_NAME = 'topics';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent record, values of which are Topic objects converted to Map
  StoreRef<int, Map<String, Object?>> _topicStore =
      intMapStoreFactory.store(STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await SemDoa.instance.database;

  Future insert(Topic topic) async {
    Database db = await _db;
    await db.transaction((txn) async {
      await _topicStore.add(txn, topic.toJson());
    });
  }

  Future update(Topic topic) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals("id", topic.id));
    await _topicStore.update(
      await _db,
      topic.toJson(),
      finder: finder,
    );
  }

  Future delete(Topic topic) async {
    final finder = Finder(filter: Filter.equals("id", topic.id));
    await _topicStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<Topic?> getTopicById(int id) async {
    var record = await _topicStore.findFirst(await _db,
        finder: Finder(filter: Filter.equals("id", id)));
    return record == null ? null : Topic.fromJson(record.value);
  }

  Future<void> insertAll(List<Topic> topics) async {
    List<Map<String, Object?>> jsons = [];
    for (int i = 0; i < topics.length; i++) {
      jsons.add(topics[i].toJson());
    }
    await _topicStore.addAll(await _db, jsons);
  }

  Future<List<Topic>> topics() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _topicStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Topic> out of List<RecordSnapshot>
    return recordSnapshots.map<Topic>((snapshot) {
      final topic = Topic.fromJson(snapshot.value);

      topic.key = snapshot.key;
      return topic;
    }).toList();
  }

  Future<Topic?> getLevelTopic(int courseId, int level) async {
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ], filter: Filter.equals("course_id", courseId));

    final courseTopics = await _topicStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = courseTopics.map((snapshot) {
      return snapshot.value;
    }).toList();

    if (level > maps.length || level < 1) {
      return null;
    }

    return Topic.fromJson(maps[level - 1]);
  }

  Future<List<Topic>> getTopics(List<int> topicIds) async {
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ], filter: Filter.inList("topic_id", topicIds));

    final recordSnapshots = await _topicStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    List<Topic> topics = [];
    for (int i = 0; i < maps.length; i++) {
      Topic topic = Topic.fromJson(maps[i]);
      topics.add(topic);
    }
    return topics;
  }

  Future<List<Topic>> courseTopics(Course course) async {
    final finder = Finder(
        sortOrders: [
          SortOrder('name'),
        ],
        filter: Filter.and([
          Filter.equals('course_id', course.id!),
          Filter.notEquals("notes", "")
        ]));

    final recordSnapshots = await _topicStore.find(
      await _db,
      finder: finder,
    );

    final List<Map<String, dynamic>> maps = recordSnapshots.map((snapshot) {
      return snapshot.value;
    }).toList();

    List<Topic> topics = [];
    for (int i = 0; i < maps.length; i++) {
      Topic topic = Topic.fromJson(maps[i]);
      topics.add(topic);
    }
    return topics;
  }
}
