import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/test_taken_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/learn/learn_course_completion.dart';
import 'package:ecoach/views/review/review_questions.dart';
import 'package:ecoach/widgets/adeo_timer.dart';
import 'package:ecoach/widgets/questions_widgets/quiz_screen_widgets.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ReviewOnBoarding extends StatefulWidget {
  ReviewOnBoarding({
    required this.user,
    required this.course,
    required this.testType,
    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  final TestType testType;

  @override
  State<ReviewOnBoarding> createState() => _ReviewOnBoardingeState();
}

class _ReviewOnBoardingeState extends State<ReviewOnBoarding> {
  List <ListNamesReview> listChallenge = [ListNamesReview(name: "Topic",id: "1",testCategory: TestCategory.TOPIC),ListNamesReview(name: "Mock",id: "2",testCategory: TestCategory.MOCK),ListNamesReview(name: "Bank",id: "3",testCategory: TestCategory.BANK),ListNamesReview(name: "Saved",id: "4",testCategory: TestCategory.SAVED)];
  // List <ListNamesReview> listTopics = [ListNamesReview(name: "Acids",id: "1"),ListNamesReview(name: "Base",id: "2"),ListNamesReview(name: "Capillary",id: "3")];
  List <ListNamesReview> selectedChallenge = [];
  List <TestNameAndCount> selectedListTopics = [];
  int _currentPage = 0;
  TestCategory? testCategory;
  List<TestNameAndCount> listTopics = [];
  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'Review': startWidget()};
      // case 1:
      //   return {'Select your Course': selectCourseWidget()};
      case 1:
        return {'Choose  Option': selectTestWidget()};

      case 2:
        return {'${selectedChallenge.isNotEmpty ? selectedChallenge[0].testCategory.toString().split(".").last : ""}': selectTopicWidget()};

      case 3:
        return {'${selectedListTopics.isNotEmpty ? selectedListTopics[0].name : "Topic Name"}': summaryWidget()};
        // continue
      case 4:
        return {'': nextSummaryWidget()};

      case 5:
        return {'Instructions': instructionWidget()};

      case 6:
        return {'Review continues in': continueBeginsInWidget()};

        // restart

      case 7:
        return {'': cautionWidget()};

      case 8:
        return {'Review begins in': restartBeginsInWidget()};

    }
    return {'': Container()};
  }
  List<Question> questions = [];
  List<Question> reviewQuestions = [];
  ReviewTestTaken? reviewTestTaken;
  bool isContinue = false;
  late TimerController timerController;
  late Duration duration, resetDuration, startingDuration;
  bool disableTime = false;
  int countdownInSeconds = 0;
  late Color backgroundColor, backgroundColor2;
  // getTest2(BuildContext context, TestCategory testCategory)async {
  //   Future futureList;
  //   try{
  //     switch (testCategory) {
  //       case TestCategory.MOCK:
  //         List<Question> questions = await TestController().getMockTests(widget.course);
  //         if(questions.isNotEmpty){
  //           Navigator.pop(context);
  //          await goTo(context, ReviewQuestions(user: widget.user,listQuestionsReview: questions,testType: widget.testType,course: widget.course));
  //           setState(() {
  //             isContinue = false;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //         break;
  //       case TestCategory.EXAM:
  //         listTopics.clear();
  //         listTopics = await TestController().getExamTests(widget.course);
  //         if(listTopics.isNotEmpty){
  //           Navigator.pop(context);
  //           setState(() {
  //             _currentPage ++;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //         break;
  //       case TestCategory.TOPIC:
  //       // List<Question> questions = await TestController().getTopics(widget.course);
  //         listTopics = await TestController().getTopics(widget.course);
  //         if(listTopics.isNotEmpty){
  //           Navigator.pop(context);
  //           setState(() {
  //             _currentPage ++;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //
  //         break;
  //       case TestCategory.ESSAY:
  //         listTopics = await TestController().getEssayTests(widget.course);
  //         if(listTopics.isNotEmpty){
  //           Navigator.pop(context);
  //           setState(() {
  //             _currentPage ++;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //         break;
  //       case TestCategory.SAVED:
  //         List<Question> questions =  TestController().getSavedTests(widget.course);
  //         if(questions.isNotEmpty){
  //           Navigator.pop(context);
  //           goTo(context, ReviewQuestions(user: widget.user,listQuestionsReview: questions,testType: widget.testType,course: widget.course,));
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //         break;
  //       case TestCategory.BANK:
  //         listTopics = await TestController().getBankTest(widget.course);
  //         if(listTopics.isNotEmpty){
  //           Navigator.pop(context);
  //           setState(() {
  //             _currentPage ++;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //         break;
  //       default:
  //         listTopics = await TestController().getBankTest(widget.course);
  //         if(listTopics.isNotEmpty){
  //           Navigator.pop(context);
  //           setState(() {
  //             _currentPage ++;
  //           });
  //         }else{
  //           showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
  //         }
  //     }
  //   }catch(e){
  //     print("$e");
  //     Navigator.pop(context);
  //   }
  //
  //
  // }

  getOtherTopicsQuestions(TestCategory testCategory)async {

    switch (testCategory) {
      case TestCategory.BANK:
      reviewQuestions = await TestController().getQuizQuestions(
          selectedListTopics[0].id!,
          limit: 1000,
        );
      reviewTestTaken = null;
        if(reviewQuestions.isNotEmpty){
          await getReviewTestTaken(topicId: selectedListTopics[0].id.toString());
          print("bank reviewTestTaken:$reviewTestTaken");
          if(reviewQuestions.isNotEmpty){
            if(reviewTestTaken != null){
              setState(() {
                _currentPage++;
              });
            }else{
              setState(() {
                _currentPage  = 4;
              });
            }

          }

        }else{
          showDialogOk(message: "No questions available",context: context,dismiss: false,status: false);
        }

        break;
      case TestCategory.TOPIC:
        List<int> topicIds = [];
        selectedListTopics.forEach((element) {
          topicIds.add(element.id!);
        });
        reviewQuestions = await TestController().getTopicQuestions(
          topicIds,
          limit: () {
            return 1000;
          }(),
        );
        reviewTestTaken = null;
         await getReviewTestTaken(topicId: selectedListTopics[0].id.toString());
        if(reviewQuestions.isNotEmpty){
          if(reviewTestTaken != null){
            setState(() {
              _currentPage++;
            });
          }else{
            setState(() {
              _currentPage  = 4;
            });
          }

        }else{
          showDialogOk(message: "No questions available",context: context,dismiss: false,status: false);
        }
        break;
      default:
        questions = await TestController().getMockQuestions(0);
        setState(() {
          _currentPage ++;

        });
    }
  }

  getTest(BuildContext context, TestCategory testCategory)async {
    Future futureList;
    try{
      switch (testCategory) {
        case TestCategory.TOPIC:
          futureList = TestController().getTopics(widget.course,);
          break;
        case TestCategory.MOCK:
          Question? q;
          futureList = TestController().getMockTests(widget.course,limit: 1000);
          break;
        case TestCategory.BANK:
          futureList = TestController().getBankTest(widget.course);
          break;
        case TestCategory.SAVED:
          futureList = TestController().getSavedTests(widget.course,limit: 1000);
          break;
        default:
          futureList = TestController().getBankTest(widget.course);
      }
      futureList.then(
            (data) async{
          // Navigator.pop(context);

              switch (testCategory) {
                case TestCategory.MOCK:
                  reviewQuestions = data as List<Question>;
                  reviewTestTaken = null;
                  if(reviewQuestions.isNotEmpty){
                    await getReviewTestTaken(topicId: "0");
                    if(reviewQuestions.isNotEmpty){
                      if(reviewTestTaken != null){
                        setState(() {
                          _currentPage += 2;
                        });
                      }else{
                        setState(() {
                          _currentPage  = 4;
                        });
                      }

                    }
                    print("mock:$reviewTestTaken");
                    Navigator.pop(context);
                    // setState((){
                    //   _currentPage += 2;
                    // });
                  }else{
                    Navigator.pop(context);
                    showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
                  }
                  break;
                case TestCategory.TOPIC:
                  listTopics = await TestController().getTopics(widget.course);
                  reviewTestTaken = null;
                  if(listTopics.isNotEmpty){
                    Navigator.pop(context);
                    setState((){
                      _currentPage++;
                    });
                  }else{
                    Navigator.pop(context);
                    showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
                  }
                  break;
                case TestCategory.BANK:
                  listTopics = await TestController().getBankTest(widget.course);
                  reviewTestTaken = null;
                  if(listTopics.isNotEmpty){
                    Navigator.pop(context);
                    setState((){
                      _currentPage++;
                    });
                  }else{
                    Navigator.pop(context);
                    showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
                  }
                  break;
                case TestCategory.SAVED:
                  reviewQuestions = data as List<Question>;
                  reviewTestTaken = null;
                  if(reviewQuestions.isNotEmpty){
                    await getReviewTestTaken(topicId: "0");
                    if(reviewQuestions.isNotEmpty){
                      if(reviewTestTaken != null){
                        setState(() {
                          _currentPage += 2;
                        });
                      }else{
                        setState(() {
                          _currentPage  = 4;
                        });
                      }

                    }
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                    showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
                  }
                  break;
                default:
                  listTopics = await TestController().getBankTest(widget.course);
                  reviewTestTaken = null;
                  if(listTopics.isNotEmpty){
                    Navigator.pop(context);
                    setState((){
                      _currentPage++;
                    });
                  }else{
                    Navigator.pop(context);
                    showDialogOk(message: "No question available",context: context,dismiss: false,status: false);
                  }
              }
        },
      );
    }catch(e){
      print("$e");
      Navigator.pop(context);
    }


  }

  getReviewTestTaken({String topicId = "0"}) async{
    print("topicId:$topicId");
    reviewTestTaken =  await TestTakenDB().getReviewTestTakenByTopicIdCourseId(topicId: topicId,courseId: widget.course.id!,category: selectedChallenge[0].testCategory.toString());
    if(reviewTestTaken != null){
      print("reviewTestTaken:${reviewTestTaken!.toJson()}");
    }else{
      print("reviewTestTaken:$reviewTestTaken");
    }
    setState(() {
    });
  }

  getall()async{
    ReviewTestTaken? res = await TestTakenDB().getReviewTestTaken();
    print("res:${res!.toJson()}");
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
          if (remaining.inSeconds == 0) {
            return sText("GO",size: 100,weight: FontWeight.bold,color: Colors.white);
          }
          return sText("${remaining.inSeconds % 60}",size: 100,weight: FontWeight.bold,color: Colors.white);
          return Text("${remaining.inSeconds % 60}",
              style: TextStyle(color: backgroundColor, fontSize: 30));
        },
        onFinish: () async{
          // onEnd();
          if(isContinue){
            _currentPage =  await goTo(context, ReviewQuestions(user: widget.user,listQuestionsReview: reviewQuestions,testType: widget.testType,course: widget.course,topicId: selectedListTopics.isNotEmpty ? selectedListTopics[0].id!.toString() : "0",questionIndex: reviewTestTaken!.count! > 0 ? reviewTestTaken!.count! -1 : 0,reviewTestTaken: reviewTestTaken,testCategory: selectedChallenge[0].testCategory,));
          }else{
            _currentPage =  await goTo(context, ReviewQuestions(user: widget.user,listQuestionsReview: reviewQuestions,testType: widget.testType,course: widget.course,topicId: selectedListTopics.isNotEmpty ? selectedListTopics[0].id!.toString() : "0",reviewTestTaken: reviewTestTaken,testCategory: selectedChallenge[0].testCategory,));
          }
          setState(() {
            // isContinue = false;
          });
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
      print(reviewTestTaken);
      // if current page  == 0
      isContinue = false;
      if(_currentPage == 0){
        Navigator.pop(context);
      }
      // if current page equals 7 return to 3
      if(_currentPage == 7){
        _currentPage = 3;
        return;
      }
      // if current page equals 7 and no test taken return to 3
      if(_currentPage == 8 && reviewTestTaken == null){
        _currentPage = 5;
        return;
      }
      // if current page equals 8 and has test taken return to 7

      else if(_currentPage == 8 && reviewTestTaken != null){
        _currentPage = 7;
        return;
      }
      // with no topics and no test taken
      if(_currentPage == 4 && reviewTestTaken == null){
        if(selectedListTopics.isNotEmpty){
          _currentPage -= 2;;
        }else{
          _currentPage = 1;
        }
        return;
      }

      // with topics and test taken
      if(_currentPage == 3 && reviewTestTaken != null){
        if(selectedListTopics.isNotEmpty){
          _currentPage--;
        }else{
          _currentPage = 1;
        }
        return;
      }
      if(reviewQuestions.isNotEmpty){
        // reviewQuestions.clear();
        _currentPage -= 1;

        return;
      }
      _currentPage--;
    });
  }
  @override
  void initState() {
    getall();
    backgroundColor = const Color(0xFF5DA5EA);
    backgroundColor2 = const Color(0xFF5DA5CA);
    timerController = TimerController();
    duration = Duration(seconds: 5);
    resetDuration = Duration(seconds: 5);
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
        backgroundColor: reviewBackgroundColors,
        appBar: AppBar(
          backgroundColor: reviewBackgroundColors,
          elevation: 0,
          leading: IconButton(onPressed: (){
            backPress();
          }, icon: Icon(Icons.arrow_back_ios)),
          title: sText("${getPage().keys.first}",color: Colors.white,size: 20,weight: FontWeight.bold),
          centerTitle: true,
        ),
        body:getPage().values.first
      ),
    );
  }

  startWidget(){
     return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
              child: sText("Choose your preferred subject",color: Colors.white),
            ),
            SizedBox(height: 50,),
            Expanded(
              child: Container(
                child:Image.asset("assets/review/creative.png",),
                decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage("assets/review/path.png",),
                   // fit: BoxFit.fill,
                 )
                ),
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                setState(() {
                  _currentPage++;

                });
              },
              child: Container(
                width: appWidth(context),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: sText("Get Started",color: Colors.white,weight: FontWeight.bold,size: 25,align: TextAlign.center),
                color: reviewSelectedColor,
              ),
            ),
            // SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  selectTestWidget(){
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 20,),
            // Container(
            //   child: sText("Choose your preferred subject",color: Colors.white),
            // ),
            SizedBox(height: 50,),
            Expanded(
              child: ListView.builder(
                  itemCount: listChallenge.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedListTopics.clear();
                          selectedChallenge.clear();
                          selectedChallenge.add(listChallenge[index]);
                          print(selectedChallenge[0].testCategory);
                        });
                      },
                      child: Center(
                        child: Container(
                          width: appWidth(context),
                          margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          child: sText("${listChallenge[index].name}",weight: FontWeight.bold,color: Colors.white,size: selectedChallenge.contains(listChallenge[index]) ? 45 : 35,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color:selectedChallenge.contains(listChallenge[index]) ? reviewSelectedColor : reviewBackgroundColors,
                              border: Border.all(color: selectedChallenge.contains(listChallenge[index]) ? Colors.white : Colors.transparent,width: 1),
                              borderRadius: BorderRadius.circular(selectedChallenge.contains(listChallenge[index]) ? 10 : 0)
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            selectedChallenge.isNotEmpty ?
            GestureDetector(
              onTap: (){
                showLoaderDialog(context);
                getTest(context, selectedChallenge[0].testCategory!);

                // setState(() {
                //   _currentPage ++;
                //
                // });
              },
              child: Container(
                width: appWidth(context),
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                child: sText("Next",color: Colors.white,weight: FontWeight.bold,size: 25,align: TextAlign.center),
                color: reviewSelectedColor,
              ),
            ) : Container(),
            // SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  selectTopicWidget(){
    return Container(
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 50,),
            Expanded(
              child: ListView.builder(
                  itemCount: listTopics.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: ()async{
                          selectedListTopics.clear();
                          selectedListTopics.add(listTopics[index]);
                        await getReviewTestTaken(topicId: selectedListTopics[0].id.toString());
                        setState(() {

                        });

                      },
                      child: Center(
                        child: Container(
                          width: appWidth(context),
                          margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                  child: sText("${listTopics[index].name}",weight: FontWeight.bold,color: Colors.white,size: selectedListTopics.contains(listTopics[index]) ? 20 : 16,align: TextAlign.left),
                              ),
                              selectedListTopics.contains(listTopics[index]) ?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      if(reviewTestTaken != null)
                                      for(int i = 0; i < reviewTestTaken!.completed! ; i++)
                                      Icon(Icons.star,color: Colors.orange,size: 10,)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  sText("${listTopics[index].totalCount}Q",color: Colors.white,weight: FontWeight.bold)
                                ],
                              ) : Container()
                            ],
                          ),
                          decoration: BoxDecoration(
                              color:selectedListTopics.contains(listTopics[index]) ? reviewSelectedColor : reviewBackgroundColors,
                              border: Border.all(color: selectedListTopics.contains(listTopics[index]) ? Colors.white : Colors.transparent,width: 1),
                              borderRadius: BorderRadius.circular(selectedListTopics.contains(listTopics[index]) ? 10 : 0)
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            selectedListTopics.isNotEmpty ?
            GestureDetector(
              onTap: ()async{
                print("object:${selectedListTopics[0].name}");
                await getOtherTopicsQuestions(selectedListTopics[0].category!);
                setState((){

                });
              },
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                margin: EdgeInsets.symmetric(vertical: 70,),
                child: sText("Next",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                decoration: BoxDecoration(
                  color: reviewSelectedColor,
                  borderRadius: BorderRadius.circular(60)
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  summaryWidget(){
    return Container(
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
              width: appWidth(context),
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
              child: Text.rich(
                TextSpan(
                    text: 'You have completed ',
                    style: appStyle(col: Colors.white),

                    children: <InlineSpan>[

                      TextSpan(
                        text:'${((reviewTestTaken!.count!/reviewQuestions.length) * 100).toStringAsFixed(1)}%',
                        style: appStyle(col: Colors.orange,weight: FontWeight.bold),

                      ),

                      TextSpan(
                        text:' of your current session, You can ${ reviewTestTaken!.count == reviewQuestions.length ? "Restart" : "continue or Restart"}.',
                        style: appStyle(col: Colors.white),

                      )
                    ]
                ),



              ),
            ),
            SizedBox(height: 50,),
            reviewTestTaken!.count == reviewQuestions.length ?
                Container() :
            GestureDetector(
              onTap: (){
                setState(() {
                  isContinue = true;
                  _currentPage ++;
                });
              },
              child: Center(
                child: Container(
                  width: appWidth(context),
                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: sText("Continue",weight: FontWeight.bold,color: Colors.white,size:  25 ,align: TextAlign.center),

                ),
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              onTap: (){
                setState(() {
                  _currentPage = 7;
                  isContinue = false;
                });
              },
              child: Center(
                child: Container(
                  width: appWidth(context),
                  margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: sText("Restart",weight: FontWeight.bold,color: Colors.white,size:  25 ,align: TextAlign.center),

                ),
              ),
            ),

            // SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  nextSummaryWidget(){
    return Container(
      width: appWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    width: appWidth(context),
                    child: Stack(
                      children: [
                        Image.asset("assets/review/path.png",width: appWidth(context),height: appHeight(context) * 0.70,fit: BoxFit.cover,),
                        Positioned(
                          top: 150,
                          left: 30,
                          child:   Container(
                            width: appWidth(context) * 0.90,
                            child:sText("${reviewQuestions.length}",weight: FontWeight.bold,color: reviewBackgroundColors,size: 100,align: TextAlign.center),
                          ),
                        ),
                        Positioned(
                          top: 270,
                          left: 30,
                          child:   Container(
                            width: appWidth(context) * 0.90,
                            child:sText("Questions",weight: FontWeight.bold,color: Colors.white,size: 50,align: TextAlign.center),
                          ),
                        ),

                      ],
                    ),

                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        _currentPage ++;
                        print("isContinue:$isContinue");
                      });
                    },
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                      child: sText("Next",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      decoration: BoxDecoration(
                        color: reviewSelectedColor,
                          borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  instructionWidget(){
    return Container(
      width: appWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
             child: ListView(
               children: [
                 SizedBox(height: 20,),
                 Container(
                   width: appWidth(context),
                   child: Stack(
                     children: [
                       Image.asset("assets/review/path.png",width: appWidth(context),height: appHeight(context) * 0.70,fit: BoxFit.cover,),
                       Positioned(
                         top: 150,
                         left: 30,
                         child:   Container(
                           width: appWidth(context) * 0.90,
                           child:sText("Instructions",weight: FontWeight.bold,color: reviewBackgroundColors,size: 40,align: TextAlign.center),
                         ),
                       ),
                       Positioned(
                         top: 220,
                         left: 30,
                         child:   Container(
                           width: appWidth(context) * 0.90,
                           child:sText("1. Review as many questions as possible",weight: FontWeight.bold,color: Colors.white,size: 20,align: TextAlign.left),
                         ),
                       ),
                       Positioned(
                         top: 280,
                         left: 30,
                         child:   Container(
                           width: appWidth(context) * 0.90,
                           child: sText("2. Review questions without having to take the test",weight: FontWeight.bold,color: Colors.white,size: 20,align: TextAlign.left),
                         ),
                       ),
                       Positioned(
                         top: 350,
                         left: 30,
                         child: Container(
                           width: appWidth(context) * 0.90,
                           child: sText("3. It show you the right answers , no score",weight: FontWeight.bold,color: Colors.white,size: 20,align: TextAlign.left),
                         ),
                       ),
                     ],
                   ),

                 ),
                 GestureDetector(
                   onTap: (){
                     resetTimer();
                    if(reviewTestTaken == null){
                      _currentPage = 8;
                    }else{
                      _currentPage ++;
                    }

                     setState(() {

                     });
                   },
                   child: Container(
                     width: 200,
                     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                     margin: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                     child: sText("Start",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(60),
                         border: Border.all(color: Colors.white)
                     ),
                   ),
                 ),
               ],
             ),
           )
          ],
        ),
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
           GestureDetector(
             onTap: ()async{
             },
             child: Container(
               child: getTimerWidget(),
             ),
           )
          ],
        ),
      ),
    );
  }
  cautionWidget(){
    return Container(
      width: appWidth(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
             child: ListView(
               children: [
                 SizedBox(height: 20,),
                 Container(
                   width: appWidth(context),
                   child: Stack(
                     children: [
                       Image.asset("assets/review/path.png",width: appWidth(context),height: appHeight(context) * 0.70,fit: BoxFit.cover,),
                       Positioned(
                         top: 150,
                         left: 30,
                         child:   Container(
                           width: appWidth(context) * 0.90,
                           child:sText("Caution",weight: FontWeight.bold,color: Colors.white,size: 40,align: TextAlign.center),
                         ),
                       ),
                       Positioned(
                         top: 220,
                         left: 20,
                         child:   Container(
                           width: appWidth(context) * 0.90,
                           child:sText("You will lose your saved marathon session once you begin a new marathon.",weight: FontWeight.normal,color: Colors.white,size: 20,align: TextAlign.center),
                         ),
                       ),
                       Positioned(
                         top: 280,
                         left: 20,
                         child:  Container(

                           width: appWidth(context) * 0.9,
                           margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                           child: Text.rich(
                             TextSpan(
                                 text: 'Click on ',
                                 style: appStyle(col: Colors.white),

                                 children: <InlineSpan>[

                                   TextSpan(
                                     text:'RESTART',
                                     style: appStyle(col: Colors.white,weight: FontWeight.bold),

                                   ),

                                   TextSpan(
                                     text:' Click on Restart if you wish to do so. If not kindlt go back tou your old marathon',
                                     style: appStyle(col: Colors.white,size: 20,),

                                   )
                                 ]
                             ),



                           ),
                         ),

                       ),

                     ],
                   ),

                 ),
                 GestureDetector(
                   onTap: (){
                     resetTimer();
                     _currentPage ++;
                     setState(() {

                     });
                   },
                   child: Container(
                     width: 200,
                     padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                     margin: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                     child: sText("Restart",color: Colors.white,weight: FontWeight.bold,size: 20,align: TextAlign.center),
                     decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(60),
                       color: reviewSelectedColor
                     ),
                   ),
                 ),
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
  restartBeginsInWidget(){
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
                child: getTimerWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }


}
class ListNamesReview{
  String name;
  String id;
  TestCategory? testCategory;
  ListNamesReview({this.name = '',this.id = '',this.testCategory});
}



