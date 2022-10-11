import 'package:ecoach/controllers/conquest_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/models/review_taken.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/conquest/conquest_questions.dart';
import 'package:flutter/material.dart';

class ConquestOnBoarding extends StatefulWidget {
  ConquestOnBoarding({
    required this.user,
    required this.course,
    required this.testType,
    required this.listQuestions,
    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  final TestType testType;
  List<Question> listQuestions;

  @override
  State<ConquestOnBoarding> createState() => _ReviewOnBoardingeState();
}

class _ReviewOnBoardingeState extends State<ConquestOnBoarding> {

  int _currentPage = 0;
  TestCategory? testCategory;
  List<TestNameAndCount> listTopics = [];
  List<Question> questions = [];
  ReviewTestTaken? reviewTestTaken;

  Map<String, Widget> getPage() {
    switch (_currentPage) {
      case 0:
        return {'Questions Count': startWidget()};

      case 1:
        return {'Instructions  Option': instructionWidget()};

    }
    return {'': Container()};
  }

  backPress(){
    setState(() {
      if(_currentPage == 0){
        Navigator.pop(context);
      }
      _currentPage--;
    });
  }



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return  backPress();
      },
      child: Scaffold(
          backgroundColor: Color(0XFFFD6363) ,
          appBar: AppBar(
            backgroundColor: Color(0XFFFD6363) ,
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

  startWidget(){
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: appWidth(context),
            height: appHeight(context) * 0.75,
            child: Stack(
              children: [
                Image.asset("assets/images/conquest_path.png",width: appWidth(context),height: appHeight(context) * 0.75,fit: BoxFit.fitHeight,),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sText("${widget.listQuestions.length}",weight: FontWeight.bold,color: Color(0XFFFFA4A4),size: 100,align: TextAlign.left),

                      sText("Questions",weight: FontWeight.bold,color: Colors.white,size: 40,align: TextAlign.center),
                    ],
                  ),
                ),

              ],
            ),
          ),
          GestureDetector(
            onTap: (){
                setState(() {
                  _currentPage++;
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
    );
  }


  instructionWidget(){

    return  Center(
      child: Column(
        children: [
          SizedBox(
            width: appWidth(context),
            height: appHeight(context) * 0.75,
            child: Stack(
              children: [
                Image.asset("assets/images/conquest_path.png",width: appWidth(context),height: appHeight(context) * 0.75,fit: BoxFit.fitHeight,),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sText("Instructions",weight: FontWeight.bold,color: Colors.white,size: 40,align: TextAlign.center),
                      SizedBox(height: 50,),
                      Container(
                        padding: leftPadding(0),
                          child: sText("1. Review as many questions as possible",weight: FontWeight.bold,color: Color(0XFFFFA4A4),size: 20,align: TextAlign.center),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        padding: leftPadding(30),

                        child: sText("2. Review questions without having to take the test",weight: FontWeight.bold,color: Color(0XFFFFA4A4),size: 20,align: TextAlign.center),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        padding: leftPadding(60),

                        child: sText("3. It show you the right answers , no score",weight: FontWeight.bold,color: Color(0XFFFFA4A4),size: 20,align: TextAlign.center),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
          GestureDetector(
            onTap: ()async{
              ConquestController controller = ConquestController(
                widget.user,
                widget.course,
              );
              controller.questions = widget.listQuestions;
              controller.name = widget.course.name;
              goTo(context, ConquestQuizView(controller: controller,),replace: true);
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
    );
  }



}




