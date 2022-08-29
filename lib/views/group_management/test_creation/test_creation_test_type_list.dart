import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/quiz.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/group_management/test_creation/test_configuration.dart';
import 'package:flutter/material.dart';

class TestCreationTestTypeList extends StatefulWidget {
  Course? course;
  String type;
   TestCreationTestTypeList({this.course, required this.type});

  @override
  State<TestCreationTestTypeList> createState() => _TestCreationTestTypeListState();
}

class _TestCreationTestTypeListState extends State<TestCreationTestTypeList> {
  List<TestNameAndCount> listTopics = [];
  getTypeList()async{
    if(widget.type == "exam"){
      listTopics = await TestController().getExamTests(widget.course!);
    }else if(widget.type == "topic"){
      listTopics = await TestController().getTopics(widget.course!,);
    }else if(widget.type == "bank"){
      listTopics = await TestController().getBankTest(widget.course!);
    }

    setState((){
        print("listTopics:$listTopics");
    });
  }
  @override
 void initState(){
    getTypeList();
    groupTestType = widget.type;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        title: sText("Test Creation",color: Colors.black,weight: FontWeight.bold,size: 20),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: Stack(
                  children:  const [
                    CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                      value: 0.9,
                    ),
                    Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: appWidth(context),
            child: sText("Select your source for the test",color: kAdeoGray2,align: TextAlign.center),
          ),
          SizedBox(height: 20,),
          listTopics.isNotEmpty ?
          Expanded(
            child: ListView.builder(
              itemCount: listTopics.length,
                itemBuilder: (BuildContext context, int index){
                return MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    groupTestId = listTopics[index].id.toString();
                    goTo(context, TestConfigurations(testName: listTopics[index].name,));
                  },
                  child: Container(
                    padding: appPadding(20),
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: appWidth(context) * 0.70,
                                      child: sText("${listTopics[index].name}",size: 16,weight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      width: appWidth(context) * 0.65,

                                      child: sText("Pick a quiz from your existing subscription",size: 12,color: kAdeoGray2),
                                    )

                                  ],
                                ),
                              ),
                              Image.asset("assets/images/stopwatch.png",width: 30,)
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(color: Color(0XFF00C9B9),height: 5,),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  color: Color(0XFF0367B4),height: 5
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                );
            }),
          ) : Expanded(child: Center(child: sText("No ${properCase(widget.type)}s",weight: FontWeight.w500),))

        ],
      ),
    );
  }
}
