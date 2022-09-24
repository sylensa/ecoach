import 'package:ecoach/controllers/study_controller.dart';
import 'package:ecoach/controllers/study_revision_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/models/study.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/learn/learn_mode.dart';
import 'package:ecoach/views/learn/learning_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/topics_db.dart';
import '../../models/topic.dart';
import '../../new_ui_ben/providers/welcome_screen_provider.dart';
import '../../new_ui_ben/screens/revision/revision.dart';

class LearnRevision extends StatefulWidget {
  static const String routeName = '/learning/revision';
  const LearnRevision(this.user, this.course, this.progress, {Key? key})
      : super(key: key);
  final User user;
  final Course course;
  final StudyProgress progress;

  @override
  _LearnRevisionState createState() => _LearnRevisionState();
}

class _LearnRevisionState extends State<LearnRevision> {
  @override
  Widget build(BuildContext context) {
    return Revision(
      progress: widget.progress,
      onTap: () async {
        int topicId = widget.progress.topicId!;

        // getQuestionByRevisionLevel() async {
        int currentRevisionLevel =
            Provider.of<WelcomeScreenProvider>(context, listen: false)
                .currentRevisionProgressLevel;

        Topic? topic = await TopicDB()
            .getLevelTopic(widget.course.id!, currentRevisionLevel);

        // }

        List<Question> questions =
            await QuestionDB().getTopicQuestions([topic!.id!], 10);

        // Create revision study progress object
        // RevisionStudyProgress revisionStudyProgress = RevisionStudyProgress(
        //   courseId: widget.course.id,
        //   studyId: widget.progress.studyId,
        //   topicId: widget.progress.topicId,
        //   level: 1,
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );

        // await StudyDB().insertRevisionProgress(revisionStudyProgress).then((value){
        //   print("revision progress inserted successfully");
        // }).catchError((e){
        //   print('there was an error $e');
        // });

        RevisionStudyProgress? studyProgress =
            await StudyDB().getCurrentRevisionProgressByCourse(widget.course.id!);
        print("this is the progress of revision: ${studyProgress}");

        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: LearnRevision.routeName),
            builder: (context) {
              return LearningWidget(
                controller: RevisionController(
                  widget.user,
                  widget.course,
                  name: topic.name ?? widget.course.name!,
                  questions: questions,
                  progress: widget.progress,
                ),
              );
            },
          ),
        );
      },
    );

    // SafeArea(
    //   child: Scaffold(
    //     body: SingleChildScrollView(
    //       child: Container(
    //         height: MediaQuery.of(context).size.height,
    //         color: Colors.white,
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 OutlinedButton(
    //                     onPressed: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: Text(
    //                       "return",
    //                       style: TextStyle(color: Color(0xFF9C9C9C)),
    //                     )),
    //                 SizedBox(
    //                   width: 50,
    //                 )
    //               ],
    //             ),
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   SizedBox(
    //                     height: 30,
    //                   ),
    //                   Text(
    //                     "Revision Mode",
    //                     style: TextStyle(
    //                         color: Color(0xFF00C664),
    //                         fontSize: 29,
    //                         fontWeight: FontWeight.w600),
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   ),
    //                   SizedBox(
    //                     width: 232,
    //                     child: Text(
    //                       "We will take you through a series of questions. Whilst we do that we will help you revise topics you seem to struggle with.",
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                           fontSize: 12,
    //                           fontStyle: FontStyle.italic,
    //                           color: Color(0xFFA39A9A)),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 40,
    //                   ),
    //                   Image(
    //                     image:
    //                         AssetImage('assets/images/learning_revision.png'),
    //                     width: 282,
    //                     height: 282,
    //                   ),
    //                   // Spacer(),
    //                 ],
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
    //               child: OutlinedButton(
    //                 onPressed: () async {
    //                   int topicId = widget.progress.topicId!;
    //                   List<Question> questions =
    //                       await QuestionDB().getTopicQuestions([topicId], 10);
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       settings:
    //                           RouteSettings(name: LearnRevision.routeName),
    //                       builder: (context) {
    //                         return LearningWidget(
    //                           controller: RevisionController(
    //                             widget.user,
    //                             widget.course,
    //                             name:
    //                                 widget.progress.name ?? widget.course.name!,
    //                             questions: questions,
    //                             progress: widget.progress,
    //                           ),
    //                         );
    //                       },
    //                     ),
    //                   );
    //                 },
    //                 child: Text("Enter"),
    //                 style: ButtonStyle(
    //                   fixedSize: MaterialStateProperty.all(Size(150, 44)),
    //                   foregroundColor:
    //                       MaterialStateProperty.all(Color(0xFF00C664)),
    //                   side: MaterialStateProperty.all(BorderSide(
    //                       color: Color(0xFF00C664),
    //                       width: 1,
    //                       style: BorderStyle.solid)),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
