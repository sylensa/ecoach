import 'dart:convert';

import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SavedPage extends StatefulWidget {
  SavedPage(
      {Key? key,
        required this.course,
        required this.user,
      })
      : super(key: key);
  Course course;
  User user;
  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<GlossaryData> glossaryData = [];
  bool progressCode = true;
  Topic? selectedTopic;
  List<Topic> listTopics = [];
  getSavedData()async{
    glossaryData = await GlossaryController().getUserSavedGlossariesList();
    setState(() {
      progressCode = false;
    });
  }
  getTopics()async{
    listTopics = await  TopicDB().allCourseTopics(widget.course);
    setState(() {
      if(listTopics.isNotEmpty){
        selectedTopic = listTopics[0];
      }
    });
  }
  editDialogModalBottomSheet(context,GlossaryData glossary,int index) {
    double sheetHeight = appHeight(context) * 0.70;
    TextEditingController termController = TextEditingController();
    TextEditingController meaningController = TextEditingController();
    termController.text = glossary.term!;
    meaningController.text = glossary.definitions![0].definition!;
    for(int i = 0; i < listTopics.length; i++){
      if(listTopics[i].id == glossary.topicId){
        selectedTopic = listTopics[i];
      }
    }
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20,right:20),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("Word",color: kAdeoGray3),
                                  SizedBox(height: 10,),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: termController,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please check that you\'ve entered group_management email';
                                              }
                                              return null;
                                            },
                                            decoration: textDecorNoBorder(
                                              radius: 10,
                                              hintColor: Color(0xFFB9B9B9),
                                              borderColor: Colors.white,
                                              fill: Color(0xFFEDF3F7),
                                              padding: EdgeInsets.only(left: 10, right: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20,right:20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("Topic",color: kAdeoGray3),
                                  SizedBox(height: 10,),
                                  if(listTopics.isNotEmpty)
                                    Container(
                                      width: appWidth(context),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEDF3F7),
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding: EdgeInsets.only(left: 12, right: 12),
                                      child: DropdownButtonHideUnderline(

                                        child: DropdownButton<Topic>(
                                          value: selectedTopic ?? listTopics[0],
                                          itemHeight: 60,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kDefaultBlack,
                                          ),

                                          onChanged: (Topic? value){
                                            stateSetter((){
                                              selectedTopic = value;
                                            });
                                          },
                                          items: [
                                            DropdownMenuItem<Topic>(
                                              value: selectedTopic,
                                              child: Text(
                                                "${selectedTopic!.name}",
                                                style: TextStyle(
                                                  color: kDefaultBlack,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20,right:20),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("Meaning",color: kAdeoGray3),
                                  SizedBox(height: 10,),
                                  Container(
                                    // padding: EdgeInsets.only(left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: meaningController,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please check that you\'ve entered your group description';
                                              }
                                              return null;
                                            },
                                            maxLines: 10,
                                            decoration: textDecorNoBorder(
                                              radius: 10,
                                              hintColor: Color(0xFFB9B9B9),
                                              borderColor: Colors.white,
                                              fill: Color(0xFFEDF3F7),
                                              padding: EdgeInsets.only(left: 10, right: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                      Container(
                        width: appWidth(context),
                        color: Color(0xFF1D4859),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: sText("Saved Glossry",
                            color: Colors.white,
                            weight: FontWeight.w500,
                            align: TextAlign.center,
                            size: 18),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopics();
    getSavedData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      // floatingActionButton: Container(
      //   padding: EdgeInsets.all(10),
      //   child: Icon(Icons.add,color: Colors.white,),
      //   decoration: BoxDecoration(
      //       color: Colors.black,
      //       shape: BoxShape.circle
      //   ),
      // ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/Polygon.png"),
                  Row(
                    children: [
                      Image.asset("assets/images/dictionary.png"),
                      SizedBox(width: 10,),
                      sText("${glossaryData.length}")
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            glossaryData.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: glossaryData.length,
                  itemBuilder: (BuildContext context, int index){
                    return   MultiPurposeCourseCard(
                      title: '${glossaryData[index].term}',
                      rightWidget:   FlutterSwitch(
                        width: 50.0,
                        height: 20.0,
                        valueFontSize: 10.0,
                        toggleSize: 15.0,
                        value:  true,
                        borderRadius: 30.0,
                        padding: 2.0,
                        showOnOff: false,
                        activeColor: Color(0xFF555555),
                        inactiveColor: Color(0xFFD1D1D1),
                        inactiveTextColor: Colors.red,
                        inactiveToggleColor: Color(0xFF555555),
                        onToggle: (val) async{
                          glossaryData[index].isSaved = 0;
                          var res = jsonDecode(glossaryData[index].glossary!);
                          res["is_saved"] =  glossaryData[index].isSaved;
                          glossaryData[index].glossary = jsonEncode(res);
                          GlossaryController().unSaveGlossariesList(glossaryData[index]);
                          setState(() {
                            glossaryData.removeAt(index);
                          });

                        },
                      ),
                      subTitle: 'Create and view definitions',

                      onTap: () async {
                        editDialogModalBottomSheet(context,glossaryData[index],index);
                      },
                    );

                  }),
            ) :
            progressCode ?
                Expanded(child: Center(child: progress(),)) :
            Expanded(child: Center(child: sText("Empty data"),))
          ],
        ),
      ),
    );
  }
}
