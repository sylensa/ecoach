import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../helper/helper.dart';
import '../../controllers/treadmill_controller.dart';
import '../../models/question.dart';
import '../../revamp/core/utils/app_colors.dart';
import '../../utils/style_sheet.dart';

class Completed extends StatefulWidget {
  Completed({
    required this.controller,
    // required this.questions,
  });

  final TreadmillController controller;
  //final List<Question> questions;

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  int? score;
  int? countdown;
  String? min;
  String? sec;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  String date = DateFormat("dd.MM.yy").format(DateTime.now());
  dynamic currentTime = DateFormat.jm().format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
                margin: EdgeInsets.all(8),
                width: 90,
                //height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3E50),
                  border: Border.all(
                    color: const Color(0xFFFF4949),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: Color(0xFFFF4949),
                    ),
                  ),
                )),
          ),
        ],
        elevation: 0,
        backgroundColor: const Color(0xFF2D3E50),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 2.h,
            ),
            const Center(
              child: Text(
                'Completed Runs',
                style: TextStyle(
                  color: kAdeoLightTeal,
                  fontSize: 28,
                  fontFamily: 'Hamelin',
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        currentTime,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${widget.controller.minutes} min : $widget.controller.seconds sec',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: kAccessmentButtonColor,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${widget.controller.name}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'Topic',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.controller.correctAnswer}/',
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.controller.questions.length.toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
