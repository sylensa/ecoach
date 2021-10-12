import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/notes_bottom_button.dart';
import 'package:ecoach/widgets/search_bars/notes_search_bar.dart';
import 'package:flutter/material.dart';

class NotesTopics extends StatefulWidget {
  const NotesTopics({Key? key});

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
    topics = [
      Topic(label: 'Density', imageURL: 'assets/icons/topics/density.png'),
      Topic(label: 'Matter', imageURL: 'assets/icons/topics/matter.png'),
      Topic(label: 'Pressure', imageURL: 'assets/icons/topics/pressure.png'),
      Topic(label: 'Forces', imageURL: 'assets/icons/topics/pressure.png'),
      Topic(label: 'Waves', imageURL: 'assets/icons/topics/density.png'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
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
      onTap: onTap,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? kAdeoWhiteAlpha81 : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 28.0,
            bottom: 16.0,
          ),
          child: Column(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                child: Image.asset(
                  topic.imageURL,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: Text(
                  topic.label,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? kDefaultBlack : Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Topic {
  const Topic({required this.label, required this.imageURL});

  final String label;
  final String imageURL;
}