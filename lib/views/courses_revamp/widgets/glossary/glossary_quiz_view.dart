import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/glossary_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/glossary_progress_model.dart';
import 'package:ecoach/models/keywords_model.dart';
import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/questions_widgets/adeo_html_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GlossaryQuizView extends StatefulWidget {
  GlossaryQuizView({
    required this.user,
    required this.course,
    required this.listGlossaryData,
    required this.glossaryProgressData,

    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  List<GlossaryData> listGlossaryData;
  GlossaryProgressData? glossaryProgressData ;

  @override
  State<GlossaryQuizView> createState() => _GlossaryQuizViewState();
}

class _GlossaryQuizViewState extends State<GlossaryQuizView> {
  PageController pageControllerView = PageController(initialPage: 0);
  PageController pageController = PageController(initialPage: 0);
  bool switchValue = false;
  bool isSkipped = true;
  bool isCorrect = true;
  int correct = 0;
  int wrong = 0;
  int initialIndex = 0;
  int totalGlossary = 0;
  int answeredQuestionCount = 0;
  List<GlossaryData> listGlossaryData = [];
  List<TextEditingController> textEditingController = [];
  CarouselController carouselController = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listGlossaryData =  widget.listGlossaryData;
    totalGlossary = widget.listGlossaryData.length;
    if(widget.glossaryProgressData != null){
      initialIndex = widget.glossaryProgressData!.progressIndex! + 1;
      print("initialIndex:$initialIndex");
      correct = widget.glossaryProgressData!.correct!;
      wrong = widget.glossaryProgressData!.wrong!;
      totalGlossary = widget.glossaryProgressData!.count!;
    }
    for(int i = 0; i < widget.listGlossaryData.length; i++){
      textEditingController.add(TextEditingController());
    }
  }
  GlobalKey<ScaffoldState> scaffold = GlobalKey();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffold,
      backgroundColor: Color(0xFF00D289),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 8.h,left: 0,right: 0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                color: const Color(0xFF2D3E50),
                height: 47,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isCorrect
                        ? Image.asset(
                      "assets/images/un_fav.png",
                      color: Colors.green,
                    )
                        : SvgPicture.asset(
                      "assets/images/fav.svg",
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${correct != 0 ? ((correct/initialIndex) * 100).toStringAsFixed(2) : 0}%",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 6.4,
                    ),
                    const SizedBox(
                      width: 17.6,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "$correct",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 17,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 6.4,
                    ),
                    Text(
                      "$wrong",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9EE4FF),
                      ),
                    ),
                    const SizedBox(
                      width: 4.2,
                    ),
                    const SizedBox(
                      height: 16,
                      child: VerticalDivider(
                        color: Color(0xFF9EE4FF),
                        width: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 6.2,
                    ),
                    Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                              value: initialIndex/totalGlossary

                            ),
                            Center(
                              child: Text(
                                "${initialIndex + 1}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [

                  Expanded(
                    child: Container(
                      child:LinearProgressIndicator(
                        value: (correct + wrong)/totalGlossary,
                        backgroundColor: Colors.white,
                        color: Colors.green,
                      )
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              widget.listGlossaryData.isNotEmpty ?
              CarouselSlider.builder(
                carouselController: carouselController,
                  options:
                  CarouselOptions(
                    height:  380,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    initialPage: initialIndex,
                    aspectRatio: 2.0,
                    pageSnapping: true,
                    onPageChanged: (index, reason) async{
                      setState(() {
                        print("wrong:$index");
                        if(isSkipped){
                          initialIndex++;
                          wrong++;
                        }
                      });

                    },
                  ),
                  itemCount:widget.listGlossaryData.length,
                  itemBuilder: (BuildContext context, int indexReport, int index2) {
                    return  SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlutterSwitch(
                                  width: 50.0,
                                  height: 20.0,
                                  valueFontSize: 10.0,
                                  toggleSize: 15.0,
                                  value: widget.listGlossaryData[indexReport].isSaved! == 1 ? true : false,
                                  borderRadius: 30.0,
                                  padding: 2.0,
                                  showOnOff: false,
                                  activeColor: Color(0xFF555555),
                                  inactiveColor: Color(0xFFD1D1D1),
                                  inactiveTextColor: Colors.red,
                                  inactiveToggleColor: Color(0xFF555555),
                                  onToggle: (val) async{
                                    setState(() {
                                      switchValue = val;
                                      if(switchValue){
                                        widget.listGlossaryData[indexReport].isSaved = 1;
                                      }else{
                                        widget.listGlossaryData[indexReport].isSaved = 0;
                                      }
                                      var res = jsonDecode(widget.listGlossaryData[indexReport].glossary!);
                                      res["is_saved"] =  widget.listGlossaryData[indexReport].isSaved;
                                      widget.listGlossaryData[indexReport].glossary = jsonEncode(res);
                                    });
                                    if(switchValue){
                                      GlossaryController().saveGlossariesList(widget.listGlossaryData[indexReport]);
                                    }else{
                                      GlossaryController().unSaveGlossariesList(widget.listGlossaryData[indexReport]);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            sText("Topic",color: Colors.grey,size: 12,weight: FontWeight.w500),
                            SizedBox(height: 10,),
                            sText("${widget.listGlossaryData[indexReport].topic!.name}",color: Colors.black,size: 16,weight: FontWeight.w500),
                            SizedBox(height: 40,),
                            sText("Definition",color: Colors.grey,size: 12,weight: FontWeight.w500),
                            SizedBox(height: 10,),
                            sText("${widget.listGlossaryData[indexReport].definition}",color: Colors.black,size: 16,weight: FontWeight.w500),
                            SizedBox(height: 50,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: textEditingController[indexReport],
                                    enabled: widget.listGlossaryData[indexReport].answered == 1 ? false : true,
                                    keyboardType: TextInputType.emailAddress,
                                    onSubmitted: (String value)async{
                                      initialIndex++;
                                      isSkipped = true;
                                       widget.listGlossaryData[indexReport].answered = 1;
                                       if(value.isEmpty){
                                         textEditingController[indexReport].text = 'Answered';
                                       }
                                      if(value.toLowerCase() == widget.listGlossaryData[indexReport].term!.toLowerCase()){
                                       setState(() {
                                         correct++;
                                       });
                                         showSuccessDialog(context: context);
                                      }else{
                                        setState(() {
                                          wrong++;
                                        });
                                          showFailedDialog(context: context);
                                      }
                                      GlossaryProgressData glossaryProgressData = GlossaryProgressData(
                                          topicId: widget.listGlossaryData[indexReport].topic!.id,
                                          courseId: widget.listGlossaryData[indexReport].courseId!,
                                          searchTerm: widget.listGlossaryData[indexReport].term,
                                          selectedCharacter: "a",
                                          progressIndex: indexReport,
                                          count:  totalGlossary,
                                          correct: correct,
                                          wrong: wrong
                                      );
                                      await GlossaryDB().deleteGlossaryTryProgress(widget.course.id!);
                                      await GlossaryDB().insertGlossaryTryProgress(glossaryProgressData);
                                      carouselController.animateToPage(indexReport + 1,duration: Duration(seconds: 1),curve: Curves.easeIn);
                                      setState(() {
                                        isSkipped = true;
                                      });

                                      if(indexReport == widget.listGlossaryData.length - 1){
                                        testCompletedModalBottomSheet(context);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        hintStyle: const TextStyle(
                                            color: Color(0xFFB9B9B9), fontSize: 16)),
                                  ),
                                ),                              ],
                            ),
                            Divider(color: Colors.grey,),

                          ],
                        ),
                      ),
                    );
                  }) : Center(child: sText("Answered all terms"),),

            ],
          ),
        ),
      ),
    );
  }

  showSuccessDialog({BuildContext? context}) {
    // flutter defined function
    showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 40,right: 20),
          backgroundColor: Color(0xFF00D289),
          title: Column(
            children: [
              Container(
                  child: Icon(Icons.check_circle_outline,color: Colors.white,size: 150,)
              ),
            ],
          ),
          content:   Container(
            height: 100,
            child: Column(
              children: [
                sText("Great Job,",weight: FontWeight.w400,color: Colors.black,align: TextAlign.center),
                sText("Let's move on to the next one,",weight: FontWeight.w400,color: Colors.black,align: TextAlign.center),
              ],
            ),
          ),

        );
      },
    );
  }
  showFailedDialog({BuildContext? context}) {
    // flutter defined function
    showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 40,right: 20),
          backgroundColor: Colors.red,
          title: Column(
            children: [
              Container(
                  child: Icon(Icons.cancel,color: Colors.white,size: 150,)
              ),
            ],
          ),
          content:   Container(
            height: 100,
            child: Column(
              children: [
                sText("Aww wrong answer,",weight: FontWeight.w400,color: Colors.white,align: TextAlign.center),
                sText("Let's move on to the next one,",weight: FontWeight.w400,color: Colors.white,align: TextAlign.center),
              ],
            ),
          ),

        );
      },
    );
  }

  testCompletedModalBottomSheet(context,) async{
    double sheetHeight = 230;
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                sText("Glossary Test Completed",
                                    color: kAdeoGray3,
                                    weight: FontWeight.w500,
                                    align: TextAlign.center,
                                    size: 20),

                              ],
                            ),
                            SizedBox(width: 10,),
                            Center(
                                child: Image.asset("assets/icons/courses/sort-az.png")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      MaterialButton(
                        onPressed: ()async{
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          width: appWidth(context),
                          child: sText("Ok",color:   Colors.white ,weight: FontWeight.w500,size: 25,align: TextAlign.center),
                          decoration: BoxDecoration(
                              color: Colors.green ,
                              border: Border.all(color:  Colors.black,),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                    ],
                  ));
            },
          );
        });
  }
}
