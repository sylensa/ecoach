import 'dart:developer';

import 'package:ecoach/models/question.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/welcome_adeo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  final User user;
  Function? callback;
  HomePage(this.user, {this.callback});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //AuthController authController = Get.find<AuthController>();

    Future<List<Question>?> getUserData() async {
      // List<Question> questions = await DBProvider.db.questions(user);
      //user.addQuestions(questions);
      // return questions;
      return null;
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: new Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30, 24, 34),
            child: Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: TextStyle(
                                  color: Colors.black26, fontSize: 12),
                            ),
                            Text(
                              widget.user.name,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Spacer(),
                        Stack(
                          children: [Icon(Icons.notifications)],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: FutureBuilder(
                          future: getUserData(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              default:
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                else if (snapshot.data != null) {
                                  List<Question>? items =
                                      snapshot.data as List<Question>?;

                                  return ListView.builder(
                                    // Let the ListView know how many items it needs to build.
                                    itemCount: items!.length,
                                    // Provide a builder function. This is where the magic happens.
                                    // Convert each item into a widget based on the type of item it is.
                                    itemBuilder: (context, index) {
                                      final item = items[index];

                                      return ListTile(
                                        title: Text('question $index'),
                                        subtitle: Text("question name"),
                                      );
                                    },
                                  );
                                } else if (snapshot.data == null)
                                  return NoSubWidget(
                                      widget.user, widget.callback);
                                else
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      Center(
                                          child: Text(widget.user.email ??
                                              "Something isn't right")),
                                      SizedBox(height: 100),
                                    ],
                                  );
                            }
                          }),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

enum Selection { SUBSCRIPTION, DIAGNOSTIC, NONE }

class NoSubWidget extends StatefulWidget {
  NoSubWidget(this.user, this.callback);
  final Function? callback;
  User user;

  @override
  State<NoSubWidget> createState() => _NoSubWidgetState();
}

class _NoSubWidgetState extends State<NoSubWidget> {
  Selection selection = Selection.NONE;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "You have ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                )),
            TextSpan(
                text: "No",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: " Subscriptions",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black26,
                )),
          ])),
          SizedBox(
            width: 152,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 28.0, 0, 30),
              child: Text(
                'Perform an Activity.\nBring your feed to life',
                style: TextStyle(color: Color(0xFFD3D3D3)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 176,
            width: 267,
            child: Column(
              children: [
                Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(267, 88)),
                            backgroundColor: MaterialStateProperty.all(
                                selection == Selection.SUBSCRIPTION
                                    ? Color(0xFF00C664)
                                    : Color(0xFFFAFAFA)),
                            foregroundColor: MaterialStateProperty.all(
                                selection == Selection.SUBSCRIPTION
                                    ? Colors.white
                                    : Color(0xFFBAC4D9))),
                        onPressed: () {
                          setState(() {
                            selection = Selection.SUBSCRIPTION;
                          });
                        },
                        child: Text('Subscription'))),
                Expanded(
                    child: TextButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(267, 88)),
                            backgroundColor: MaterialStateProperty.all(
                                selection == Selection.DIAGNOSTIC
                                    ? Color(0xFF00ABE0)
                                    : Color(0xFFFAFAFA)),
                            foregroundColor: MaterialStateProperty.all(
                                selection == Selection.DIAGNOSTIC
                                    ? Colors.white
                                    : Color(0xFFBAC4D9))),
                        onPressed: () {
                          setState(() {
                            selection = Selection.DIAGNOSTIC;
                          });
                        },
                        child: Text('Diagnostic'))),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          if (selection == Selection.SUBSCRIPTION)
            SizedBox(
                width: 150,
                height: 44,
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF00C664)),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF00C664),
                          width: 1,
                          style: BorderStyle.solid)),
                    ),
                    onPressed: () {
                      widget.callback!();
                    },
                    child: Text('Buy'))),
          if (selection == Selection.DIAGNOSTIC)
            SizedBox(
                width: 150,
                height: 44,
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Color(0xFF00ABE0)),
                      side: MaterialStateProperty.all(BorderSide(
                          color: Color(0xFF00ABE0),
                          width: 1,
                          style: BorderStyle.solid)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SelectLevel(widget.user);
                      }));
                    },
                    child: Text('Take'))),
        ],
      ),
    );
  }
}
