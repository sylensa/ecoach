import 'package:flutter/material.dart';

class OngoingRevision extends StatelessWidget {
  const OngoingRevision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
        title: const Text(
          'Ongoing Revision',
          style: TextStyle(
              fontFamily: 'Cocon', fontWeight: FontWeight.w700, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
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
              const Text(
                'Topic 1',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 25,
                    color: Color(0xFF6DA5D0)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Photosynthesis',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white),
              ),
              const Divider(
                color: Color(0xFF6DA5D0),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/photo.png',
                              ),
                              fit: BoxFit.fill)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Description',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF005CA5),
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: const Text(
                        'Photosynthesis is all about how plants prepare their food to foster growth',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.to(() =>  SuccessfulRevision());
                    },
                    child: const Text(
                      'Take Test',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const LinearProgressIndicator(
                minHeight: 12,
                backgroundColor: Color(0xFF005CA5),
                color: Color(0xFF00C9B9),
                value: 0.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
