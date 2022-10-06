import 'package:ecoach/database/study_db.dart';
import 'package:ecoach/models/revision_study_progress.dart';
import 'package:ecoach/new_ui_ben/providers/welcome_screen_provider.dart';
import 'package:ecoach/new_ui_ben/utils/helper_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/revision_progress_attempts.dart';
import 'widget/revision_study_attempts_sheet.dart';

class RevisionReview extends StatefulWidget {
  @override
  State<RevisionReview> createState() => _RevisionReviewState();
}

class _RevisionReviewState extends State<RevisionReview> {
  getProgressTotal(RevisionStudyProgress progress) {
    double total = 0;

    StudyDB().getRevisionAttemptSumByProgress(progress).then((value) {
      total = value;
    });

    return total;
  }

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
      body: FutureBuilder<List<RevisionStudyProgress?>>(
        future: StudyDB().getRevisionProgressByCourse(
            Provider.of<WelcomeScreenProvider>(context, listen: false)
                .currentCourse!),
        builder: (context, snapshot) {
          print("snapshot data: ${snapshot.data}");
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return snapshot.data!.isEmpty
              ? Center(
                  child: Text(
                    "No Revision Recorded",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "A quick way to prep for your exam",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(255, 255, 255, 0.5)),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // Container(
                        //   height: 200,
                        //   padding: EdgeInsets.all(10),
                        //   decoration: BoxDecoration(
                        //       color: Color(0xFF005CA5),
                        //       borderRadius: BorderRadius.circular(20)),
                        //   child: LineChart(
                        //     LineChartData(
                        //       minY: 0,
                        //       minX: 0,
                        //       maxX: snapshot.data!.length.toDouble(),
                        //       maxY: 10,
                        //       titlesData: FlTitlesData(show: false),
                        //       gridData: FlGridData(show: false),
                        //       axisTitleData: FlAxisTitleData(show: false),
                        //       borderData: FlBorderData(
                        //           show: false,
                        //           border: Border.all(
                        //               color: Colors.transparent, width: 0)),
                        //       lineBarsData: [
                        //         LineChartBarData(
                        //           spots: [
                        //             ...List.generate(snapshot.data!.length,
                        //                 (index) {
                        //               RevisionStudyProgress? progress =
                        //                   snapshot.data![index];
                        //
                        //               final totalScore = StudyDB()
                        //                   .getRevisionAttemptSumByProgress(
                        //                       progress!);
                        //
                        //               return FlSpot(index.toDouble(),
                        //                   progress.level!.toDouble());
                        //             }).reversed.toList()
                        //           ],
                        //           belowBarData: BarAreaData(
                        //               show: true,
                        //               colors: [Colors.teal, Colors.green]
                        //                   .map((e) => e.withOpacity(0.3))
                        //                   .toList()),
                        //           dotData: FlDotData(show: false),
                        //           isCurved: true,
                        //           colors: [Colors.teal, Colors.green],
                        //           barWidth: 2,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        ...List.generate(snapshot.data!.length, (index) {
                          RevisionStudyProgress? progress =
                              snapshot.data![index];
                          int totalScore = 0;

                          return SingleRevisionWidget(
                            progress: progress,
                            totalScore: totalScore,
                            index: snapshot.data!.length - index,
                          );
                        })
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class SingleRevisionWidget extends StatefulWidget {
  const SingleRevisionWidget({
    Key? key,
    required this.progress,
    required this.totalScore,
    required this.index,
  }) : super(key: key);

  final RevisionStudyProgress? progress;
  final int totalScore, index;

  @override
  State<SingleRevisionWidget> createState() => _SingleRevisionWidgetState();
}

class _SingleRevisionWidgetState extends State<SingleRevisionWidget> {
  int totalScore = 0;
  int totalAttempts = 0;
  List<RevisionProgressAttempt> attempts = [];

  setTotalRevisionScore() async {
    totalScore =
        await StudyDB().getRevisionAttemptSumByProgress(widget.progress!);
    setState(() {});
    print(totalScore);
  }

  getAttemptsByRevision() async {
    attempts =
        await StudyDB().getRevisionAttemptByTopicAndProgress(widget.progress!);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setTotalRevisionScore();
    getAttemptsByRevision();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          RevisionStudyAttempts(
              progress: widget.progress!, title: "Revision ${widget.index}"),
          isScrollControlled: true,
        );
      },
      child: Container(
        height: 145,
        margin: EdgeInsets.only(bottom: 5),
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
                        "Revision ${widget.index}",
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                      Text(
                        "${widget.progress!.updatedAt!.difference(
                              widget.progress!.createdAt!,
                            ).inMinutes} mins \n${attempts.length} x",
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
                      Image.asset(getBarPercentage(
                          (totalScore / (attempts.length * 10)) * 100))
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${totalScore}",
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
                        "${(attempts.length) * 10}",
                        style: TextStyle(
                          color: Color(
                            0xFF00C9B9,
                          ),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${(attempts.length == 0 ? 0 : (totalScore / (attempts.length * 10)) * 100).toStringAsFixed(1)}%",
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
    );
  }
}
