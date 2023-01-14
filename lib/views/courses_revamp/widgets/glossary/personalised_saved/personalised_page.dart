import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/controllers/text_to_speech_controller.dart';
import 'package:ecoach/database/topics_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/topic.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PersonalisedPage extends StatefulWidget {
  PersonalisedPage(
      {Key? key,
        required this.course,
        required this.user,
      })
      : super(key: key);
  Course course;
  User user;
  @override
  State<PersonalisedPage> createState() => _PersonalisedPageState();
}

class _PersonalisedPageState extends State<PersonalisedPage> {
  Topic? selectedTopic;

  List<Topic> listTopics = [];
  bool progressCode = true;
  FlutterTts flutterTts = FlutterTts();

  onSelectModalBottomSheet(context,GlossaryData glossary,int index) {
    double sheetHeight = 400;
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("${glossary.term}",
                            color: Colors.black,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                            size: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("What action will you like to perform",
                            color: kAdeoGray3,
                            weight: FontWeight.normal,
                            align: TextAlign.center,),
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: ()async{

                              showLoaderDialog(context);
                           var res =  await  GlossaryController().deleteGlossaries(glossary.id!);
                           setState(() {
                            if(res){
                              personaliseGlossaryData.removeAt(index);
                            }else{
                              toastMessage("Deletion failed, try again later");
                            }
                          });
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(7.0),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset("assets/images/delete.png")
                                ),
                                SizedBox(height: 10,),
                                sText("Delete",color: Colors.grey[400]!)
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{

                              showLoaderDialog(context);
                              GlossaryData? res =  await  GlossaryController().pinUnPinGlossaries(glossary,glossary.isPinned! == 1 ? false : true);
                              if(res != null){
                                setState(() {
                                  personaliseGlossaryData[index] = res;
                                });
                                toastMessage("Pinned successfully");
                              }else{
                                toastMessage("Failed try again");
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(7.0),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset("assets/images/push-pin.png")
                                ),
                                SizedBox(height: 10,),
                                sText(glossary.isPinned! == 1 ? "Unpin" : "Pin",color: Colors.grey[400]!)
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              Navigator.pop(context);
                              editDialogModalBottomSheet(context,glossary,index);
                            },
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(7.0),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset("assets/images/edit.png")
                                ),
                                SizedBox(height: 10,),
                                sText("Edit",color: Colors.grey[400]!)
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/send.png")
                              ),
                              SizedBox(height: 10,),
                              sText("Share",color: Colors.grey[400]!)
                            ],
                          ),
                        ],
                      )
                    ],
                  ));
            },
          );
        });
  }

  createDialogModalBottomSheet(
      context,
      ) {
    double sheetHeight = appHeight(context) * 0.9;
    TextEditingController termController = TextEditingController();
    TextEditingController meaningController = TextEditingController();

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
                                            autofocus: true,
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
                                        items: listTopics.map(
                                              (item) => DropdownMenuItem<Topic>(
                                            value: item,
                                            child: Text(
                                              "${item.name}",
                                              style: TextStyle(
                                                color: kDefaultBlack,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                            .toList(),
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
                                           maxLines: 7,
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
                      GestureDetector(
                        onTap: () async{
                          Map body = {
                            "course_id":widget.course.id,
                            "topic_id": selectedTopic!.id,
                            "term":termController.text,
                            "definition":meaningController.text,
                          };
                          if(termController.text.isNotEmpty && meaningController.text.isNotEmpty){
                            showLoaderDialog(context);
                            GlossaryData? glossary = await GlossaryController().createGlossary(body);
                            if(glossary != null){
                             setState(() {
                               personaliseGlossaryData.add(glossary);
                             });
                            }else{
                              toastMessage("Failed try again later");
                            }
                          }else{
                            toastMessage("All fields are required");
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);

                        },
                        child: Container(
                          width: appWidth(context),
                          color: Color(0xFF1D4859),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: sText("Create",
                              color: Colors.white,
                              weight: FontWeight.w500,
                              align: TextAlign.center,
                              size: 18),
                        ),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  editDialogModalBottomSheet(context,GlossaryData glossary,int index) {
    double sheetHeight = appHeight(context) * 0.90;
    TextEditingController termController = TextEditingController();
    TextEditingController meaningController = TextEditingController();
    termController.text = glossary.term!;
    meaningController.text = glossary.definition!;
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
                        child: Container(
                          height: appHeight(context),
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
                                              autofocus: true,
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
                                            items: listTopics.map(
                                                  (item) => DropdownMenuItem<Topic>(
                                                value: item,
                                                child: Text(
                                                  "${item.name}",
                                                  style: TextStyle(
                                                    color: kDefaultBlack,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                                .toList(),
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
                                              maxLines: 7,
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
                      ),
                      GestureDetector(
                        onTap: () async{
                       try{
                         Map body = {
                           "glossary_id":glossary.id,
                           "course_id":widget.course.id,
                           "topic_id": selectedTopic!.id,
                           "term":termController.text,
                           "definition":meaningController.text,
                           "confirmed":glossary.confirmed == 1 ? true : false,
                           "order_priority":glossary.confirmed,
                           "is_pinned":glossary.isPinned == 1 ? true : false,
                         };
                         if(termController.text.isNotEmpty && meaningController.text.isNotEmpty){
                           showLoaderDialog(context);
                           GlossaryData? glossary = await GlossaryController().updateGlossary(body);
                           if(glossary != null){
                             personaliseGlossaryData.removeAt(index);
                             personaliseGlossaryData.insert(index, glossary);
                             setState(() {

                             });
                             Navigator.pop(context);
                             Navigator.pop(context);
                           }else{
                             Navigator.pop(context);
                             Navigator.pop(context);
                             toastMessage("Failed try again later");
                           }
                         }else{
                           Navigator.pop(context);
                           Navigator.pop(context);
                           toastMessage("All fields are required");
                         }
                       }catch(e){
                         toastMessage("Failed try again later");
                         Navigator.pop(context);
                       }


                        },
                        child: Container(
                          width: appWidth(context),
                          color: Color(0xFF1D4859),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: sText("Update",
                              color: Colors.white,
                              weight: FontWeight.w500,
                              align: TextAlign.center,
                              size: 18),
                        ),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  getPersonalisedData()async{
    try{
      personaliseGlossaryData = await GlossaryController().getPersonalisedGlossariesList();
    }catch(e){
      print(e.toString());
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TextToSpeechController().initialize();
    if(personaliseGlossaryData.isEmpty){
      getPersonalisedData();
    }
    getTopics();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton:
      GestureDetector(
        onTap: (){
          createDialogModalBottomSheet(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.add,color: Colors.white,),
          decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle
          ),
        ),
      ),
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
                      sText("${personaliseGlossaryData.length}")
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            personaliseGlossaryData.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: personaliseGlossaryData.length,
                  itemBuilder: (BuildContext context, int index){
                    return   MultiPurposeCourseCard(
                      padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
                      title: '${personaliseGlossaryData[index].term}',
                      subTitle: 'Create and view definitions',
                      rightWidget:    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                          elevation: MaterialStateProperty.resolveWith((states) => 0)
                        ),

                        onPressed: ()async{
                          if(personaliseGlossaryData[index].played){
                            setState(() {
                              personaliseGlossaryData[index].played = false;
                            });
                            await TextToSpeechController(text: personaliseGlossaryData[index].definition!).stop();
                          }else{
                            setState(() {
                              personaliseGlossaryData[index].played = true;
                            });
                            await TextToSpeechController(text: personaliseGlossaryData[index].definition!).speak();
                          }


                        },
                        child:personaliseGlossaryData[index].played ? Icon(Icons.pause,color: Colors.black,) : Image.asset("assets/images/Polygon.png",width: 20,),
                      ),
                      onTap: () async {
                        onSelectModalBottomSheet(context,personaliseGlossaryData[index],index);
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
