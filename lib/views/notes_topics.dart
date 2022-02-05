import 'package:ecoach/models/notes_read.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/database/notes_read_db.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/note_view.dart';
import 'package:ecoach/widgets/buttons/notes_bottom_button.dart';
import 'package:ecoach/widgets/search_bars/notes_search_bar.dart';
import 'package:flutter/material.dart';

class NotesTopics extends StatefulWidget {
  static const String routeName = '/notestopic';
  const NotesTopics(this.user, this.topics, {Key? key});

  final User user;
  final List<Topic> topics;

  @override
  _NotesTopicsState createState() => _NotesTopicsState();
}

class _NotesTopicsState extends State<NotesTopics> {
  String searchString = '';
  bool selected = false;
  int selectedTopicIndex = -1;
  List<Topic> topics = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      topics = widget.topics;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Topic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.topics;
    } else {
      results = widget.topics
          .where((topic) =>
              topic.name!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    // Refresh the UI
    setState(() {
      topics = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoBlue,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: kAdeoBlue,
          child: Column(
            children: [
              NotesSearchBar(
                searchHint: 'Search topics',
                onChanged: (str) {
                  setState(() {
                    searchString = str;
                    _runFilter(searchString);
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    left: 24.0,
                    right: 24.0,
                    bottom: 56.0,
                  ),
                  // child: GridView.count(
                  //   crossAxisCount: 3,
                  //   crossAxisSpacing: 12.0,
                  //   mainAxisSpacing: 12.0,
                  //   children: topics.map((topic) {
                  //     int index = topics.indexOf(topic);
                  //     return NotesTopicCard(
                  //       topic: topic,
                  //       isSelected: selectedTopicIndex == index,
                  //       onTap: () {
                  //         setState(() {
                  //           selected = true;
                  //           selectedTopicIndex = index;
                  //         });
                  //       },
                  //     );
                  //   }).toList(),
                  // ),
                  child: ListView(
                    children: topics.map((topic) {
                      int index = topics.indexOf(topic);
                      return NotesTopicCard(
                        topic: topic,
                        isSelected: selectedTopicIndex == index,
                        onTap: () {
                          setState(() {
                            selected = true;
                            selectedTopicIndex = index;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (selected)
                NotesBottomButton(
                  label: 'Read Notes',
                  onTap: () {
                    Topic topic = topics[selectedTopicIndex];
                    NotesReadDB().insert(NotesRead(
                        courseId: topic.courseId,
                        name: topic.name,
                        notes: topic.notes,
                        topicId: topic.id,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now()));

                    print(
                        "_______________________________________________________");
                    print(topics[selectedTopicIndex].notes);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NoteView(widget.user, topic);
                        });
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}

class NotesTopicCard extends StatelessWidget {
  const NotesTopicCard({
    required this.topic,
    this.isSelected = false,
    this.onTap,
  });

  final Topic topic;
  final onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Feedback.wrapForTap(onTap, context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? kAdeoWhiteAlpha81 : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              child: topic.imageURL != null
                  ? Center(
                      child: Image.asset(
                        topic.imageURL!,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Center(
                      child: Text(
                        topic.name!.substring(0, 1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? kDefaultBlack : Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Text(
                topic.name!,
                style: TextStyle(
                  color: isSelected ? kDefaultBlack : Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
