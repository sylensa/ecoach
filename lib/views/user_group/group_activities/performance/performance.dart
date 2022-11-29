import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/controllers/average_score_graph.dart';
import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/controllers/performance_gragh.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/grade.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_performance_model.dart';
import 'package:ecoach/models/report.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GroupPerformance extends StatefulWidget {
  GroupListData? groupData;
  GroupPerformance(this.user, {Key? key,this.groupData,}) : super(key: key);
  User user;
  @override
  State<GroupPerformance> createState() => _GroupPerformanceState();
}

class _GroupPerformanceState extends State<GroupPerformance> {
  int _currentSlide = 0;
  bool progressCodeAll = true;
  bool showGraph = false;
  List<TopicStat> report = [] ;
  List listReportData = [true];
  List<T> map<T>(int listLength, Function handler) {
    List list = [];
    for (var i = 0; i < listLength; i++) {
      list.add(i);
    }
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  getAllActivity() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
    if (isConnected) {
      report = await GroupManagementController(groupId: widget.groupData!.id.toString()).getGroupPerformance();
      print("listGroupPerformanceData:${report}");
    } else {
      showNoConnectionToast(context);
    }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeAll = false;
    });
  }
  String getPositionPostfix(int position) {
    List<String> stringifiedPosition = position.toString().split('');
    int len = stringifiedPosition.length;
    dynamic penultimateChar = len >= 2 ? stringifiedPosition[len - 2] : null;
    String lastChar = stringifiedPosition[len - 1];

    if (lastChar == '1') {
      if (len >= 2 && penultimateChar == '1')
        return 'th';
      else
        return 'st';
    } else if (lastChar == '2') {
      if (len >= 2 && penultimateChar == '1')
        return 'th';
      else
        return 'nd';
    } else if (lastChar == '3') {
      if (len >= 2 && penultimateChar == '1')
        return 'th';
      else
        return 'rd';
    }

    return 'th';
  }

  getGrade(String grade){
    print("grade:$grade");
    if(widget.groupData!.settings != null){
      for(int i =0; i < widget.groupData!.settings!.grading!.grades!.length; i++){
        if(double.parse(grade) >= double.parse(widget.groupData!.settings!.grading!.grades![i].range!.toStringAsFixed(2))){
          print("object:${widget.groupData!.settings!.grading!.grades![i].grade}");
          return "${widget.groupData!.settings!.grading!.grades![i].grade}";
        }
      }

      return "${widget.groupData!.settings!.grading!.grades![widget.groupData!.settings!.grading!.grades!.length -1].grade}";

    }else{
      return "No";
    }

  }

  @override
  void initState(){
    getAllActivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
            report.isNotEmpty ?
         Expanded(
           child: ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: listReportData.length,
               itemBuilder: (BuildContext context, int index){
                return    Column(
                  children: [
                    CarouselSlider.builder(
                        options:
                        CarouselOptions(
                          height:  !listReportData[index] ? 130 : showGraph ? 340 : 365,
                          autoPlay:
                          false,
                          enableInfiniteScroll:
                          true,
                          autoPlayAnimationDuration:
                          Duration(seconds: 1),
                          enlargeCenterPage:
                          false,
                          viewportFraction:
                          1,
                          aspectRatio:
                          2.0,
                          pageSnapping:
                          true,
                          onPageChanged: (index, reason) {
                            setState(
                                    () {
                                  _currentSlide =
                                      index;
                                });
                          },
                        ),
                        itemCount:report.length,
                        itemBuilder: (BuildContext context, int indexReport, int index2) {
                          return  Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFE2EFF3),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            color: Colors.red,
                                            width: 5,
                                            height: 60,
                                          ),
                                          SizedBox(width: 20,),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                sText("SUMMARY",),
                                                SizedBox(height: 5,),
                                                Container(
                                                  width: 150,
                                                  child: sText("${report[indexReport].course!.name}",weight: FontWeight.bold,size: 10),
                                                ),
                                                SizedBox(height: 5,),
                                                GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        if(showGraph){
                                                          showGraph = false;
                                                        }else{
                                                          showGraph = true;
                                                        }
                                                      });
                                                    },
                                                    child: Image.asset("assets/images/pencil.png"),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/trophy.png",
                                                    ),
                                                    SizedBox(width: 5,),

                                                    sText("${report[indexReport].rank}${getPositionPostfix(report[indexReport].rank!)}",weight: FontWeight.bold,color: Colors.grey),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/fav.svg",
                                                    ),
                                                    PercentageSnippet(
                                                      correctlyAnswered: report[indexReport].totalCorrectQuestions,
                                                      totalQuestions: report[indexReport].totalQuestions,
                                                      isSelected: false,
                                                    )

                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      if(listReportData[index]){
                                                        listReportData[index] = false;
                                                      }else{
                                                        listReportData[index] = true;
                                                      }
                                                    });
                                                  },
                                                    child: Icon( listReportData[index] ? Icons.keyboard_double_arrow_down : Icons.keyboard_double_arrow_up),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20,),
                                      if(listReportData[index])
                                      if(showGraph)
                                        PerformanceGraph(course:Course(id: report[indexReport].courseId) ,tabName: "all",rightWidgetState: "average",onChangeStatus: false,groupId: widget.groupData!.id!,)
                                      else
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0XFFFAFAFA),
                                            borderRadius: BorderRadius.circular(15)
                                        ),
                                        padding: bottomPadding(15),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      // padding: EdgeInsets.only(top: 10,bottom: 10,left:10),

                                                      child: Column(
                                                        children: [
                                                          sText("Total ",color: Colors.grey,align: TextAlign.center),
                                                          sText("Score",color: Colors.grey,align: TextAlign.center),
                                                          SizedBox(height: 10,),
                                                          sText("${report[indexReport].totalCorrectQuestions}",weight: FontWeight.bold,size: 25),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.white,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 10,bottom: 10,left: 0),
                                                    child: Column(
                                                      children: [
                                                        sText("Test",color: Colors.grey),
                                                        SizedBox(height: 10,),
                                                        sText("${report[indexReport].totalTests}",weight: FontWeight.bold,size: 25),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    width: 2,
                                                    color: Colors.white,
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        sText("Grade",color: Colors.grey),
                                                        SizedBox(height: 10,),
                                                        sText(getGrade(report[indexReport].avgScore!),weight: FontWeight.bold,size: 25),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 2,
                                              color: Colors.white,
                                            ),
                                            Container(
                                              padding: topPadding(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        sText("Speed",color: Colors.grey),
                                                        Container(
                                                          width: 80,
                                                          height: 80,
                                                          child: SfRadialGauge(
                                                              enableLoadingAnimation: true,

                                                              axes: <RadialAxis>[

                                                                RadialAxis(minimum: 0, maximum: 1, useRangeColorForAxis: false,ranges: <GaugeRange>[
                                                                  GaugeRange(
                                                                    startValue: 0,
                                                                    endValue: double.parse(report[indexReport].avgTime!),
                                                                    color: Color(0xFF93E7EB),
                                                                    startWidth: 10,
                                                                    endWidth: 10,
                                                                    // rangeOffset: 5,
                                                                  ),


                                                                ], pointers: <GaugePointer>[
                                                                  // NeedlePointer(value: 50)
                                                                ], annotations: <GaugeAnnotation>[
                                                                  GaugeAnnotation(
                                                                      widget: Container(
                                                                          child:  Text('${report[indexReport].avgTime}q/m',
                                                                              style: TextStyle(
                                                                                  fontSize: 8, fontWeight: FontWeight.bold))),
                                                                      angle: 0,
                                                                      positionFactor: 0.1)
                                                                ],
                                                                  // showAxisLine: false,
                                                                  showFirstLabel: false,
                                                                  showLabels: false,
                                                                  showLastLabel: false,
                                                                  showTicks: false,
                                                                  canScaleToFit: true,
                                                                  axisLabelStyle: GaugeTextStyle(
                                                                      color: Colors.white
                                                                  ),
                                                                  axisLineStyle: AxisLineStyle(
                                                                    dashArray: [1,2],

                                                                  ),
                                                                  majorTickStyle: MajorTickStyle(
                                                                      dashArray: [1,2],
                                                                      length: 2,
                                                                      thickness: 6
                                                                  ),
                                                                  minorTickStyle: MinorTickStyle(
                                                                      dashArray: [1,2],
                                                                      length: 2,
                                                                      thickness: 9
                                                                  ),

                                                                )
                                                              ]),
                                                        )                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        sText("Mastery",color: Colors.grey),
                                                        SizedBox(height: 10,),
                                                        Center(
                                                          child: SizedBox(
                                                            child: Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: 60,
                                                                  width: 60,
                                                                  child: CircularProgressIndicator(
                                                                    color: report[indexReport].avgScore == "0.00" ? Colors.grey[200] : Color(0XFF8CFFC5),
                                                                    strokeWidth: 5,

                                                                    value: report[indexReport].avgScore == "0.00" ? 1 : double.parse(report[indexReport].avgScore!),

                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 20,
                                                                  left: 15,
                                                                  child: Center(
                                                                    child: Column(
                                                                      children: [
                                                                        PercentageSnippet(
                                                                          correctlyAnswered: report[indexReport].totalCorrectQuestions,
                                                                          totalQuestions: report[indexReport].totalQuestions,
                                                                          isSelected: false,
                                                                        ),
                                                                        sText("avg.score",size: 7,weight: FontWeight.normal),

                                                                      ],
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
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        sText("Strength",color: Colors.grey),
                                                        SizedBox(height: 30,),
                                                        AdeoSignalStrengthIndicator(
                                                          strength: double.parse(report[indexReport].avgScore!),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                if(!listReportData[index])
                                if(!showGraph)
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(left: 0,right: 0),
                                      shrinkWrap: true,
                                      itemCount: report.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index){
                                        return Container(
                                          width: 10,
                                          height: 10,
                                          margin: EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color: _currentSlide == index ?  Color(0xFF2A9CEA) : sGray,
                                              shape: BoxShape.circle
                                          ),
                                        );
                                  }),
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(height: 10,),
                    Divider(color: Colors.white,height: 5,thickness: 5,),
                    SizedBox(height: 10,),
                  ],
                );
           }),
         )  : progressCodeAll ? Expanded(child: Center(child: progress(),)) : Expanded(child: Center(child: sText("No records found"),))

        ],
      ),
    );
  }
}
