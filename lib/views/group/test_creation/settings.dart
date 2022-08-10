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
              buildSizedBox(height * 0.005, width * 0),
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
}

class buildRadioButton extends StatelessWidget {
  final GlobalKey<ExpansionTileCardState> expansionKey = GlobalKey();
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
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: ExpansionTileCard(
        expandedTextColor: Color(0xFF0E0E0E),
        key: expansionKey,
        elevation: 0.0,
        leading: Radio(
          activeColor: Color(
            0xFF00C9B9,
          ),
          value: groupValue,
          groupValue: selectedRadio,
          onChanged: (value) {
            onChanged(value);
          },
        ),
        title: Text(text),
        children: [
          ListTile(
            trailing: Padding(
              padding: EdgeInsets.only(left: width * 0.05),
              child: Radio(
                activeColor: Color(
                  0xFF00C9B9,
                ),
                value: groupValue,
                groupValue: selectedRadio,
                onChanged: (value) {
                  onChanged(value);
                },
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: width * 0.03),
              child: sText(
                text,
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
            leading: Icon(
              Icons.play_arrow_sharp,
              size: height * 0.05,
              color: Color(0xFF0E0E0E).withOpacity(0.5),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
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
              SizedBox(
                height: height * 0.0,
              ),
              Container(
                height: height * 0.7,
                width: width * 0.9,
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.040,
                  vertical: height * 0.015,
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
                      top: height * 0.6,
                      child: Container(
                        height: height * 0.1,
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
                              Row(
                                children: [
                                  subtractButton(),
                                  SizedBox(
                                    width: width * 0.0,
                                  ),
                                  sText(
                                    "80",
                                    color: Colors.white,
                                    weight: FontWeight.w500,
                                    family: "Poppins",
                                  ),
                                  SizedBox(
                                    width: width * 0.0,
                                  ),
                                  addButton(),
                                ],
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

  Widget addButton() {
    return TextButton(
      onPressed: () {},
      child: sText(
        "+",
        color: Colors.white.withOpacity(0.5),
        weight: FontWeight.w500,
        family: "Poppins",
        size: 20,
      ),
    );
  }

  Widget subtractButton() {
    return TextButton(
      onPressed: () {},
      child: sText(
        "-",
        color: Colors.white.withOpacity(0.5),
        weight: FontWeight.w500,
        family: "Poppins",
        size: 20,
      ),
    );
  }
}

class GradeAndRange extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
              ),
              child: sText(numbering),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: width * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: sText(
                      "-",
                      color: Colors.grey.withOpacity(0.8),
                      weight: FontWeight.w500,
                      family: "Poppins",
                      size: 20,
                    ),
                  ),
                  sText(
                    "80",
                    color: Colors.black87,
                    weight: FontWeight.w500,
                    family: "Poppins",
                  ),
                  TextButton(
                    onPressed: () {},
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
