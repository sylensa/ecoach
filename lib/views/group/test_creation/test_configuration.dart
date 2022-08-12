import 'package:another_xlider/another_xlider.dart';
import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_test_model.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../utils/constants.dart';

class TestConfigurations extends StatefulWidget {
  String testName ;
   TestConfigurations({this.testName = '',Key? key}) : super(key: key);

  @override
  State<TestConfigurations> createState() => _TestConfigurationsState();
}

class _TestConfigurationsState extends State<TestConfigurations> {
  TextEditingController testNameController = TextEditingController();
  TextEditingController testDescriptionController = TextEditingController();
  List<ListNames> listTiming = [ListNames(name: "Time per Question",id: "1"),ListNames(name: "Time per Quiz",id: "2",),ListNames(name: "Untimed",id: "3")];
  ListNames? timing;
  double _lowerValue = 0;
  double _upperValue = 100;
  DateTime? startDateTime;
  DateTime? dueDateTime;
  bool passMarkOn = false;
  bool instantResultOn = false;
  bool reviewOn = false;

  createGroupTest({String title = '', String description = ''}) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      Map configuration = {
          "timing" : timing!.name,
          "count_down": _lowerValue,
          "start_datetime": startDateTime.toString(),
          "due_dateTime": dueDateTime.toString(),
          "show_pass_mark": passMarkOn,
          "show_instant_result": instantResultOn,
          "show_review": reviewOn,
          "test_source": groupTestSource,
          "bundle": groupTestBundle,
          "course": groupTestCourse,
          "test_type": groupTestType,
          "test_id": groupTestId,
      };
      print("configuration:${configuration}");
      List<GroupTestData> test = [];
      if (isConnected) {
        GroupTestData? groupTestData = await GroupManagementController(groupId: groupID).createGroupTest(configuration,name: testNameController.text,instruction: testDescriptionController.text);
        if (groupTestData != null) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          test.add(groupTestData);
          listGroupTestData.insertAll(0, test);
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        showNoConnectionToast(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print("error:${e.toString()}");
    }
    setState(() {});
  }



