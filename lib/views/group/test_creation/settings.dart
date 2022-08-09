import 'package:ecoach/helper/helper.dart';
import 'package:country_icons/country_icons.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, bool> selectedSwitch = {
    'monthly': false,
    'yearly': false,
  };

  var selectedRadio;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xFF757575),
      backgroundColor: Colors.white.withOpacity(0.8),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSizedBox(height * 0.04, width * 0),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  buildSizedBox(width * 0.04, width * 0),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.08),
                    child: sText(
                      "Group Settings",
                      color: Color(0xFF000000),
                      size: width * 0.05,
                    ),
                  ),
                ],
              ),
              buildSizedBox(height * 0.04, width * 0),
              sText(
                "Access".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.02, width * 0),
              Container(
                height: height * 0.18,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
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
                        sText("Paid", color: Color(0xFF5a6775)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    buildSizedBox(height * 0.01, width * 0),
                    Divider(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    buildSizedBox(height * 0.02, width * 0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'icons/flags/png/gh.png',
                          package: 'country_icons',
                          width: width * 0.08,
                        ),
                        VerticalDivider(
                          width: width * 0.02,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.005),
                          child: sText(
                            "GHS 900",
                            color: Colors.black,
                            size: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              buildSizedBox(height * 0.06, width * 0),
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
              buildSizedBox(height * 0.06, width * 0),
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
              buildSizedBox(height * 0.06, width * 0),
              sText(
                "Grading System".toUpperCase(),
                color: Color(0xFF0E0E0E),
                size: 14,
                family: "Poppins",
                weight: FontWeight.w500,
              ),
              buildSizedBox(height * 0.02, width * 0),
              Container(
                height: height * 0.55,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: height * 0.01,
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
              // Container(
              //   height: height * 0.5,
              //   padding: EdgeInsets.symmetric(
              //     horizontal: width * 0.03,
              //     vertical: height * 0.01,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Color(0xFFFfFFFF),
              //     borderRadius: BorderRadius.circular(width * 0.025),
              //   ),
              //   child: sText(
              //     "Grading System".toUpperCase(),
              //     color: Color(0xFF0E0E0E),
              //     size: 14,
              //     family: "Poppins",
              //     weight: FontWeight.w500,
              //   ),
              // ),
              buildSizedBox(height * 0.02, width * 0),
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
}

class buildRadioButton extends StatelessWidget {
  final GlobalKey<ExpansionTileCardState> expansionKey = new GlobalKey();
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
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      key: expansionKey,
      elevation: 0.0,
      // title: text == selectedRadio
      //     ? sText(text, color: Color(0xFF0E0E0E), size: 14)
      //     : sText(text, color: Color(0xFF5a6775), size: 14),
      leading: Radio(
        value: groupValue,
        groupValue: selectedRadio,
        onChanged: (value) {
          onChanged(value);
        },
      ),
      title: Text(text),
      // children: [
      //   ListTile(
      //     trailing: Padding(
      //       padding: EdgeInsets.only(left: width * 0.05),
      //       child: Radio(
      //         value: groupValue,
      //         groupValue: selectedRadio,
      //         onChanged: (value) {
      //           onChanged(value);
      //         },
      //       ),
      //     ),
      //     title: Padding(
      //       padding: EdgeInsets.only(left: width * 0.03),
      //       child: sText(
      //         text,
      //         size: 14,
      //         weight: FontWeight.w500,
      //       ),
      //     ),
      //     leading: Icon(
      //       Icons.play_arrow_sharp,
      //       size: height * 0.05,
      //       color: Color(0xFF0E0E0E).withOpacity(0.5),
      //     ),
      //   ),
      //   // Column(
      //   //   children: [
      //   //     Padding(
      //   //       padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      //   //       child: Row(
      //   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   //         children: [
      //   //           sText("Grade"),
      //   //           sText("Range"),
      //   //         ],
      //   //       ),
      //   //     ),
      //   //     SizedBox(
      //   //       height: height * 0.0,
      //   //     ),
      //   //     Container(
      //   //       height: height * 0.2,
      //   //       width: width * 0.9,
      //   //       margin: EdgeInsets.symmetric(
      //   //         horizontal: width * 0.040,
      //   //         vertical: height * 0.015,
      //   //       ),
      //   //       decoration: BoxDecoration(
      //   //         color: Color(0xFFF0E0E0E),
      //   //         borderRadius: BorderRadius.circular(width * 0.025),
      //   //       ),
      //   //       child: ListView.builder(
      //   //         shrinkWrap: true,
      //   //         itemCount: 1,
      //   //         itemBuilder: (context, index) {
      //   //           return Container(
      //   //             width: width * 0.4,
      //   //             child: Column(
      //   //               children: [
      //   //                 Row(
      //   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   //                   children: [
      //   //                     sText(" ${index + 1}"),
      //   //                     Padding(
      //   //                       padding: EdgeInsets.only(
      //   //                         left: width * 0.1,
      //   //                       ),
      //   //                       child: Row(
      //   //                         mainAxisAlignment:
      //   //                             MainAxisAlignment.spaceBetween,
      //   //                         children: [
      //   //                           TextButton(
      //   //                             onPressed: () {},
      //   //                             child: sText(" - "),
      //   //                           ),
      //   //                           sText(
      //   //                             "80",
      //   //                           ),
      //   //                           TextButton(
      //   //                             onPressed: () {},
      //   //                             child: sText(" + "),
      //   //                           ),
      //   //                         ],
      //   //                       ),
      //   //                     )
      //   //                   ],
      //   //                 ),
      //   //               ],
      //   //             ),
      //   //           );
      //   //         },
      //   //       ),
      //   //     ),
      //   //   ],
      //   // ),
      // ],
    );
    // return ListTile(
    //   leading: Radio(
    //     value: groupValue,
    //     groupValue: selectedRadio,
    //     onChanged: (value) {
    //       onChanged(value);
    //     },
    //   ),
    //   title: sText(
    //     text,
    //     size: 14,
    //     weight: FontWeight.w500,
    //   ),
    //   trailing: Icon(
    //     Icons.chevron_right,
    //     size: height * 0.05,
    //     color: Color(0xFF0E0E0E).withOpacity(0.5),
    //   ),
    // );
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
