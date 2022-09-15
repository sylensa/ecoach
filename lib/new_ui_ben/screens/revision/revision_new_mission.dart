import 'package:flutter/material.dart';

class RevisionNewMission extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color(0xFFF6F6F6),
        height: 47,
        child: TextButton(
          onPressed: () {},
          child: const Text(
            'Next Mission',
            style: TextStyle(
              fontSize: 20,
              color: Color(
                0xFFFF7C3E,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Yeah!!",
              style: TextStyle(
                fontSize: 85,
                color: Color(
                  0xFFACACAC,
                ),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            const Center(
              child: Text(
                "mission \naccomplished",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  color: Color(0xFFACACAC),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 54,
            ),
            Image.asset(
              "assets/images/next_mission.png",
              height: 309,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
