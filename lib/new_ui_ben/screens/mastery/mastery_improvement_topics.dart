import 'package:flutter/material.dart';

import '../../widgets/green_pill_button.dart';
import '../../widgets/highlighted_topic.dart';
import '../../widgets/highlighted_topics_container.dart';
import '../../widgets/unhighlighted_topic.dart';
import '../../widgets/unhighlighted_topics_container.dart';

class MasteryImprovementTopics extends StatelessWidget {
  const MasteryImprovementTopics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Mastery Improvement',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Spot weaknesses and improve upon them",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.5)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                                'assets/images/up-and-down-arrow.png')),
                        const Text(
                          'Topic',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const Expanded(
                            child: SizedBox(
                          width: 10,
                        )),
                        const Text(
                          'Strength',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    HighlightedTopicsContainer(
                      topics: [
                        HighlightedTopic(
                          barsWidget: Image.asset('assets/images/bars1.png'),
                          number: '01',
                          topic: 'Photosynthesis',
                        ),
                        HighlightedTopic(
                          barsWidget: Image.asset('assets/images/bars1.png'),
                          number: '02',
                          topic: 'Matter',
                        ),
                        HighlightedTopic(
                          barsWidget: Image.asset('assets/images/bars1.png'),
                          number: '03',
                          topic: 'Light',
                        ),
                      ],
                    ),
                    UnhighlightedTopicsContainer(
                      topics: [
                        UnhighlightedTopic(
                          barsWidget: Image.asset('assets/images/bars2.png'),
                          number: '04',
                          topic: 'Flowering Plants',
                        ),
                        UnhighlightedTopic(
                          barsWidget: Image.asset('assets/images/bars4.png'),
                          number: '05',
                          topic: 'Osmosis & Diffusion',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                      text: const TextSpan(
                          text: 'You have to improve your mastery in ',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Poppins'),
                          children: [
                            TextSpan(
                                text: '6 Topics',
                                style: TextStyle(fontWeight: FontWeight.w700))
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80,),
              GreenPillButton(
                onTap: () {},
                text: 'Start Mastery Run'
              )
            ],
          ),
        ),
      ),
    );
  }
}
