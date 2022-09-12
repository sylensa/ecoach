import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/views/treadmill/treadmill_instructions.dart';
//import 'package:ecoach/widgets/pin_input.dart';
import 'package:flutter/material.dart';
//import 'package:otp_pin_field/otp_pin_field.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../models/topic.dart';
import '../../utils/constants.dart';
import '../../utils/style_sheet.dart';
import '../../widgets/adeo_outlined_button.dart';
import '../../widgets/otp_widget.dart';
import '../../widgets/toast.dart';

class TreadmillTime extends StatefulWidget {
  TreadmillTime({
    required this.controller,
    required this.mode,
    this.topicId,
    this.bankId,
    this.bankName,
    this.topic,
    this.count,
  });
  final TreadmillController controller;
  final int? topicId;
  final int? bankId;
  final int? count;
  final String? bankName;
  Topic? topic;
  final TreadmillMode mode;

  @override
  State<TreadmillTime> createState() => _TreadmillTimeState();
}

class _TreadmillTimeState extends State<TreadmillTime> {
  late TreadmillController controller;
  late dynamic topicId;

  final _fieldOne = TextEditingController();
  final _fieldTwo = TextEditingController();
  final _fieldThree = TextEditingController();
  final _fieldFour = TextEditingController();

  int min1 = 0;
  int min2 = 0;
  int sec1 = 0;
  int sec2 = 0;

  String? time;
  @override
  void initState() {
    super.initState();
    print('###############################################3');
    print(widget.topicId);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 16.0),
        child: AdeoOutlinedButton(
          label: 'Let\'s go',
          fontSize: 29,
          fontWeight: FontWeight.normal,
          borderColor: kAdeoLightTeal,
          color: Colors.white,
          size: Sizes.small,
          onPressed: () async {
            print(widget.topicId);
            if (_fieldOne.text == "0" &&
                _fieldTwo.text == "0" &&
                _fieldThree.text == "0" &&
                _fieldFour.text == "0") {
              showFeedback(
                context,
                'Enter a valid duration',
              );
            } else if (_fieldOne.text.isEmpty &&
                _fieldTwo.text.isEmpty &&
                _fieldThree.text.isEmpty &&
                _fieldFour.text.isEmpty) {
              showFeedback(
                context,
                'Enter a valid duration',
              );
            } else {
              Duration duration = parseDuration("$min1$min2:$sec1$sec2");
              print(duration);
              widget.controller.resetDuration = duration;
              goTo(
                  context,
                  InstructionPage(
                    mode: widget.mode,
                    controller: widget.controller,
                    topicId: widget.topicId,
                    bankId: widget.bankId,
                    bankName: widget.bankName,
                    count: widget.count,
                  ),
                  replace: false);
            }
          },
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/deep_pool_light_teal.png',
            color: const Color(0xFF00C9B9),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 80, 0, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Time',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 45.0),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Allocation per question',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50.0,
                      // height: 100.0,
                      child: TextField(
                        cursorHeight: 50.0,
                        autofocus: true,
                        style: const TextStyle(
                          height: 1,
                          fontSize: 75.0,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _fieldOne,
                        maxLength: 1,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: '0',
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                              //height: 85,
                              color: Colors.white,
                              fontSize: 75.0,
                              decoration: TextDecoration.underline),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            setState(() {
                              min1 = int.parse(_fieldOne.text);
                            });
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 50.0,
                      // height: 100.0,
                      child: TextField(
                        cursorHeight: 50.0,
                        autofocus: true,
                        style: const TextStyle(
                            height: 1,
                            fontSize: 75.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _fieldTwo,
                        maxLength: 1,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: '0',
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                              //height: 85,
                              color: Colors.white,
                              fontSize: 75.0,
                              decoration: TextDecoration.underline),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            setState(() {
                              min2 = int.parse(_fieldTwo.text);
                            });
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 30),
                      child: Text(
                        ':',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 75.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 50.0,
                      //height: 100.0,
                      child: TextField(
                        cursorHeight: 50.0,
                        autofocus: true,
                        style: const TextStyle(
                          height: 1,
                          fontSize: 75.0,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _fieldThree,
                        maxLength: 1,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: '0',
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                              //height: 85,
                              color: Colors.white,
                              fontSize: 75.0,
                              decoration: TextDecoration.underline),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            setState(() {
                              sec1 = int.parse(_fieldThree.text);
                            });
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 50.0,
                      //height: 100.0,
                      child: TextField(
                        cursorHeight: 50.0,
                        autofocus: true,
                        style: const TextStyle(
                            height: 1,
                            fontSize: 75.0,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _fieldFour,
                        maxLength: 1,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: '0',
                          border: InputBorder.none,
                          counterText: '',
                          hintStyle: TextStyle(
                              //height: 85,
                              color: Colors.white,
                              fontSize: 75.0,
                              decoration: TextDecoration.underline),
                        ),
                        onChanged: (value) {
                          if (value.length == 1) {
                            setState(() {
                              sec2 = int.parse(_fieldFour.text);
                            });
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'minutes',
                      //textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'seconds',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int seconds;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  seconds = int.parse(parts[parts.length - 1]);
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}
