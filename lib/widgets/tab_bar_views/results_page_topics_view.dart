import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/course_details.dart';
import 'package:ecoach/views/store.dart';
import 'package:ecoach/widgets/adeo_switch.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicsTabPage extends StatefulWidget {
  const TopicsTabPage({
    required this.topics,
    required this.diagnostic,
    required this.user,
    Key? key,
  }) : super(key: key);

  final List topics;
  final diagnostic;
  final user;

  @override
  _TopicsTabPageState createState() => _TopicsTabPageState();
}

class _TopicsTabPageState extends State<TopicsTabPage> {
  late bool showInPercentage;
  List selected = [];

  TextStyle rightWidgetStyle(bool isSelected) {
    return TextStyle(
      fontSize: 11,
      color: isSelected ? Colors.white : Color(0xFF2A9CEA),
    );
  }

  calculatePercentage(int totalNumberOfQuestions, int correctlyAnswered) {
    double fraction = correctlyAnswered / totalNumberOfQuestions;
    double percentage = fraction * 100;
    return percentage.toString() + '%';
  }

  handleSelection(topic) {
    if (selected.contains(topic))
      setState(() {
        selected =
            selected.where((selectedTopic) => selectedTopic != topic).toList();
      });
    else
      setState(() {
        selected = [...selected, topic];
      });
  }

  @override
  void initState() {
    showInPercentage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showInPercentage = !showInPercentage;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      '%',
                      style: TextStyle(
                        color: Color(0xFF2A9CEA),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(width: 5),
                    AdeoSwitch(
                      value: showInPercentage,
                      activeColor: Color(0xFF2A9CEA),
                      onChanged: (bool value) {
                        setState(() {
                          showInPercentage = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  isActive: selected.contains(widget.topics[i]),
                  title: widget.topics[i]['name'],
                  subTitle: widget.topics[i]['rating'],
                  rightWidget: showInPercentage
                      ? Text(
                          calculatePercentage(
                            widget.topics[i]['total_questions'],
                            widget.topics[i]['correctly_answered'],
                          ),
                          style: rightWidgetStyle(
                            selected.contains(widget.topics[i]),
                          ).copyWith(fontWeight: FontWeight.w700),
                        )
                      : Row(
                          children: [
                            Text(
                              widget.topics[i]['correctly_answered'].toString(),
                              style: rightWidgetStyle(
                                selected.contains(widget.topics[i]),
                              ).copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '/',
                              style: rightWidgetStyle(
                                selected.contains(widget.topics[i]),
                              ),
                            ),
                            Text(
                              widget.topics[i]['total_questions'].toString(),
                              style: rightWidgetStyle(
                                selected.contains(widget.topics[i]),
                              ),
                            ),
                          ],
                        ),
                ),
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
              if (selected.length > 0)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'review',
                          onPressed: () {},
                        ),
                      ),
                      Container(width: 1.0, color: kPageBackgroundGray),
                    ],
                  ),
                ),
              if (!widget.diagnostic && selected.length > 0)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Button(
                          label: 'revise',
                          onPressed: () async {},
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
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(CourseDetailsPage.routeName),
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
