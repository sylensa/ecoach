import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/widgets/adeo_signal_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GroupPerformance extends StatefulWidget {
  const GroupPerformance({Key? key}) : super(key: key);

  @override
  State<GroupPerformance> createState() => _GroupPerformanceState();
}

class _GroupPerformanceState extends State<GroupPerformance> {
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
  int _currentSlide = 0;
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
         Expanded(
           child: ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: 10,
               itemBuilder: (BuildContext context, int index){
                return    Column(
                  children: [
                    CarouselSlider.builder(
                        options:
                        CarouselOptions(
                          height:
                          365,
                          autoPlay:
                          false,
                          enableInfiniteScroll:
                          false,
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
                        itemCount:5,
                        itemBuilder: (BuildContextcontext, int index, int index2) {
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
                                                  child: sText("JHS Mathematics",weight: FontWeight.bold,size: 10),
                                                ),
                                                SizedBox(height: 5,),
                                                Image.asset("assets/images/pencil.png")
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

                                                    sText("2nd",weight: FontWeight.bold,color: Colors.grey),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/fav.svg",
                                                    ),
                                                    sText("85%",weight: FontWeight.bold),

                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Icon(Icons.keyboard_double_arrow_down),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 20,),
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
                                                          sText("609",weight: FontWeight.bold,size: 25),
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
                                                        sText("20",weight: FontWeight.bold,size: 25),
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
                                                        sText("B2",weight: FontWeight.bold,size: 25),
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

                                                                RadialAxis(minimum: 0, maximum: 150, useRangeColorForAxis: false,ranges: <GaugeRange>[
                                                                  GaugeRange(
                                                                    startValue: 0,
                                                                    endValue: 50,
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
                                                                          child: const Text('5.0q/m',
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
                                                                    color: Color(0XFF8CFFC5),
                                                                    strokeWidth: 5,

                                                                    value: 0.7,

                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 20,
                                                                  left: 15,
                                                                  child: Center(
                                                                    child: Column(
                                                                      children: [
                                                                        sText("85%",size: 10,weight: FontWeight.bold),
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
                                                          strength: 100,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: map<Widget>(5, (index, url) {
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
         )
        ],
      ),
    );
  }
}
