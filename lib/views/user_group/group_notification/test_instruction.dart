import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/controllers/quiz_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/group_notification_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/user_group/group_activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_quiz/group_quiz_question.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TestInstruction extends StatefulWidget {
  static const String routeName = '/user_group';
  TestInstruction(this.user,{Key? key,this.groupNotificationData}) : super(key: key);
  User user;
  GroupNotificationData? groupNotificationData;
  @override
  State<TestInstruction> createState() => _TestInstructionState();
}

class _TestInstructionState extends State<TestInstruction> {
  TextEditingController searchController = TextEditingController();
  CountdownTimerController? controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 3;

  getTimerWidget(String duration,{bool isStartTime = true}){
    var lastConsoString3= Duration(hours:int.parse(duration.split(":").first),minutes: int.parse(duration.split(":").last),seconds: 0,);
    var _lastConso = DateTime.now().subtract(lastConsoString3);
    var diff = DateTime.now().difference(_lastConso);
    print( diff.inSeconds);
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 *  diff.inSeconds;
    controller = CountdownTimerController(endTime: endTime, onEnd: _onEnd);


    return  CountdownTimer(
      controller: controller,
      onEnd: _onEnd,
      endTime: endTime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(isStartTime ? "Test in progress" : "Test Completed");
        }
        return Column(
          children: [
            Text('${time.days != null ? time.days : "00"}:${time.hours != null ? time.hours : "00"}:${time.min != null ? time.min : "00"} : ${time.sec}'),
            sText(isStartTime? "Time remaining to start" : "Time remaining to complete",weight: FontWeight.normal,size: 10),
          ],
        );
      },
    );
  }

  void _onEnd() {
    print('onEnd');
  }
  @override
 void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        color: Color(0XFFE2EFF3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h, right: 2.h),
              decoration: BoxDecoration(
                color: Color(0XFFE2EFF3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 4.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back,color: Colors.black,),
                        ),
                        SizedBox(width: 20,),
                        sText("Test",weight: FontWeight.bold,size: 20),

                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        color: Color(0XFFF7B06E),
                      ),
                      SizedBox(width: 20,),
                      sText("${widget.groupNotificationData!.notificationtable!.configurations!.startDatetime!.toString().split(".").first} - ${widget.groupNotificationData!.notificationtable!.configurations!.dueDateTime!.toString().split(".").first}",weight: FontWeight.w500,size: 12,color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("${widget.groupNotificationData!.notificationtable!.name}",weight: FontWeight.w500,size: 20,color: Colors.black),
                  SizedBox(height: 5,),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/question-mark.png"),
                              SizedBox(width: 5,),
                              sText("10Q",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/clock.png"),
                              SizedBox(width: 5,),
                              sText("${widget.groupNotificationData!.notificationtable!.configurations!.timing! == "Time per Question" ? "${widget.groupNotificationData!.notificationtable!.configurations!.countDown!}secs per question" : widget.groupNotificationData!.notificationtable!.configurations!.timing! == "Time per Quiz" ? "Complete quiz in ${widget.groupNotificationData!.notificationtable!.configurations!.countDown!} minutes " : "Untimed Quiz"}",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        if(widget.groupNotificationData!.notificationtable!.configurations!.startDatetime!.compareTo(DateTime.now()) > 0)
                          getTimerWidget(widget.groupNotificationData!.notificationtable!.configurations!.startDatetime.toString().split(" ").last.split(".").first,isStartTime:true)

                      else if(widget.groupNotificationData!.notificationtable!.configurations!.dueDateTime!.compareTo(DateTime.now()) > 0)
                      getTimerWidget(widget.groupNotificationData!.notificationtable!.configurations!.dueDateTime.toString().split(" ").last.split(".").first,isStartTime: false)

                      else
                         sText("Test Completed",weight: FontWeight.normal,size: 10, color: Color(0XFF00C9B9),),

                      ],
                    ),
                  )

                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                width: appWidth(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sText("Instruction",weight: FontWeight.bold,size: 16,align: TextAlign.left),
                        SizedBox(height: 20,),
                        sText("${widget.groupNotificationData!.notificationtable!.instructions}"),

                      ],
                    ),
                    GestureDetector(
                      onTap: ()async{
                        showLoaderDialog(context);
                       var res = await GroupManagementController(groupId: widget.groupNotificationData!.groupId.toString()).getUserGroupTestTaken(testId: int.parse(widget.groupNotificationData!.notificationtable!.configurations!.testId!));
                        if(res){
                          Navigator.pop(context);
                          showDialogOk(context: context,message: "You have already taken this test");
                        }else{
                          if(widget.groupNotificationData!.notificationtable!.configurations!.startDatetime!.compareTo(DateTime.now()) > 0){
                            Navigator.pop(context);
                            toastMessage("Test not started yet");
                          }
                          else if(widget.groupNotificationData!.notificationtable!.configurations!.dueDateTime!.compareTo(DateTime.now()) > 0){
                            List<Question> questions = [];
                            List<int> topicIds = [];
                            topicIds.add(int.parse(widget.groupNotificationData!.notificationtable!.configurations!.testId!));
                            switch (widget.groupNotificationData!.notificationtable!.configurations!.testType) {
                              case "bank":
                              case "exam":
                              case "essay":
                                questions = await TestController().getQuizQuestions(
                                  topicIds[0],
                                  limit: 10,
                                );
                                break;
                              case "topic":
                                questions = await TestController().getTopicQuestions(
                                  topicIds,
                                  limit: 10,
                                );
                                break;
                              default:
                                questions = await TestController().getMockQuestions(0);
                            }
                            Course? course =  await CourseDB().getCourseByName(widget.groupNotificationData!.notificationtable!.configurations!.course!);
                            if(course != null && questions.isNotEmpty){
                              Navigator.pop(context);
                              goTo(context, GroupQuizQuestion(
                                controller: QuizController(
                                  widget.user,
                                  course,
                                  timing: widget.groupNotificationData!.notificationtable!.configurations!.timing!,
                                  questions: questions,
                                  name: widget.groupNotificationData!.notificationtable!.name!,
                                  time: widget.groupNotificationData!.notificationtable!.configurations!.timing! == "Time per Question" ? widget.groupNotificationData!.notificationtable!.configurations!.countDown! : 60 * widget.groupNotificationData!.notificationtable!.configurations!.countDown! ,
                                  type: TestType.KNOWLEDGE,
                                  challengeType: TestCategory.TOPIC,
                                ),
                                diagnostic: true,
                                groupId: widget.groupNotificationData!.groupId!,
                                testId: int.parse(widget.groupNotificationData!.notificationtable!.configurations!.testId!),
                              ),);
                            }else{
                              Navigator.pop(context);
                              showDialogOk(context: context,message: "Course does not exist or questions are empty");
                            }
                          }else{
                            Navigator.pop(context);
                            toastMessage("Test Completed");
                          }
                        }



                      },
                      child: Container(
                        width: appWidth(context),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        decoration: BoxDecoration(
                            color: Color(0XFF00C9B9),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(child: sText("Start Test",color: Colors.white,weight: FontWeight.w500)),
                      ),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),

      ),

    );
  }
}
