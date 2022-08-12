import 'package:ecoach/helper/helper.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'dart:io';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> accessKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _accessController = TextEditingController();

  @override
  initState() {
    super.initState();
    _accessController = TextEditingController();
  }

  @override
  dispose() {
    _accessController.dispose();
    super.dispose();
  }

  Map<String, bool> selectedSwitch = {
    'monthly': false,
    'yearly': false,
  };

  var selectedRadio;

  String? selectedStatus;

  List status = ['Paid', 'Free'];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              buildSizedBox(height * 0.01, width * 0),
              sText(
                "Access".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.01, width * 0),
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
              buildSizedBox(height * 0.03, width * 0),
              sText(
                "Subscription".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.02, width * 0),
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
                            switchValue[0],
                            color: Color(0xFF5a6775),
                          ),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[0]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[0]: value});
                              } else {
                                selectedSwitch.remove(switchValue[0]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    buildSizedBox(height * 0.015, width * 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child:
                              sText(switchValue[1], color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[1]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[1]: value});
                              } else {
                                selectedSwitch.remove(switchValue[1]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              buildSizedBox(height * 0.03, width * 0),
              sText(
                "Features".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.02, width * 0),
              Container(
                height: height * 0.75,
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
                    buildSizedBox(height * 0.02, width * 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child:
                              sText(switchValue[2], color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[2]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[2]: value});
                              } else {
                                selectedSwitch.remove(switchValue[2]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Mastery", color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[3]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[3]: value});
                              } else {
                                selectedSwitch.remove(switchValue[3]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Improvement Rate",
                              color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[4]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[4]: value});
                              } else {
                                selectedSwitch.remove(switchValue[4]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Overall Outlook",
                              color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[5]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[5]: value});
                              } else {
                                selectedSwitch.remove(switchValue[5]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Total Score", color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[6]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[6]: value});
                              } else {
                                selectedSwitch.remove(switchValue[6]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Group Total Score",
                              color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[7]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[7]: value});
                              } else {
                                selectedSwitch.remove(switchValue[7]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Pass mark", color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[8]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[8]: value});
                              } else {
                                selectedSwitch.remove(switchValue[8]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Instant Results",
                              color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[9]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[9]: value});
                              } else {
                                selectedSwitch.remove(switchValue[9]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Summaries", color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[10]),
                          onChanged: (value) {
                            setState(() {
                              if (value) {
                                selectedSwitch.addAll({switchValue[10]: value});
                              } else {
                                selectedSwitch.remove(switchValue[10]);
                              }
                            });
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.025),
                          child: sText("Review", color: Color(0xFF5a6775)),
                        ),
                        Switch(
                          value: selectedSwitch.keys.contains(switchValue[11]),
                          onChanged: (value) {
                            setState(
                              () {
                                if (value) {
                                  selectedSwitch
                                      .addAll({switchValue[11]: value});
                                } else {
                                  selectedSwitch.remove(switchValue[11]);
                                }
                              },
                            );
                          },
                          activeTrackColor: Colors.lightBlueAccent,
                          activeColor: Colors.blue,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              buildSizedBox(height * 0.03, width * 0),
              sText(
                "Grading System".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.02, width * 0),
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
                    buildSizedBox(height * 0.06, width * 0),
                    sText("Choose Your Preferred Grading System"),
                    buildSizedBox(height * 0.06, width * 0),
                    buildRadioButton(
                      selectedRadio: selectedRadio,
                      height: height,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                      text: GroupValue.values[0].name,
                      groupValue: GroupValue.values[0],
                    ),
                    buildRadioButton(
                      selectedRadio: selectedRadio,
                      height: height,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                      text: GroupValue.values[1].name,
                      groupValue: GroupValue.values[1],
                    ),
                    buildRadioButton(
                      selectedRadio: selectedRadio,
                      height: height,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                      text: GroupValue.values[2].name,
                      groupValue: GroupValue.values[2],
                    ),
                    buildRadioButton(
                      selectedRadio: selectedRadio,
                      height: height,
                      onChanged: (value) {
                        setState(() {
                          selectedRadio = value;
                        });
                      },
                      text: GroupValue.values[3].name,
                      groupValue: GroupValue.values[3],
                    ),
                  ],
                ),
              ),
              buildSizedBox(height * 0.06, width * 0),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildSizedBox(double height, double width) {
    return SizedBox(
      height: height,
    );
  }

  Widget buildInputField() {
    double width = appWidth(context);
    return Container(
      child: ListTile(
        leading: Image.asset(
          'icons/flags/png/gh.png',
          package: 'country_icons',
          width: width * 0.08,
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

class buildRadioButton extends StatefulWidget {
  buildRadioButton({
    Key? key,
    required this.selectedRadio,
    required this.height,
    required this.onChanged,
    required this.text,
    required this.groupValue,
  }) : super(key: key);

  final selectedRadio;
  final double height;
  final Function(dynamic value) onChanged;
  final String text;
  final GroupValue groupValue;

  @override
  State<buildRadioButton> createState() => _buildRadioButtonState();
}

class _buildRadioButtonState extends State<buildRadioButton> {
  TextEditingController gradeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final int passMark = 80;

  @override
  void initState() {
    gradeController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    gradeController.dispose();

    super.dispose();
  }

  final GlobalKey<ExpansionTileCardState> expansionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: ExpansionTileCard(
        expandedTextColor: Color(0xFF0E0E0E),
        key: expansionKey,
        elevation: 0.0,
        leading: Radio(
          activeColor: Color(
            0xFF00C9B9,
          ),
          value: widget.groupValue,
          groupValue: widget.selectedRadio,
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
        title: Text(widget.text),
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sText("Grade"),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.1),
                      child: sText("Range"),
                    ),
                  ],
                ),
              ),
              Container(
                height: widget.height * 0.7,
                width: width * 0.9,
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.040,
                  vertical: widget.height * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFf0f7ff),
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
                child: Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          width: width * 0.4,
                          child: Column(
                            children: [
                              GradeAndRange(
                                width: width,
                                numbering: " ${index + 1}",
                                grade: '80',
                                add: '+',
                                subtract: '-',
                                height: 0.0,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      top: widget.height * 0.6,
                      child: Container(
                        height: widget.height * 0.1,
                        width: width * 0.762,
                        decoration: BoxDecoration(
                          color: Color(0xFF263E4A),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(width * 0.025),
                            bottomRight: Radius.circular(width * 0.025),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sText(
                                "Pass Mark",
                                color: Colors.white.withOpacity(0.5),
                                weight: FontWeight.w500,
                                family: "Poppins",
                              ),
                              PassMark(
                                width: width,
                                height: height,
                                add: '+',
                                subtract: '-',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PassMarkController extends GetxController {
  final passMark = 80.obs;

  void increment() {
    passMark.value < 100 ? passMark.value++ : passMark.value = 80;
  }

  void decrement() {
    passMark.value > 0 ? passMark.value-- : passMark.value = 80;
  }
}

class PassMark extends StatefulWidget {
  const PassMark({
    Key? key,
    required this.width,
    required this.height,
    required this.add,
    required this.subtract,
  }) : super(key: key);

  final double width;
  final double height;
  final String add, subtract;

  @override
  State<PassMark> createState() => _PassMarkState();
}

class _PassMarkState extends State<PassMark> {
  TextEditingController passMarkController = TextEditingController();
  PassMarkController _passMarkController = PassMarkController();
  final GlobalKey<FormState> passKey = GlobalKey<FormState>();

  @override
  void initState() {
    passMarkController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passMarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            _passMarkController.decrement();
          },
          child: sText(
            "-",
            color: Colors.white.withOpacity(0.5),
            weight: FontWeight.w500,
            family: "Poppins",
            size: 20,
          ),
        ),
        Obx(
          () => Text(
            "${_passMarkController.passMark.value}",
            style: TextStyle(
              fontSize: widget.height * 0.025,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        // Container(
        //   height: widget.height * 0.035,
        //   width: widget.width * 0.08,
        //   child: Form(
        //     key: passKey,
        //     child: Padding(
        //       padding: EdgeInsets.only(
        //         top: widget.height * 0.040,
        //         left: widget.width * 0.015,
        //       ),
        //       child: TextFormField(
        //         controller: passMarkController,
        //         keyboardType: TextInputType.numberWithOptions(
        //           decimal: false,
        //           signed: true,
        //         ),
        //         decoration: InputDecoration(
        //           border: InputBorder.none,
        //           hintText: widget.mark.toString(),
        //           hintStyle: TextStyle(
        //             color: Colors.white,
        //             fontSize: widget.height * 0.025,
        //             fontWeight: FontWeight.w500,
        //             fontFamily: "Poppins",
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        TextButton(
          onPressed: () {
            _passMarkController.increment();

            print(_passMarkController.passMark.value);
          },
          child: sText(
            "+",
            color: Colors.white.withOpacity(0.5),
            weight: FontWeight.w500,
            family: "Poppins",
            size: 20,
          ),
        ),
      ],
    );
  }
}

class GradeAndRange extends StatefulWidget {
  const GradeAndRange({
    Key? key,
    required this.width,
    required this.numbering,
    required this.grade,
    required this.add,
    required this.subtract,
    required this.height,
  }) : super(key: key);

  final double width, height;
  final String numbering, grade, add, subtract;

  @override
  State<GradeAndRange> createState() => _GradeAndRangeState();
}

class _GradeAndRangeState extends State<GradeAndRange> {
  TextEditingController gradeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gradeController.text = widget.grade;
    super.initState();
  }

  @override
  void dispose() {
    gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = appHeight(context);
    double width = appWidth(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.width * 0.08,
              ),
              child: sText(widget.numbering),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: widget.width * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      int currentValue = gradeController.text.isEmpty
                          ? 0
                          : int.parse(gradeController.text);

                      setState(
                        () {
                          currentValue--;
                          gradeController.text =
                              (currentValue > 0 ? currentValue : 80).toString();
                        },
                      );
                    },
                    child: sText(
                      "-",
                      color: Colors.grey.withOpacity(0.8),
                      weight: FontWeight.w500,
                      family: "Poppins",
                      size: 20,
                    ),
                  ),
                  Container(
                    height: height * 0.035,
                    width: width * 0.08,
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.040,
                          left: width * 0.015,
                        ),
                        child: TextFormField(
                          controller: gradeController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: true,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.grade.toString(),
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.025,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return '*';
                          //   }
                          //   return null;
                          // },
                          // onChanged: (value) {
                          //   debugPrint(value);
                          // },
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      int currentValue = int.parse(gradeController.text);

                      setState(
                        () {
                          currentValue++;
                          gradeController.text =
                              (currentValue < 100 ? currentValue : 80)
                                  .toString();
                        },
                      );
                    },
                    child: sText(
                      "+",
                      color: Colors.grey.withOpacity(0.8),
                      weight: FontWeight.w500,
                      family: "Poppins",
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

List switchValue = [
  'Monthly',
  'Yearly',
  'Speed',
  'Mastery',
  'Improvement Rate',
  'Overall Outlook',
  'Total Score',
  'Group Total Score',
  'Pass mark',
  'Instant Results',
  'Summaries',
  'Review'
];

enum GroupValue {
  BECE,
  WASSCE,
  IGCSE,
  CUSTOM,
}

class SwitchClass extends StatefulWidget {
  const SwitchClass({
    Key? key,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final Function(bool value) onChanged;
  final bool value;

  @override
  State<SwitchClass> createState() => _SwitchClassState();
}

class _SwitchClassState extends State<SwitchClass> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      activeColor: Colors.blue,
      onChanged: (value) {
        widget.onChanged(value);
      },
    );
  }
}
