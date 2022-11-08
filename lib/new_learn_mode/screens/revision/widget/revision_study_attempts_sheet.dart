import 'package:ecoach/models/revision_study_progress.dart';
import 'package:flutter/material.dart';

import '../../../controllers/revision_progress_controller.dart';

class RevisionStudyAttempts extends StatefulWidget {
  final RevisionStudyProgress progress;
  final String title;
  const RevisionStudyAttempts(
      {Key? key, required this.progress, required this.title})
      : super(key: key);

  @override
  State<RevisionStudyAttempts> createState() => _RevisionStudyAttemptsState();
}

class _RevisionStudyAttemptsState extends State<RevisionStudyAttempts> {
  List<Map<String, dynamic>> attempts = [];
  bool isSorted = false;

  sortByOutcome() {
    if (!isSorted) {
      attempts.sort((a, b) => a["avgScore"].compareTo(b["avgScore"]));
      setState(() {
        isSorted = !isSorted;
      });
    } else {
      attempts.sort((a, b) => b["avgScore"].compareTo(a["avgScore"]));
      setState(() {
        isSorted = !isSorted;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      RevisionProgressController()
          .getAllRevisionAttemptsByProgress(widget.progress)
          .then((value) {
        setState(() {
          attempts = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 80,
              child: Divider(
                thickness: 3,
                color: Color(0xFF707070),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                fontFamily: "Helvetica Rounded",
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    sortByOutcome();
                  },
                  icon: Icon(
                    Icons.swap_vert,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 23,
                ),
                Text(
                  "Topic",
                  style: TextStyle(fontSize: 9),
                ),
                Spacer(),
                Text(
                  "Attempts",
                  style: TextStyle(fontSize: 9),
                ),
                SizedBox(
                  width: 23,
                ),
                Text(
                  "Outcome",
                  style: TextStyle(fontSize: 9),
                ),
              ],
            ),
            ...List.generate(attempts.length, (index) {
              return Card(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 19, horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        attempts[index]["name"],
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Text(
                      "${attempts[index]['attempts']}x",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 35,
                    ),
                    Text(
                      "${attempts[index]["avgScore"].floor()}/${10 * attempts[index]["attempts"]}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ));
            }),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
