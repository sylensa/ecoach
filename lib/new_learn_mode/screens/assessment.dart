import 'package:flutter/material.dart';

import '../widgets/assessment_button.dart';

class Assessment extends StatelessWidget {
  const Assessment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Assessment',
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Choose your preferred level",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.5)),
              ),
              const SizedBox(height: 40,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AssessmentButton(
                          image: 'assets/images/numbers.png',
                          onTap: () {},
                          title: 'Revision',
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: AssessmentButton(
                          image: 'assets/images/mathematics.png',
                          onTap: () {},
                          title: 'Course Completion',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AssessmentButton(
                          image: 'assets/images/math4.png',
                          onTap: () {},
                          title: 'Junior High',
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: AssessmentButton(
                          image: 'assets/images/logarithm.png',
                          onTap: () {},
                          title: 'Senior High',
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
