import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/text_to_speech_controller.dart';
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

class PersonalisedView extends StatefulWidget {
  PersonalisedView({
    required this.user,
    required this.course,
    required this.listGlossaryData,

    Key? key,
  }) : super(key: key);
  final User user;
  final Course course;
  List<GlossaryData> listGlossaryData;

  @override
  State<PersonalisedView> createState() => _PersonalisedViewState();
}

class _PersonalisedViewState extends State<PersonalisedView> {
  PageController pageControllerView = PageController(initialPage: 0);
  PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool switchValue = false;
  List<CourseKeywords> courseKeywords = [];
  String selectedCharacter = '';
  int currentIndex = 0;
  String termKeyword = '';
  List<Question> listQuestions = [];


  getQuestions()async{
    // listQuestions.clear();
    listQuestions = await TestController().getKeywordQuestions(termKeyword.toLowerCase(), widget.course.id!);
    setState(() {
      print("listQuestions:${listQuestions.length}");
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      termKeyword = widget.listGlossaryData.first.term!;
    getQuestions();
  }
  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffold,
      backgroundColor: Color(0xFF0367B4),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 7.h),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(

                      onTap: ()async{
                        if(widget.listGlossaryData[currentIndex].played){
                          setState(() {
                            widget.listGlossaryData[currentIndex].played = false;
                          });
                          await TextToSpeechController(text: widget.listGlossaryData[currentIndex].definition!).stop();
                        }else{
                          setState(() {
                            widget.listGlossaryData[currentIndex].played = true;
                          });
                          await TextToSpeechController(text: "${widget.listGlossaryData[currentIndex].term!}. ${widget.listGlossaryData[currentIndex].definition!}").speak();
                        }

                      },
                      child:widget.listGlossaryData[currentIndex].played ? Icon(Icons.pause,color: Colors.black,) : Image.asset("assets/images/Polygon.png",),
                    ),
                    Row(
                      children: [
                        sText("${(currentIndex +1)}",size: 40,color: Colors.white,weight: FontWeight.bold),
                        sText("/${widget.listGlossaryData.length}",size: 20,color: Colors.blue[100]!,weight: FontWeight.bold),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              CarouselSlider.builder(
                  options:
                  CarouselOptions(
                    height:  480,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    aspectRatio: 2.0,
                    pageSnapping: true,
                    initialPage: currentIndex ,
                    onPageChanged: (index, reason) async{
                      currentIndex  = index ;
                      termKeyword = widget.listGlossaryData[index].term!;
                      GlossaryProgressData glossaryProgressData = GlossaryProgressData(
                        topicId: widget.listGlossaryData[index].topicId!,
                        courseId: widget.listGlossaryData[index].courseId!,
                        searchTerm: termKeyword,
                        selectedCharacter: selectedCharacter,
                        progressIndex: index,
                        correct: 0,
                        wrong: 0,
                        count: widget.listGlossaryData.length,
                      );
                      // await GlossaryDB().deleteGlossaryStudyProgress(widget.course.id!);
                      // await GlossaryDB().insertGlossaryStudyProgress(glossaryProgressData);
                      listQuestions = await TestController().getKeywordQuestions(termKeyword.toLowerCase(), widget.course.id!);
                      setState(() {
                        print("listQuestions:${listQuestions.length}");
                      });
                    },
                  ),
                  itemCount:widget.listGlossaryData.length,
                  itemBuilder: (BuildContext context, int indexReport, int index2) {
                    return  SingleChildScrollView(
                      child: Container(
                        width: appWidth(context),
                        padding: EdgeInsets.only(left: 0,right: 20,top: 20),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Container(
                            padding: EdgeInsets.only(left: 20,bottom: 20),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                sText("${widget.listGlossaryData[indexReport].term}",color: Colors.black,size: 25,weight: FontWeight.w500),
                                SizedBox(height: 20,),
                                sText("Topic",color: Colors.grey,size: 12,weight: FontWeight.w500),
                                SizedBox(height: 10,),
                                sText("${widget.listGlossaryData[indexReport].topic!.name}",color: Colors.black,size: 16,weight: FontWeight.w500),
                                SizedBox(height: 40,),
                                sText("Definition",color: Colors.grey,size: 12,weight: FontWeight.w500),
                                SizedBox(height: 10,),
                                sText("${widget.listGlossaryData[indexReport].definition}",color: Colors.black,size: 16,weight: FontWeight.w500,maxLines: 10),
                              ],
                            ),
                          ),
                            Container(
                              // height: 200,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF3923C),
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(100))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 20),
                                      child: sText("${listQuestions.length}",size: 30,weight: FontWeight.bold,color: Colors.white,align: TextAlign.center)
                                  ),
                                  SizedBox(height: 10,),
                                  sText("Appearances",color: Colors.white),
                                ],
                              ),
                            )


                          ],
                        ),
                      ),
                    );
                  }),

              Container(
                child: Column(
                  children: [
                    sText("Questions",color: Colors.white,weight: FontWeight.w600,size: 20),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: sText('These contain the word "$termKeyword".',color: Colors.white,weight: FontWeight.normal,size: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              for(int i =0; i <listQuestions.length; i++)
                Column(
                  children: [
                    if(!listQuestions[i].viewQuestions!)
                      MaterialButton(
                        onPressed: (){
                          setState(() {
                            listQuestions[i].viewQuestions = true;
                          });
                        },
                        child: Container(
                          width: appWidth(context),
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 20),
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AdeoHtmlTex(
                                  widget.user,
                                  listQuestions[i].text!.replaceAll("https", "http"),
                                  // removeTags: controller.questions[i].instructions!.contains("src") ? false : true,
                                  useLocalImage: true,
                                  fontWeight: FontWeight.w500,
                                  textColor: Colors.white,
                                ),
                              ),
                              // sText("${listQuestions[i].text}",color: Colors.white,size: 20,weight: FontWeight.w500),
                              Icon(Icons.add,color: Colors.white,)
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white,width: 2)
                          ),
                        ),
                      ),
                    SizedBox(height: 20,),
                    if(listQuestions[i].viewQuestions!)
                      MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          setState(() {
                            listQuestions[i].viewQuestions = false;
                          });
                        },
                        child: Container(
                          width: appWidth(context),
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AdeoHtmlTex(
                                        widget.user,
                                        listQuestions[i].text!.replaceAll("https", "http"),
                                        // removeTags: controller.questions[i].instructions!.contains("src") ? false : true,
                                        useLocalImage: true,
                                        fontWeight: FontWeight.w500,
                                        textColor: Colors.black,
                                      ),
                                    ),
                                    Icon(Icons.horizontal_rule,color: Colors.black,)
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: 20,
                                width: appWidth(context),
                              ),
                              SizedBox(height: 20,),
                              Column(
                                children: [
                                  for(int t = 0; t < listQuestions[i].answers!.length; t++)
                                    listQuestions[i].answers![t].value == 1 ?
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                      width: appWidth(context),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: AdeoHtmlTex(
                                              widget.user,
                                              listQuestions[i].answers![t].text!.replaceAll("https", "http"),
                                              // removeTags: controller.questions[i].instructions!.contains("src") ? false : true,
                                              useLocalImage: true,
                                              fontWeight: FontWeight.w500,
                                              textColor: Colors.black,
                                            ),
                                          ),
                                          Image.asset("assets/images/correct.png")
                                        ],
                                      ),
                                    )
                                        :
                                    Container(
                                      width: appWidth(context),
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                      child:    AdeoHtmlTex(
                                        widget.user,
                                        listQuestions[i].answers![t].text!.replaceAll("https", "http"),
                                        // removeTags: controller.questions[i].instructions!.contains("src") ? false : true,
                                        useLocalImage: true,
                                        fontWeight: FontWeight.w500,
                                        textColor: Colors.black,
                                      ),
                                    ),

                                ],
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
