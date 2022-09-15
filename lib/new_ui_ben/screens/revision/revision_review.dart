import 'package:flutter/material.dart';

class RevisionReview extends StatefulWidget {
  
  @override
  State<RevisionReview> createState() => _RevisionReviewState();
}

class _RevisionReviewState extends State<RevisionReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Revision',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "A quick way to prep for your exam",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.5)),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 145,
                decoration: BoxDecoration(
                    color: const Color(0xFF005CA5),
                    borderRadius: BorderRadius.circular(11)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 21,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 31,
                              ),
                              Text(
                                "Revision 1",
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Text(
                                "20 days\n1.25 x",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Color(0xFF0367B4),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '2nd',
                                    style: TextStyle(
                                        color: Color(0xFFC2C2C2),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Helvetica"),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 27,
                              ),
                              Image.asset("assets/images/rating_bar.png")
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color(0xFF0367B4),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text(
                                "300",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Helvetica",
                                  color: Color(
                                    0xFF00C9B9,
                                  ),
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "/",
                                style: TextStyle(
                                  color: Color(
                                    0xFF00C9B9,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                "500",
                                style: TextStyle(
                                  color: Color(
                                    0xFF00C9B9,
                                  ),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "79%",
                            style: TextStyle(
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              color: Color(
                                0xFF00C9B9,
                              ),
                              fontSize: 20,
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
        ),
      ),
    );
    ;
  }
}
