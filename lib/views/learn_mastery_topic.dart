import 'package:ecoach/controllers/study_mastery_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database_nosql/questions_doa.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/mastery_course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/study_quiz_view.dart';
import 'package:flutter/material.dart';

class LearnMasteryTopic extends StatelessWidget {
  const LearnMasteryTopic(
    this.user,
    this.course,
    this.progress, {
    Key? key,
    required this.topics,
  }) : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;
  final List<MasteryCourse> topics;

  final TextStyle auxTextStyle = const TextStyle(
    fontSize: 20.0,
    color: kAdeoGray3,
    fontWeight: FontWeight.w500,
  );

  final TextStyle listStyle = const TextStyle(
    fontSize: 15.0,
    color: kDefaultBlack,
    height: 3.0,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 56.0,
            padding: EdgeInsets.only(
              top: 32.0,
              left: 24.0,
              right: 24.0,
              bottom: 32.0,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Text(
                      '${topics.length}',
                      style: TextStyle(
                        color: kAdeoGray3,
                        fontSize: 100.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Positioned(
                      bottom: 32,
                      child: Container(
                        height: 1.5,
                        width: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            double.infinity,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: darken(kAdeoGray2, 80),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Topic',
                  style: auxTextStyle,
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                Text(
                  topics[0].topicName!,
                  style: auxTextStyle,
                ),
                SizedBox(
                  width: 222.0,
                  child: Divider(
                    color: kAdeoGray2,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 1; i < topics.length; i++)
                          Text(topics[i].topicName!, style: listStyle),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              List<Question> questions = await QuestionDao()
                  .getMasteryTopicQuestions(topics[0].topicId!, 10);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return StudyQuizView(
                    controller: MasteryController(user, course,
                        questions: questions,
                        name: progress.name!,
                        progress: progress));
              }));
            },
            child: Container(
              alignment: Alignment.center,
              height: 56.0,
              width: double.infinity,
              color: kAdeoGreen,
              child: Text(
                'let\'s go',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
