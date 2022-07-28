import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/controllers/treadmill_controller.dart';
import 'package:ecoach/models/treadmill.dart';
import 'package:ecoach/views/treadmill/treadmill_instructions.dart';
//import 'package:ecoach/widgets/pin_input.dart';
import 'package:flutter/material.dart';
//import 'package:otp_pin_field/otp_pin_field.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import '../../models/topic.dart';
import '../../utils/constants.dart';
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
  });
  final TreadmillController controller;
  final int? topicId;
  final int? bankId;
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

  String? time;
  @override
  void initState() {
    super.initState();
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
        child: InkWell(
          onTap: () async {
            if (_fieldOne.text == "0" &&
                _fieldTwo.text == "0" &&
                _fieldThree.text == "0" &&
                _fieldFour.text == "0") {
              showFeedback(
                context,
                'Enter a valid duration',
              );
            }
            if (_fieldOne.text.isEmpty &&
                _fieldTwo.text.isEmpty &&
                _fieldThree.text.isEmpty &&
                _fieldFour.text.isEmpty) {
              showFeedback(
                context,
                'Enter a valid duration',
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InstructionPage(
                    mode: widget.mode,
                    controller: widget.controller,
                    topicId: widget.topicId,
                    bankId: widget.bankId,
                    bankName: widget.bankName,
                  ),
                ),
              );
            }
          },
          child: Container(
            child: const Center(
              child: Text(
                'let\'s go',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            height: 70,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3E50),
              border: Border.all(
                color: const Color(0xFFFFFFFF),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
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
                              widget.controller.min_1 = _fieldOne.text;
                              print("1st ${widget.controller.min_1}");
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
                              widget.controller.min_2 = _fieldTwo.text;
                              print("2nd ${widget.controller.min_2}");
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
                              widget.controller.sec_1 = _fieldThree.text;
                              print("1st ${widget.controller.sec_1}");
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
                              widget.controller.sec_2 = _fieldFour.text;
                              print("2nd ${widget.controller.sec_2}");
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
