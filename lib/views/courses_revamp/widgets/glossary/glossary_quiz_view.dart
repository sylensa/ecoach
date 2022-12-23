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
  int correct = 0;
  int wrong = 0;
  int initialIndex = 0;
  int totalGlossary = 0;

  List<TextEditingController> textEditingController = [];
  CarouselController carouselController = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalGlossary = widget.listGlossaryData.length;
    if(widget.glossaryProgressData != null){
      initialIndex = widget.glossaryProgressData!.progressIndex!;
      initialIndex++;
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
          padding: EdgeInsets.only(top: 8.h,left: 20,right: 20),
          child: Column(
            children: [
              Container(
                child:LinearProgressIndicator(
                  value: correct/totalGlossary,
                )
              ),
              SizedBox(height: 20,),
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
                      GlossaryProgressData glossaryProgressData = GlossaryProgressData(
                          topicId: widget.listGlossaryData[index].topic!.id,
                          courseId: widget.listGlossaryData[index].courseId!,
                          searchTerm: widget.listGlossaryData[index].term,
                          selectedCharacter: "a",
                          progressIndex: index
                      );
                      await GlossaryDB().deleteGlossaryProgress(widget.course.id!);
                      await GlossaryDB().insertGlossaryProgress(glossaryProgressData);
                    print(index);
                    // setState(() {
                    //   initialIndex = index;
                    // });
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
                                    keyboardType: TextInputType.emailAddress,
                                    onSubmitted: (String value)async{
                                      if(value.toLowerCase() == widget.listGlossaryData[indexReport].term!.toLowerCase()){
                                       setState(() {
                                         correct++;
                                         // initialIndex++;
                                         widget.listGlossaryData.removeAt(indexReport);
                                         textEditingController.removeAt(indexReport);
                                       });
                                      }else{
                                        setState(() {
                                          wrong++;
                                          // initialIndex++;
                                          widget.listGlossaryData.removeAt(indexReport);
                                          textEditingController.removeAt(indexReport);
                                        });
                                      }

                                      GlossaryProgressData glossaryProgressData = GlossaryProgressData(
                                          topicId: widget.listGlossaryData[indexReport].topic!.id,
                                          courseId: widget.listGlossaryData[indexReport].courseId!,
                                          searchTerm: widget.listGlossaryData[indexReport].term,
                                          selectedCharacter: "a",
                                          progressIndex: indexReport
                                      );
                                      await GlossaryDB().deleteGlossaryProgress(widget.course.id!);
                                      await GlossaryDB().insertGlossaryProgress(glossaryProgressData);
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
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
