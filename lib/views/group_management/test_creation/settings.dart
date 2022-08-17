import 'package:currency_picker/currency_picker.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import 'package:country_list_pick/country_list_pick.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> accessKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String currencys = 'Select currency';
  TextEditingController _accessController = TextEditingController();
  bool switchOn = false;
  List gradingSystem = [];
  List<ListNames> listBeceGrading = [ListNames(name: "80")];
  static List<String> rangeList = [];

  increaseRange(int i,){
    if(i == 0){
      if(int.parse(listBeceGrading[i].name) != 100){
        listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
      }else{
        toastMessage("Maximum value is 100");
      }
    }else{
      if(int.parse(listBeceGrading[i].name) == 100){
        toastMessage("Can not exceed 100");
      }else if(int.parse(listBeceGrading[i].name) >= int.parse(listBeceGrading[i -1].name) - 1){
        toastMessage("This range cannot be bigger than previous range");
      }else if( int.parse(listBeceGrading[i].name) <= 100){
        listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
      }
    }


  }

  decreaseRange(int i){
    if(int.parse(listBeceGrading[i].name) == 0){
      toastMessage("Can not go below 0");
      return false;
    }else if(int.parse(listBeceGrading[i].name) != 0){
      listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
      return true;
    }
  }

  addNewRangeCheck(int i,){
    if(int.parse(listBeceGrading[i].name) == 100){
      toastMessage("Can not exceed 100");
      return false;
    }else if(int.parse(listBeceGrading[i].name) >= int.parse(listBeceGrading[i -1].name)){
      toastMessage("The last range cannot be bigger or equal to the previous value");
      return false;
    }else if( int.parse(listBeceGrading[i].name) <= 100){
      return true;
    }

  }

  addNewRange(){
    if(listBeceGrading.length != 1){
      if(addNewRangeCheck(listBeceGrading.length -1)){
        if(int.parse(listBeceGrading.last.name) != 0){
          ListNames beceGrading = ListNames(name: "0",);
          listBeceGrading.add(beceGrading);
        }
      }
    }else{
      if(int.parse(listBeceGrading.last.name) == 100){
        toastMessage("Can not exceed 100");
      }else{
        ListNames beceGrading = ListNames(name: "0",);
        listBeceGrading.add(beceGrading);
      }

    }

  }

  @override
  initState() {
    super.initState();
    selectedStatus = status[0];
    _accessController = TextEditingController();
  }

  @override
  dispose() {
    _accessController.dispose();
    super.dispose();
  }


  var selectedRadio;

  String? selectedStatus;

  List status = ['Paid', 'Free'];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Group Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                sText(
                  "Access".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFfFFFF),
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  child: Form(
                    key: accessKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField(
                          borderRadius: BorderRadius.circular(width * 0.025),
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(
                              () {
                                selectedStatus = value.toString();
                                print(selectedStatus);
                              },
                            );
                          },
                          selectedItemBuilder: (context) => status.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: Color(0xFF0E0E0E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: status.map(
                            (status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        if (selectedStatus == status[0]) buildInputField()
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                sText(
                  "Subscription".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                  SizedBox(height: 20,),
                Container(
                  height: height * 0.18,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFfFFFF),
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.025),
                            child: sText(
                              "Monthly",
                              color: Color(0xFF5a6775),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.025),
                            child: FlutterSwitch(
                              width: 50.0,
                              height: 20.0,
                              valueFontSize: 10.0,
                              toggleSize: 15.0,
                              value: switchOn,
                              borderRadius: 30.0,
                              padding: 2.0,
                              showOnOff: false,
                              activeColor: Color(0xFF555555),
                              inactiveColor: Color(0xFFD1D1D1),
                              inactiveTextColor: Colors.red,
                              inactiveToggleColor: Color(0xFF555555),
                              onToggle: (val) {
                                setState(() {
                                  switchOn = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                        SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.025),
                            child:
                                sText("Yearly", color: Color(0xFF5a6775)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.025),
                            child: FlutterSwitch(
                              width: 50.0,
                              height: 20.0,
                              valueFontSize: 10.0,
                              toggleSize: 15.0,
                              value: switchOn,
                              borderRadius: 30.0,
                              padding: 2.0,
                              showOnOff: false,
                              activeColor: Color(0xFF555555),
                              inactiveColor: Color(0xFFD1D1D1),
                              inactiveTextColor: Colors.red,
                              inactiveToggleColor: Color(0xFF555555),
                              onToggle: (val) {
                                setState(() {
                                  switchOn = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                sText(
                  "Features".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                  SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFfFFFF),
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Speed",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Mastery",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Improvement Rate",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Overall Outlook",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Total Score",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Group Average Score",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Pass mark",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Instant Result",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Summaries",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: sText("Review",weight: FontWeight.normal,color: Color(0xFF5a6775)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: FlutterSwitch(
                                width: 50.0,
                                height: 20.0,
                                valueFontSize: 10.0,
                                toggleSize: 15.0,
                                value: switchOn,
                                borderRadius: 30.0,
                                padding: 2.0,
                                showOnOff: false,
                                activeColor: Color(0xFF555555),
                                inactiveColor: Color(0xFFD1D1D1),
                                inactiveTextColor: Colors.red,
                                inactiveToggleColor: Color(0xFF555555),
                                onToggle: (val) {
                                  setState(() {
                                    switchOn = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20,),
                sText(
                  "Grading System".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFfFFFF),
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      sText("Choose Your Preferred Grading System",size: 12),
                      SizedBox(height: 20,),
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.grey,
                              initiallyExpanded:gradingSystem.contains("BECE") ? true : false,
                              maintainState: false,
                              onExpansionChanged: (value){
                                setState(() {
                                  gradingSystem.clear();
                                  gradingSystem.add("BECE");
                                });
                              },
                              backgroundColor: Colors.white,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.grey,

                              leading: Container(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                child:   Container(
                                  padding: EdgeInsets.all(2.0),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.0,
                                      color: gradingSystem.contains("BECE") ? Color(0xFF00C9B9) : Colors.grey,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: gradingSystem.contains("BECE") ? Color(0xFF00C9B9) : Colors.white,
                                  ),
                                ),
                              ),

                              title:  sText("BECE", color: kAdeoGray3, size: 16),
                              children: <Widget>[
                                // Container(
                                //
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             sText("Grade", color: Colors.grey),
                                //             sText("Range", color: Colors.grey),
                                //
                                //           ],
                                //         ),
                                //       ),
                                //       for(int i =0; i < listBeceGrading.length; i++)
                                //       Container(
                                //         padding: EdgeInsets.only(left: 50,top: 0,right: 20),
                                //         child: Row(
                                //           children: [
                                //             sText("${i +1}",align: TextAlign.center),
                                //               Expanded(child: Container()),
                                //             GestureDetector(
                                //                 onTap: (){
                                //                  setState((){
                                //                    if(i == 0 && int.parse(listBeceGrading[i].name) == 0){
                                //                      toastMessage("Can not go below 0");
                                //                    }else if(i == 0 && int.parse(listBeceGrading[i].name) != 0){
                                //                      listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                    }else if( int.parse(listBeceGrading[i].name) == 0){
                                //                      toastMessage("Can not go below 0");
                                //                    }else{
                                //                      print(listBeceGrading[i].name);
                                //                      listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                    }
                                //                  });
                                //                 },
                                //                 child: Icon(Icons.horizontal_rule),
                                //             ),
                                //             Container(
                                //               width: 70,
                                //               height: 50,
                                //               child: TextFormField(
                                //                 keyboardType: TextInputType.number,
                                //                 onChanged: (value){
                                //                   setState((){
                                //                     if(value.isNotEmpty){
                                //                       if(i == 0 && int.parse(value) == 0){
                                //                         toastMessage("Can not go below 0");
                                //                       }else if(i == 0 && int.parse(value) != 0){
                                //                         listBeceGrading[i].name =  value;
                                //                       }else if( int.parse(value) == 0){
                                //                         toastMessage("Can not go below 0");
                                //                       }else if(int.parse(value) > int.parse(listBeceGrading[i -1].name) -1){
                                //                         toastMessage("Can not exceed the top value");
                                //                         listBeceGrading[i].name ="0";
                                //                       }else{
                                //                         if(i == 0 && int.parse(value) == 100){
                                //                           toastMessage("Can not exceed 100");
                                //                         }else if(i == 0 && int.parse(value) != 100){
                                //                           listBeceGrading[i].name =  value;
                                //                         }else if(int.parse(value) < int.parse(listBeceGrading[i -1].name) -1){
                                //                           listBeceGrading[i].name =  value;
                                //                         }else{
                                //                           listBeceGrading[i].name =  value;
                                //                         }
                                //                       }
                                //                     }else{
                                //                       listBeceGrading[i].name = "0";
                                //                     }
                                //
                                //
                                //                   });
                                //                   print("object:${ listBeceGrading[i].name }");
                                //
                                //                 },
                                //                 decoration: textDecor(hint: listBeceGrading[i].name,label: listBeceGrading[i].name,hintColor: Colors.black),
                                //
                                //               ),
                                //             ),
                                //             GestureDetector(
                                //               onTap: (){
                                //                 setState((){
                                //                   if(i == 0 && int.parse(listBeceGrading[i].name) == 100){
                                //                     toastMessage("Can not exceed 100");
                                //                   }else if(i == 0 && int.parse(listBeceGrading[i].name) != 100){
                                //                     listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                   }else{
                                //                     if(int.parse(listBeceGrading[i].name) != int.parse(listBeceGrading[i -1].name) -1){
                                //                       listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                     }
                                //                   }
                                //
                                //                 });
                                //                 print("object:${ listBeceGrading[i].name }");
                                //               },
                                //                 child: Icon(Icons.add),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: bottomPadding(10),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.last.name != 0){
                                //                     ListNames beceGrading = ListNames(name: "0",);
                                //                     listBeceGrading.add(beceGrading);
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: leftPadding(30),
                                //                 child: sText("Add", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: kAccessmentButtonColor,
                                //                     borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             ),
                                //
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.length != 1){
                                //                     listBeceGrading.removeLast();
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: rightPadding(30),
                                //                 child: sText("Remove", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.grey,
                              initiallyExpanded:gradingSystem.contains("WASSCE") ? true : false,
                              maintainState: false,
                              onExpansionChanged: (value){
                                setState(() {
                                  gradingSystem.clear();
                                  gradingSystem.add("WASSCE");
                                });
                              },
                              backgroundColor: Colors.white,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.grey,

                              leading: Container(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                child:   Container(
                                  padding: EdgeInsets.all(2.0),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.0,
                                      color: gradingSystem.contains("WASSCE") ? Color(0xFF00C9B9) : Colors.grey,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: gradingSystem.contains("WASSCE") ? Color(0xFF00C9B9) : Colors.white,
                                  ),
                                ),
                              ),

                              title:  sText("WASSCE", color: kAdeoGray3, size: 16),
                              children: <Widget>[
                                // Container(
                                //
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             sText("Grade", color: Colors.grey),
                                //             sText("Range", color: Colors.grey),
                                //
                                //           ],
                                //         ),
                                //       ),
                                //       for(int i =0; i < listBeceGrading.length; i++)
                                //       Container(
                                //         padding: EdgeInsets.only(left: 50,top: 0,right: 20),
                                //         child: Row(
                                //           children: [
                                //             sText("${i +1}",align: TextAlign.center),
                                //               Expanded(child: Container()),
                                //             GestureDetector(
                                //                 onTap: (){
                                //                  setState((){
                                //                    if(i == 0 && int.parse(listBeceGrading[i].name) == 0){
                                //                      toastMessage("Can not go below 0");
                                //                    }else if(i == 0 && int.parse(listBeceGrading[i].name) != 0){
                                //                      listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                    }else if( int.parse(listBeceGrading[i].name) == 0){
                                //                      toastMessage("Can not go below 0");
                                //                    }else{
                                //                      print(listBeceGrading[i].name);
                                //                      listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                    }
                                //                  });
                                //                 },
                                //                 child: Icon(Icons.horizontal_rule),
                                //             ),
                                //             Container(
                                //               width: 70,
                                //               height: 50,
                                //               child: TextFormField(
                                //                 keyboardType: TextInputType.number,
                                //                 onChanged: (value){
                                //                   setState((){
                                //                     if(value.isNotEmpty){
                                //                       if(i == 0 && int.parse(value) == 0){
                                //                         toastMessage("Can not go below 0");
                                //                       }else if(i == 0 && int.parse(value) != 0){
                                //                         listBeceGrading[i].name =  value;
                                //                       }else if( int.parse(value) == 0){
                                //                         toastMessage("Can not go below 0");
                                //                       }else if(int.parse(value) > int.parse(listBeceGrading[i -1].name) -1){
                                //                         toastMessage("Can not exceed the top value");
                                //                         listBeceGrading[i].name ="0";
                                //                       }else{
                                //                         if(i == 0 && int.parse(value) == 100){
                                //                           toastMessage("Can not exceed 100");
                                //                         }else if(i == 0 && int.parse(value) != 100){
                                //                           listBeceGrading[i].name =  value;
                                //                         }else if(int.parse(value) < int.parse(listBeceGrading[i -1].name) -1){
                                //                           listBeceGrading[i].name =  value;
                                //                         }else{
                                //                           listBeceGrading[i].name =  value;
                                //                         }
                                //                       }
                                //                     }else{
                                //                       listBeceGrading[i].name = "0";
                                //                     }
                                //
                                //
                                //                   });
                                //                   print("object:${ listBeceGrading[i].name }");
                                //
                                //                 },
                                //                 decoration: textDecor(hint: listBeceGrading[i].name,label: listBeceGrading[i].name,hintColor: Colors.black),
                                //
                                //               ),
                                //             ),
                                //             GestureDetector(
                                //               onTap: (){
                                //                 setState((){
                                //                   if(i == 0 && int.parse(listBeceGrading[i].name) == 100){
                                //                     toastMessage("Can not exceed 100");
                                //                   }else if(i == 0 && int.parse(listBeceGrading[i].name) != 100){
                                //                     listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                   }else{
                                //                     if(int.parse(listBeceGrading[i].name) != int.parse(listBeceGrading[i -1].name) -1){
                                //                       listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                     }
                                //                   }
                                //
                                //                 });
                                //                 print("object:${ listBeceGrading[i].name }");
                                //               },
                                //                 child: Icon(Icons.add),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: bottomPadding(10),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.last.name != 0){
                                //                     ListNames beceGrading = ListNames(name: "0",);
                                //                     listBeceGrading.add(beceGrading);
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: leftPadding(30),
                                //                 child: sText("Add", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: kAccessmentButtonColor,
                                //                     borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             ),
                                //
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.length != 1){
                                //                     listBeceGrading.removeLast();
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: rightPadding(30),
                                //                 child: sText("Remove", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.grey,
                              initiallyExpanded:gradingSystem.contains("IGCSE") ? true : false,
                              maintainState: false,
                              onExpansionChanged: (value){
                                setState(() {
                                    gradingSystem.clear();
                                    gradingSystem.add("IGCSE");
                                });
                              },
                              backgroundColor: Colors.white,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.grey,

                              leading: Container(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                child:   Container(
                                  padding: EdgeInsets.all(2.0),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.0,
                                      color: gradingSystem.contains("IGCSE") ? Color(0xFF00C9B9) : Colors.grey,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: gradingSystem.contains("IGCSE") ? Color(0xFF00C9B9) : Colors.white,
                                  ),
                                ),
                              ),

                              title:  sText("IGCSE", color: kAdeoGray3, size: 16),
                              children: <Widget>[
                                // Container(
                                //
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             sText("Grade", color: Colors.grey),
                                //             sText("Range", color: Colors.grey),
                                //
                                //           ],
                                //         ),
                                //       ),
                                //       for(int i =0; i < listBeceGrading.length; i++)
                                //         Container(
                                //           padding: EdgeInsets.only(left: 50,top: 0,right: 20),
                                //           child: Row(
                                //             children: [
                                //               sText("${i +1}",align: TextAlign.center),
                                //               Expanded(child: Container()),
                                //               GestureDetector(
                                //                 onTap: (){
                                //                   setState((){
                                //                     if(i == 0 && int.parse(listBeceGrading[i].name) == 0){
                                //                       toastMessage("Can not go below 0");
                                //                     }else if(i == 0 && int.parse(listBeceGrading[i].name) != 0){
                                //                       listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                     }else if( int.parse(listBeceGrading[i].name) == 0){
                                //                       toastMessage("Can not go below 0");
                                //                     }else{
                                //                       print(listBeceGrading[i].name);
                                //                       listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) - 1}";
                                //                     }
                                //                   });
                                //                 },
                                //                 child: Icon(Icons.horizontal_rule),
                                //               ),
                                //               Container(
                                //                 width: 70,
                                //                 height: 50,
                                //                 child: TextFormField(
                                //                   keyboardType: TextInputType.number,
                                //                   onChanged: (value){
                                //                     setState((){
                                //                       if(value.isNotEmpty){
                                //                         if(i == 0 && int.parse(value) == 0){
                                //                           toastMessage("Can not go below 0");
                                //                         }else if(i == 0 && int.parse(value) != 0){
                                //                           listBeceGrading[i].name =  value;
                                //                         }else if( int.parse(value) == 0){
                                //                           toastMessage("Can not go below 0");
                                //                         }else if(int.parse(value) > int.parse(listBeceGrading[i -1].name) -1){
                                //                           toastMessage("Can not exceed the top value");
                                //                           listBeceGrading[i].name ="0";
                                //                         }else{
                                //                           if(i == 0 && int.parse(value) == 100){
                                //                             toastMessage("Can not exceed 100");
                                //                           }else if(i == 0 && int.parse(value) != 100){
                                //                             listBeceGrading[i].name =  value;
                                //                           }else if(int.parse(value) < int.parse(listBeceGrading[i -1].name) -1){
                                //                             listBeceGrading[i].name =  value;
                                //                           }else{
                                //                             listBeceGrading[i].name =  value;
                                //                           }
                                //                         }
                                //                       }else{
                                //                         listBeceGrading[i].name = "0";
                                //                       }
                                //
                                //
                                //                     });
                                //                     print("object:${ listBeceGrading[i].name }");
                                //
                                //                   },
                                //                   decoration: textDecor(hint: listBeceGrading[i].name,label: listBeceGrading[i].name,hintColor: Colors.black),
                                //
                                //                 ),
                                //               ),
                                //               GestureDetector(
                                //                 onTap: (){
                                //                   setState((){
                                //                     if(i == 0 && int.parse(listBeceGrading[i].name) == 100){
                                //                       toastMessage("Can not exceed 100");
                                //                     }else if(i == 0 && int.parse(listBeceGrading[i].name) != 100){
                                //                       listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                     }else{
                                //                       if(int.parse(listBeceGrading[i].name) != int.parse(listBeceGrading[i -1].name) -1){
                                //                         listBeceGrading[i].name =  "${int.parse(listBeceGrading[i].name) + 1}";
                                //                       }
                                //                     }
                                //
                                //                   });
                                //                   print("object:${ listBeceGrading[i].name }");
                                //                 },
                                //                 child: Icon(Icons.add),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       Container(
                                //         padding: bottomPadding(10),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.last.name != 0){
                                //                     ListNames beceGrading = ListNames(name: "0",);
                                //                     listBeceGrading.add(beceGrading);
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: leftPadding(30),
                                //                 child: sText("Add", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: kAccessmentButtonColor,
                                //                     borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             ),
                                //
                                //             GestureDetector(
                                //               onTap: () async {
                                //                 setState((){
                                //                   if(listBeceGrading.length != 1){
                                //                     listBeceGrading.removeLast();
                                //                   }
                                //                 });
                                //               },
                                //               child: Container(
                                //                 padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                //                 margin: rightPadding(30),
                                //                 child: sText("Remove", color: Colors.white),
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              textColor: Colors.white,
                              iconColor: Colors.grey,
                              initiallyExpanded:gradingSystem.contains("CUSTOM") ? true : false,
                              maintainState: false,
                              onExpansionChanged: (value){
                                setState(() {
                                  gradingSystem.clear();
                                  gradingSystem.add("CUSTOM");
                                });
                              },
                              backgroundColor: Colors.white,
                              childrenPadding: EdgeInsets.zero,
                              collapsedIconColor: Colors.grey,
                              leading: Container(
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                child:   Container(
                                  padding: EdgeInsets.all(2.0),
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.0,
                                      color: gradingSystem.contains("CUSTOM") ? Color(0xFF00C9B9) : Colors.grey,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: gradingSystem.contains("CUSTOM") ? Color(0xFF00C9B9) : Colors.white,
                                  ),
                                ),
                              ),
                              title:  sText("CUSTOM", color: kAdeoGray3, size: 16),
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF0F7FF),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            sText("Grade", color: Colors.grey),
                                            sText("Range", color: Colors.grey),

                                          ],
                                        ),
                                      ),
                                      for(int i =0; i < listBeceGrading.length; i++)
                                        Container(
                                          padding: EdgeInsets.only(left: 50,top: 0,right: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              sText("${i +1}",align: TextAlign.center),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        decreaseRange(i);
                                                      });
                                                    },
                                                    child: Icon(Icons.horizontal_rule),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Container(
                                                    width: 50,
                                                    child:  TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      onChanged: (value){
                                                        setState((){
                                                          // if(value.isNotEmpty){
                                                          //   if(i == 0 && int.parse(value) == 0){
                                                          //     toastMessage("Can not go below 0");
                                                          //   }
                                                          //   else if(i == 0 && int.parse(value) != 0){
                                                          //     listBeceGrading[i].name =  value;
                                                          //   }
                                                          //   else if( int.parse(value) == 0){
                                                          //     toastMessage("Can not go below 0");
                                                          //   }
                                                          //   else if(int.parse(value) > int.parse(listBeceGrading[i -1].name) -1){
                                                          //     toastMessage("Can not exceed the top value");
                                                          //     listBeceGrading[i].name ="0";
                                                          //   }
                                                          //   else{
                                                          //     if(i == 0 && int.parse(value) == 100){
                                                          //       toastMessage("Can not exceed 100");
                                                          //     }else if(i == 0 && int.parse(value) != 100){
                                                          //       listBeceGrading[i].name =  value;
                                                          //     }else if(int.parse(value) < int.parse(listBeceGrading[i -1].name) -1){
                                                          //       listBeceGrading[i].name =  value;
                                                          //     }else{
                                                          //       listBeceGrading[i].name =  value;
                                                          //     }
                                                          //   }
                                                          // }else{
                                                          //   listBeceGrading[i].name = "0";
                                                          // }
                                                          if(value.isNotEmpty){
                                                            listBeceGrading[i].name = value;
                                                          }else{
                                                            listBeceGrading[i].name = "0";
                                                          }

                                                        });
                                                        print("object:${ listBeceGrading[i].name }");

                                                      },
                                                      decoration: textDecor(hint: listBeceGrading[i].name,label: listBeceGrading[i].name,hintColor: Colors.black,padding: bottomPadding(10)),

                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      setState((){
                                                        increaseRange(i);


                                                      });
                                                      print("object:${ listBeceGrading[i].name }");
                                                    },
                                                    child: Icon(Icons.add),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                        padding: bottomPadding(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                setState((){
                                                 addNewRange();
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                margin: leftPadding(30),
                                                child: sText("Add", color: Colors.white),
                                                decoration: BoxDecoration(
                                                    color: kAccessmentButtonColor,
                                                    borderRadius: BorderRadius.circular(10)),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () async {
                                                setState((){
                                                  if(listBeceGrading.length != 1){
                                                    listBeceGrading.removeLast();
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                margin: rightPadding(30),
                                                child: sText("Remove", color: Colors.white),
                                                decoration: BoxDecoration(
                                                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                        Container(
                                        padding: EdgeInsets.only(left: 30,top: 0,right: 20),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF263E4A),
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            sText("Pass Mark",align: TextAlign.center,color: Colors.white),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    setState((){

                                                    });
                                                  },
                                                  child: Icon(Icons.horizontal_rule,color: Colors.grey),
                                                ),
                                                SizedBox(width: 20,),
                                                Container(
                                                  width: 50,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    onChanged: (value){
                                                      setState((){

                                                      });

                                                    },

                                                    decoration: textDecor(hint: "0",label: "00",hintColor: Colors.black,padding: EdgeInsets.only(bottom: 15)),

                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    setState((){

                                                    });
                                                  },
                                                  child: Icon(Icons.add,color: Colors.grey),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildInputField() {
    double width = appWidth(context);
    var _countryFlag;
    return Container(
      child: ListTile(
        leading: CountryListPick(
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: false,
            isShowCode: false,
            isDownIcon: false,
          ),
          initialSelection: '+233',
          onChanged: (value) => setState(() {
            _countryFlag = value!.flagUri;
            print(value.code);
          }),
        ),
        title: TextFormField(
          controller: _accessController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          maxLines: 1,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp('[0-9.,]+'),
            ),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            hintText: 'GHS 900',
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

