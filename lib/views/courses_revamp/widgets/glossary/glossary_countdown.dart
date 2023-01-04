import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_instruction.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_quiz_view.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/glossary_view.dart';
import 'package:ecoach/views/learn/learn_course_completion.dart';
import 'package:ecoach/views/review/review_questions.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlossaryCountdown extends StatefulWidget {
  GlossaryCountdown({
    required this.user,
    required this.course,
    required this.listCourseKeywordsData,
    required this.glossaryProgressData,

    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  GlossaryProgressData? glossaryProgressData ;
  List<CourseKeywords> listCourseKeywordsData;


  @override
  State<GlossaryCountdown> createState() => _GlossaryCountdowneState();
}

class _GlossaryCountdowneState extends State<GlossaryCountdown> {
  int _currentPage = 0;
  late TimerController timerController;
  late Duration duration, resetDuration, startingDuration;
  bool disableTime = false;
  int countdownInSeconds = 0;
  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'Glossary opens in': continueBeginsInWidget()};
        case 1:
        return {'Glossary opens in': letGoWidget()};
    }
    return {'': Container()};
  }



  getTimerWidget() {
    return AdeoTimer(
        controller: timerController,
        startDuration: duration,
        callbackWidget: (time) {
          if (disableTime) {
            return Image(image: AssetImage("assets/images/infinite.png"));
          }

          Duration remaining = Duration(seconds: time.toInt());
          duration = remaining;
          countdownInSeconds = remaining.inSeconds;
          // if (remaining.inSeconds == 0) {
          //     return letGoWidget();
          // }
          return sText("${remaining.inSeconds % 60}",size: 100,weight: FontWeight.bold,color: Colors.white);

        },
        onFinish: () async{
          setState(() {
            _currentPage = 1;
          });
          Future.delayed(const Duration(seconds: 1), () async{
            List<GlossaryData> listGlossaryData = [];
            List topicIds = [];
                  if(isTopicSelected){

                    List<Topic> listTopics = await TopicDB().allCourseTopics(widget.course);
                    for(int i = 0; i < listTopics.length; i++){
                      topicIds.add(listTopics[i].id);
                    }
                    listGlossaryData =  await GlossaryDB().getGlossariesByTopicId(widget.course.id!,topicIds);
                    print("listGlossaryData:${listGlossaryData.length}");

                  }
                  else{
                    listGlossaryData =  await GlossaryDB().getGlossariesById(widget.course.id!);
                  }
                  if(listGlossaryData.isEmpty){
                    toastMessage("No glossary for this course");
                  }else{
                    if(studySelected){
                      Get.off(() => GlossaryView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,glossaryProgressData: widget.glossaryProgressData,));
                    }else{
                      Get.off(() => GlossaryQuizView(user: widget.user,course: widget.course,listGlossaryData: listGlossaryData,glossaryProgressData: widget.glossaryProgressData,));
                    }
                  }
             // Get.off(() => GlossaryInstruction(user: widget.user,course: widget.course,listCourseKeywordsData: widget.listCourseKeywordsData,glossaryProgressData: widget.glossaryProgressData,));
              // Get.off(() => const CreateAccountPage(),
              //     fullscreenDialog: true,
              //     duration: const Duration(
              //       seconds: 1,
              //     ));
            },
          );
        });
  }
  onEnd() async{
    print("timer ended");

  }
  startTimer() {
    if (disableTime) {
      timerController.start();
    }
  }

  resetTimer() {
    setState(() {
      duration = resetDuration;
    });
  }
  backPress(){
    setState(() {
        Navigator.pop(context);

      return;
    });
  }
  @override
  void initState() {
    timerController = TimerController();
    duration = Duration(seconds: 5);
    startingDuration = duration;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return  backPress();
      },
      child: Scaffold(
          backgroundColor: Color(0xFF00D289),
          appBar: AppBar(
            backgroundColor: Color(0xFF00D289),
            elevation: 0,
            leading: IconButton(onPressed: (){
              backPress();
            }, icon: Icon(Icons.arrow_back_ios)),
            centerTitle: true,
          ),
          body:getPage().values.first
      ),
    );
  }


  continueBeginsInWidget(){
    return Container(
      width: appWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             if(countdownInSeconds != 1)
            sText("Glossary opens in",color: Colors.white,size: 60,weight: FontWeight.bold,align: TextAlign.center),
            Spacer(),
            GestureDetector(
              onTap: ()async{
              },
              child: Container(
                child: getTimerWidget(),
              ),
            ),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }
  letGoWidget(){
    return Container(
      width: appWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()async{
              },
              child: Container(
                child: sText("Let's Go",color: Colors.white,size: 60,weight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }



}




