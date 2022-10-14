import 'dart:convert';
import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/controllers/offline_save_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/questions_db.dart';
import 'package:ecoach/database/quiz_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/flag_model.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/test_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class QuizController {
  QuizController(
    this.user,
    this.course, {
    this.level,
    this.type = TestType.NONE,
    this.challengeType = TestCategory.NONE,
    this.questions = const [],
    required this.name,
    this.time = 30,
    this.timing = 'Time per Quiz',
  }) {
    duration = Duration(seconds: time);
    resetDuration = Duration(seconds: time);
    startingDuration = duration;

    timerController = TimerController();
    speedTest = type == TestType.SPEED ? true : false;
    disableTime = type == TestType.UNTIMED ? true : false;
  }

  final User user;
  final Course course;
  Level? level;
  List<Question> questions;
  final String name;
  TestType type;
  TestCategory challengeType;
  int time;
  String timing;

  bool disableTime = false;
  bool speedTest = false;

  bool enabled = true;
  bool reviewMode = false;
  bool savedTest = false;
  Map<int, bool> saveQuestion = new Map();

  int currentQuestion = 0;
  int finalQuestion = 0;

  DateTime? startTime;
  Duration? duration, resetDuration, startingDuration;
  int endTime = 0;
  TimerController? timerController;
  int countdownInSeconds = 0;
  List<ListNames> listReportsTypes = [ListNames(name: "Select Error Type",id: "0"),ListNames(name: "Typographical Mistake",id: "1"),ListNames(name: "Wrong Answer",id: "2"),ListNames(name: "Problem With The Question",id: "3")];
  ListNames? reportTypes;
  TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionNode = FocusNode();
  startTest() {
    timerController!.start();
    startTime = DateTime.now();
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * time;
  }

  bool get lastQuestion {
    return currentQuestion == questions.length - 1;
  }

  double get percentageCompleted {
    if (questions.length < 1) return 0;
    return (currentQuestion + 1) / questions.length;
  }

  double get score {
    int totalQuestions = questions.length;
    int correctAnswers = correct;
    return correctAnswers / totalQuestions * 100;
  }

  int get correct {
    int score = 0;
    questions.forEach((question) {
      if (question.isCorrect) score++;
    });
    return score;
  }

  int get wrong {
    int wrong = 0;
    questions.forEach((question) {
      if (question.isWrong) wrong++;
    });
    return wrong;
  }

  int get unattempted {
    int unattempted = 0;
    questions.forEach((question) {
      if (question.unattempted) unattempted++;
    });
    return unattempted;
  }

  String get responses {
    Map<String, dynamic> responses = Map();
    int i = 1;
    questions.forEach((question) {
      print(question.topicName);
      Map<String, dynamic> answer = {
        "question_id": question.id,
        "topic_id": question.topicId,
        "topic_name": question.topicName,
        "selected_answer_id": question.selectedAnswer != null
            ? question.selectedAnswer!.id
            : null,
        "status": question.isCorrect
            ? "correct"
            : question.isWrong
                ? "wrong"
                : "unattempted",
      };

      responses["Q$i"] = answer;
      i++;
    });
    return jsonEncode(responses);
  }

  saveTest(BuildContext context, Function(TestTaken? test, bool success) callback,{int? groupId,int? testId}) async {
    TestTaken testTaken = TestTaken(
        id :user.id,
        userId: user.id,
        testId: testId,
        datetime: startTime,
        totalQuestions: questions.length,
        courseId: course.id,
        testname: name,
        testType: type.toString(),
        challengeType: challengeType.toString(),
        testTime: duration == null ? -1 : duration!.inSeconds,
        usedTime: DateTime.now().difference(startTime!).inSeconds,
        responses: responses,
        score: score,
        correct: correct,
        wrong: wrong,
        groupId: groupId,
        unattempted: unattempted,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());

    print("testing connection ${jsonEncode(testTaken)}");
    print("testing connection courseName ${testTaken.courseName}");
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      print("not connectied");
      await OfflineSaveController(context, user).saveTestTaken(testTaken);
      callback(testTaken, true);
    } else {
      ApiCall<TestTaken>(AppUrl.testTaken,
          user: user,
          isList: false,
          params: testTaken.toJson(), create: (json) {
        return TestTaken.fromJson(json);
      }, onError: (err) {
        OfflineSaveController(context, user).saveTestTaken(testTaken);
        callback(testTaken, false);
      }, onCallback: (data) {
        print('onCallback');
        print(data);
        TestController().saveTestTaken(data!);
        callback(data, true);
      }).post(context);
    }


      // print("not connectied");
      // await OfflineSaveController(context, user).saveTestTaken(testTaken);
      // callback(testTaken, true);
      //
      // ApiCall<TestTaken>(AppUrl.testTaken,
      //     user: user,
      //     isList: false,
      //     params: testTaken.toJson(), create: (json) {
      //       return TestTaken.fromJson(json);
      //     }, onError: (err) {
      //       OfflineSaveController(context, user).saveTestTaken(testTaken);
      //       callback(testTaken, false);
      //     }, onCallback: (data) {
      //       print('onCallback');
      //       print(data);
      //       TestController().saveTestTaken(data!);
      //       callback(data, true);
      //     }).post(context);

  }

  saveFlagQuestion(BuildContext context, FlagData flagData,int questionId) async {
    var token = (await UserPreferences().getUserToken());
    print("token:$token");
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      print("not connectied");
     var id =  await OfflineSaveController(context, user).saveFlagQuestion(flagData);
     if(id != null){
       return true;
     }
      return false;
    } else {
      // try{
        var res = await doPost("${AppUrl.questionFlag}${questionId}/flag",flagData.toJson(),);
        print("res:$res");
        if(res["code"].toString() == "200"){
          return true;
        }else{
          var id =  await OfflineSaveController(context, user).saveFlagQuestion(flagData);
          print("offline id: $id");
          return true;
        }
      // }catch(e){
      //   print("error:$e");
      //   return false;
      // }
    }


  }


  saveAnswer() {}

  enableQuestion(bool state) {
    saveQuestion[currentQuestion] = state;
  }

  questionEnabled(int i) {
    if (i > saveQuestion.length - 1) return enabled;
    return saveQuestion[i];
  }

  pauseTimer() {
    timerController!.pause();
  }

  stopTimer() {
    timerController!.pause();
  }

  resetTimer() {
    print("resetTimer");
    timerController!.reset();
    Future.delayed(Duration(seconds: 1), () {
      timerController!.start();
    });
    print(duration!.inSeconds);
  }

  Duration getDuration() {
    return startingDuration!;
  }

  reportModalBottomSheet(context,{Question? question}) async{
    double sheetHeight = 400.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        child: Icon(Icons.warning,color: Colors.orange,size: 50,),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200]
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: sText("Error Reporting",weight: FontWeight.bold,size: 20),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 40,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.only(left: 12, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ListNames>(
                                    value: reportTypes == null ? listReportsTypes[0] : reportTypes,
                                    itemHeight: 48,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: kDefaultBlack,
                                    ),
                                    // onTap: (){
                                    //   stateSetter((){
                                    //     sheetHeight = 400;
                                    //   });
                                    // },

                                    onChanged: (ListNames? value){
                                      stateSetter((){
                                        reportTypes = value;
                                        sheetHeight = 700;
                                        FocusScope.of(context).requestFocus(descriptionNode);
                                      });
                                    },
                                    items: listReportsTypes.map(
                                          (item) => DropdownMenuItem<ListNames>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                            color: kDefaultBlack,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Container(
                              padding: EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      controller: descriptionController,
                                      focusNode: descriptionNode,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please check that you\'ve entered your email correctly';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value){
                                        stateSetter((){
                                          sheetHeight = 400;
                                        });
                                      },
                                      onTap: (){
                                        stateSetter((){
                                          sheetHeight = 700;
                                        });
                                      },
                                      decoration: textDecorNoBorder(
                                        hint: 'Description',
                                        radius: 10,
                                        labelText: "Description",
                                        hintColor: Colors.black,
                                        fill: Colors.white,
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40,),



                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{
                          print("${reportTypes}");
                          if(descriptionController.text.isNotEmpty){
                            if( reportTypes != null){
                              stateSetter((){
                                isSubmit = false;
                              });
                              try{
                                FlagData flagData = FlagData(reason: descriptionController.text,type:reportTypes!.name,questionId:question!.id );
                                var res = await saveFlagQuestion(context, flagData,question.id!);
                                print("final res:$res");
                                if(res){
                                  stateSetter((){
                                    descriptionController.clear();
                                  });
                                  Navigator.pop(context);
                                  successModalBottomSheet(context);
                                }else{
                                  Navigator.pop(context);
                                  failedModalBottomSheet(context);
                                  print("object res: $res");
                                }
                              }catch(e){
                                stateSetter((){
                                  isSubmit = true;
                                });
                                print("error: $e");
                              }
                            }else{
                              toastMessage("Select error type");
                            }
                          }
                          else{
                            toastMessage("Description is required");
                          }
                        },
                        child: Container(
                          padding: appPadding(20),
                          width: appWidth(context),
                          color: isSubmit ?  Colors.blue : Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              sText("Submit",align: TextAlign.center,weight: FontWeight.bold,color: isSubmit ? Colors.white : Colors.black,size: 25),
                              SizedBox(width: 10,),
                              isSubmit ? Container() : progress()
                            ],
                          ),

                        ),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  successModalBottomSheet(context,{Question? question}){
    double sheetHeight = 400.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.green,width: 15),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.check,color: Colors.green,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Error report successfully submitted",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  failedModalBottomSheet(context,{Question? question}){
    double sheetHeight = 400.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.red,width: 15),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.close,color: Colors.red,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Error report failed try again",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
}
