import 'package:ecoach/helper/helper.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> accessKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController _accessController = TextEditingController();

  static List<String> rangeList = [];

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
                buildSizedBox(10.0, 0.0),
                sText(
                  "Access".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                buildSizedBox(10.0, 0.0),
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
                buildSizedBox(20.0, 0.0),
                sText(
                  "Subscription".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                buildSizedBox(10.0, 0.0),
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
                                  selectedSwitch
                                      .addAll({switchValue[0]: value});
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
                      buildSizedBox(10.0, 0.0),
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
                                  selectedSwitch
                                      .addAll({switchValue[1]: value});
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
                buildSizedBox(20.0, 0.0),
                sText(
                  "Features".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                buildSizedBox(10.0, 0.0),
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
                      buildSizedBox(10.0, 0.0),
                      buildFeatureSwitchItems(height, 2),
                      buildFeatureSwitchItems(height, 3),
                      buildFeatureSwitchItems(height, 4),
                      buildFeatureSwitchItems(height, 5),
                      buildFeatureSwitchItems(height, 6),
                      buildFeatureSwitchItems(height, 7),
                      buildFeatureSwitchItems(height, 8),
                      buildFeatureSwitchItems(height, 9),
                      buildFeatureSwitchItems(height, 10),
                      buildFeatureSwitchItems(height, 11),
                    ],
                  ),
                ),
                buildSizedBox(20.0, 0.0),
                sText(
                  "Grading System".toUpperCase(),
                  color: Color(0xFF0E0E0E),
                  size: 14,
                  family: "Poppins",
                  weight: FontWeight.w500,
                ),
                buildSizedBox(10.0, 0.0),
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
                      buildSizedBox(20.0, 0.0),
                      sText("Choose Your Preferred Grading System"),
                      buildSizedBox(10.0, 0.0),
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
      ),
    );
  }

  Row buildFeatureSwitchItems(double height, int index) {
    debugPrint(selectedSwitch.toString());
    debugPrint(selectedSwitch[index].toString());
    debugPrint(switchValue[index].toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.025),
          child: sText(switchValue[index], color: Color(0xFF5a6775)),
        ),
        Switch(
          value: selectedSwitch.keys.contains(switchValue[index]),
          onChanged: (value) {
            setState(() {
              if (value) {
                selectedSwitch.addAll({switchValue[index]: value});
              } else {
                selectedSwitch.remove(switchValue[index]);
              }
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blue,
        )
      ],
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
                height: widget.height * 0.58,
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
                      top: widget.height * 0.45,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // ...buildOtherInputFields(),

                              // use this button to add more input fields here
                              sText("add"),
                              sText("minus"),
                            ],
                          ),
                          Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        ],
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

// use this button to add more input fields here

// Work on add/subtract Form Field
List<Widget> buildOtherInputFields() {
  List<Widget> otherTextFields = [];
  for (int i = 0; i < _SettingsState.rangeList.length; i++) {
    otherTextFields.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Expanded(child: FriendTextFields(i)),
          SizedBox(
            width: 16,
          ),
          _addRemoveButton(i == _SettingsState.rangeList.length - 1, i),
        ],
      ),
    ));
  }
  return otherTextFields;
}

Widget _addRemoveButton(bool add, int index) {
  return InkWell(
    onTap: () {
      if (add) {
        // add new text-fields at the top of all friends textfields
        _SettingsState.rangeList.insert(0, "");
      } else
        _SettingsState.rangeList.removeAt(index);
    },
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: (add) ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        (add) ? Icons.add : Icons.remove,
        color: Colors.white,
      ),
    ),
  );
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController =
      TextEditingController(); // check this out again

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _SettingsState.rangeList[widget.index];
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) {
        _SettingsState.rangeList[widget.index] = v;
      },
      decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
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
