import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/courses.dart';
import 'package:ecoach/views/notes/note_view.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/percentage_switch.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicsTabPage extends StatefulWidget {
  const TopicsTabPage({
    required this.topics,
    required this.diagnostic,
    required this.user,
    this.history = false,
    Key? key,
  }) : super(key: key);

  final List topics;
  final diagnostic;
  final user;
  final bool history;

  @override
  _TopicsTabPageState createState() => _TopicsTabPageState();
}

class _TopicsTabPageState extends State<TopicsTabPage> {
  late bool showInPercentage;
  late dynamic selected;

  TextStyle rightWidgetStyle(bool isSelected) {
    return TextStyle(
      fontSize: 11,
      color: isSelected ? Colors.white : Color(0xFF2A9CEA),
    );
  }

  handleSelection(topic) {
    setState(() {
      if (selected == topic)
        selected = null;
      else
        selected = topic;
    });
  }

  @override
  void initState() {
    showInPercentage = false;
    selected = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        PercentageSwitch(
          showInPercentage: showInPercentage,
          onChanged: (value) {
            setState(() {
              showInPercentage = value;
            });
          },
        ),
        SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.topics.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: MultiPurposeCourseCard(
                    onTap: () {
                      handleSelection(widget.topics[i]);
                    },
                    isActive: selected == widget.topics[i],
                    title: widget.topics[i]['name'],
                    subTitle: widget.topics[i]['rating'],
                    rightWidget: showInPercentage
                        ? PercentageSnippet(
                            correctlyAnswered: widget.topics[i]
                                ['correctly_answered'],
                            totalQuestions: widget.topics[i]['total_questions'],
                            isSelected: selected == widget.topics[i],
                          )
                        : FractionSnippet(
                            correctlyAnswered: widget.topics[i]
                                ['correctly_answered'],
                            totalQuestions: widget.topics[i]['total_questions'],
                            isSelected: selected == widget.topics[i],
                          )),
              );
            },
          ),
        ),
        Divider(
          thickness: 3.0,
          color: kPageBackgroundGray,
        ),
        Container(
          color: Colors.white,
          height: 48.0,
          child: Row(
            children: [
              if (selected != null)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: () {
                            if (widget.history) {
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic && selected != null)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'revise',
                          onPressed: () async {
                            int topicId = selected['topicId']!;
                            Topic? topic =
                                await TopicDB().getTopicById(topicId);

                            if (topic != null) {
                              // print(
                              //     "_______________________________________________________");
                              // print(topic.notes);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NoteView(widget.user, topic);
                                  });
                            } else {
                              showFeedback(context, "No notes available");
                            }
                          },
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic)
                Expanded(
                  child: Button(
                    label: 'new test',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              CoursesPage(widget.user),
                        ),
                      );
                    },
                  ),
                ),
              if (widget.diagnostic)
                Expanded(
                  child: Button(
                    label: 'Purchase',
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              StorePage(widget.user),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
