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
                      sText("09:30 - 10:30 am",weight: FontWeight.w500,size: 12,color: Colors.black),
                      Expanded(child: Container()),
                      sText("03:59",weight: FontWeight.w500,size: 18,color: Color(0XFF8ED4EB)),
                    ],
                  ),
                  SizedBox(height: 10,),
                  sText("Maths Assessment",weight: FontWeight.w500,size: 20,color: Colors.black),
                  SizedBox(height: 5,),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/question-mark.png"),
                              SizedBox(width: 5,),
                              sText("30Q",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          child: Row(
                            children: [
                              Image.asset("assets/images/clock.png"),
                              SizedBox(width: 5,),
                              sText("1 hour",weight: FontWeight.w500,size: 12,color: Colors.black),
                            ],
                          ),
                        ),
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
                              questions: questions,
                              name: widget.groupNotificationData!.notificationtable!.name!,
                              time: widget.groupNotificationData!.notificationtable!.configurations!.countDown!,
                              type: TestType.KNOWLEDGE,
                              challengeType: TestCategory.TOPIC,
                            ),
                            diagnostic: true,
                          ),);
                        }else{
                          Navigator.pop(context);
                          showDialogOk(context: context,message: "Course does not exist or questions are empty");
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
