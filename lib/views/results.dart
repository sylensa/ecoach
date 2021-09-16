import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

class DiagnoticResultView extends StatefulWidget {
  const DiagnoticResultView(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _DiagnoticResultViewState createState() => _DiagnoticResultViewState();
}

class _DiagnoticResultViewState extends State<DiagnoticResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF28BFDF),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              child: Row(
                children: [Text("Top")],
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xFF636363),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 22.0, 0, 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 140,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Text(
                                "Topic",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 120,
                              child:
                                  Text("Time", style: TextStyle(fontSize: 15))),
                          Expanded(
                              child: Text("Performance",
                                  style: TextStyle(fontSize: 15))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Buy Subscription",
                          style: TextStyle(color: Colors.white, fontSize: 25)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