  @override
 void  initState(){
  timing = listTiming[0];
  testNameController.text = widget.testName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(

        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: kHomeBackgroundColor,
        title: sText("Test Configurations",color: Colors.black,weight: FontWeight.bold,size: 20),
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
                      value: 1,
                    ),
                    Center(
                      child: Text(
                        "6",
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sText("Test Name",color: kAdeoGray3),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  // autofocus: true,
                                  controller:testNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please check that you\'ve entered group email';
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                  decoration: textDecorNoBorder(
                                    radius: 10,
                                    hintColor: Color(0xFFB9B9B9),
                                    borderColor:Colors.white ,
                                    fill: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sText("Test Instruction/Description",color: kAdeoGray3),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  // autofocus: true,
                                  controller: testDescriptionController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please check that you\'ve entered your group description';
                                    }
                                    return null;
                                  },
                                  maxLines: 3,
                                  autofocus: false,
                                  decoration: textDecorNoBorder(
                                    radius: 10,
                                    hintColor: Color(0xFFB9B9B9),
                                    borderColor:Colors.white ,
                                    fill: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(left: 20,right:20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sText("Timing",color: kAdeoGray3),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.only(left: 12, right: 20),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ListNames>(
                                  value: timing ?? listTiming[0],
                                  itemHeight: 70,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kDefaultBlack,
                                  ),
                                  onChanged: (ListNames? value){
                                    setState((){
                                      timing = value;
                                      _lowerValue = 1;
                                      print(timing!.id);
                                    });
                                  },
                                  items: listTiming.map(
                                        (item) => DropdownMenuItem<ListNames>(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: TextStyle(
                                          color: kDefaultBlack,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    timing!.id == "1" ?
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: appWidth(context),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: FlutterSlider(

                            tooltip: FlutterSliderTooltip(

                             alwaysShowTooltip: true,
                              textStyle: appStyle(col:  Color(0XFF0367B4),weight: FontWeight.bold),
                              rightSuffix: Container(child: sText(" sec",color: Color(0XFF0367B4),weight: FontWeight.bold),),
                              positionOffset: FlutterSliderTooltipPositionOffset(
                                left:10,
                                right: 10,
                                top: -5,

                              ),
                            ),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 10,
                              inactiveTrackBarHeight: 10,
                                inactiveTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:   Colors.grey[300]!,
                                  border: Border.all(width: 1, color: Colors.grey[200]!),
                                ),
                                activeTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0XFF0367B4)
                                ),
                                activeDisabledTrackBarColor: Colors.blue
                            ),
                            jump: false,
                            max: 300,
                            min: 0,

                            values: [_lowerValue, 300],
                            onDragCompleted: (handlerIndex, lowerValue, upperValue)async {
                              _lowerValue = lowerValue.toDouble();
                              print(_lowerValue);
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sText("0",color: Colors.black,size: 14,weight: FontWeight.w500),
                              sText("300",color: Colors.black,size: 14,weight: FontWeight.w500),
                            ],
                          ),
                        ),
                      ],
                    ) :
                    timing!.id == "2" ?
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: appWidth(context),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: FlutterSlider(

                            tooltip: FlutterSliderTooltip(

                              alwaysShowTooltip: true,
                              textStyle: appStyle(col:  Color(0XFF0367B4),weight: FontWeight.bold),
                              rightSuffix: Container(child: sText(" mins",color: Color(0XFF0367B4),weight: FontWeight.bold),),
                              positionOffset: FlutterSliderTooltipPositionOffset(
                                left:10,
                                right: 10,
                                top: -5,

                              ),
                            ),
                            trackBar: FlutterSliderTrackBar(
                                activeTrackBarHeight: 10,
                                inactiveTrackBarHeight: 10,
                                inactiveTrackBar: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:   Colors.grey[300]!,
                                  border: Border.all(width: 1, color: Colors.grey[200]!),
                                ),
                                activeTrackBar: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0XFF0367B4)
                                ),
                                activeDisabledTrackBarColor: Colors.blue
                            ),
                            jump: true,
                            max: 120,
                            min: 1,

                            values: [_lowerValue, 120],
                            onDragCompleted: (handlerIndex, lowerValue, upperValue)async {
                              _lowerValue = lowerValue.toDouble();
                              print(_lowerValue);
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sText("0 hrs",color: Colors.black,size: 14,weight: FontWeight.w500),
                              sText("2 hrs",color: Colors.black,size: 14,weight: FontWeight.w500),
                            ],
                          ),
                        ),
                      ],
                    ) : Container(),

                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          child: ExpansionTile(
                            textColor: kAdeoGray3,
                            iconColor: kAdeoGray3,
                            initiallyExpanded: false,
                            maintainState: false,
                            backgroundColor: Colors.white,
                            childrenPadding: EdgeInsets.zero,
                            collapsedIconColor: kAdeoGray3,
                            leading: Container(
                              child: sText("Exact Time",weight: FontWeight.w500,size: 16),
                            ) ,
                            title: Container()  ,
                            children: <Widget>[
                              Divider(color: Colors.grey,),
                                MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: ()async{

                                    DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2018, 3, 5),
                                        maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                          setState((){
                                            startDateTime = date;
                                            print('change $date');
                                          });
                                        }, onConfirm: (date) {
                                          setState((){
                                            startDateTime = date;
                                            print('confirm $date');
                                          });
                                        }, currentTime: DateTime.now(), locale: LocaleType.en);

                                    setState(() {
                                      if(startDateTime != null){
                                        print(startDateTime);
                                        print("${startDateTime!.year}-${startDateTime!.month}-${startDateTime!.day}");
                                      }

                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20,right: 20,top: 10),

                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Column(
                                      children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  sText("Start Date and Time",weight: FontWeight.w500,size: 16),
                                                  Expanded(child: Container()),
                                                  Icon(Icons.calendar_today_outlined,color: kAdeoGray3,size: 16,)
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              if(startDateTime != null)
                                              sText("${startDateTime.toString().split(".").first}",weight: FontWeight.w500,size: 12,color: kAdeoGray2),

                                            ],
                                          ),

                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),

                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          child: ExpansionTile(
                            textColor: kAdeoGray3,
                            iconColor: kAdeoGray3,
                            initiallyExpanded: false,
                            maintainState: false,
                            backgroundColor: Colors.white,
                            childrenPadding: EdgeInsets.zero,
                            collapsedIconColor: kAdeoGray3,
                            leading: Container(
                              child: sText("Define Period",weight: FontWeight.w500,size: 16),
                            ) ,
                            title: Container()  ,
                            children: <Widget>[
                              Divider(color: Colors.grey,),
                              MaterialButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2018, 3, 5),
                                      maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                        setState((){
                                          dueDateTime = date;
                                          print('change $date');
                                        });
                                      }, onConfirm: (date) {
                                        setState((){
                                          dueDateTime = date;
                                          print('confirm $date');
                                        });
                                      }, currentTime: DateTime.now(), locale: LocaleType.en);

                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 20,right: 20,top: 10),

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              sText("Expiry Date and Time",weight: FontWeight.w500,size: 16),
                                              Expanded(child: Container()),
                                              Icon(Icons.calendar_today_outlined,color: kAdeoGray3,size: 16,)
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          if(dueDateTime != null)
                                          sText("${dueDateTime.toString().split(".").first}",weight: FontWeight.w500,size: 12,color: kAdeoGray2),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),

                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Pass mark", size: 16,weight: FontWeight.w500),
                              ),
                              FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: passMarkOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Colors.grey[200]!,
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Colors.white,
                                onToggle: (val) {
                                  setState(() {
                                    passMarkOn = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Instant Result", size: 16,weight: FontWeight.w500),
                              ),
                              FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: instantResultOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Colors.grey[200]!,
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Colors.white,
                                onToggle: (val) {
                                  setState(() {
                                    instantResultOn = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: sText("Review", size: 16,weight: FontWeight.w500),
                              ),
                              FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: reviewOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Colors.grey[200]!,
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Colors.white,
                                onToggle: (val) {
                                  setState(() {
                                    reviewOn = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
             GestureDetector(
               onTap: ()async{
                 showLoaderDialog(context);
                 await createGroupTest();
               },
               child: Container(
                 width: appWidth(context),
                 padding: EdgeInsets.symmetric(vertical: 20),
                 child: sText("Publish Test",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold,size: 20),
                 color: Color(0xFF00C9B9),
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
