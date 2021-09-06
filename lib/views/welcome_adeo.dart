import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/main_home.dart';
import 'package:flutter/material.dart';

class WelcomeAdeo extends StatefulWidget {
  const WelcomeAdeo(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _WelcomeAdeoState createState() => _WelcomeAdeoState();
}

class _WelcomeAdeoState extends State<WelcomeAdeo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Color(0xFF00C664)),
          child: Stack(
            children: [
              Positioned(
                  top: -100,
                  right: -80,
                  child: Image(
                    image: AssetImage('assets/images/white_leave.png'),
                  )),
              Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return MainHomePage(widget.user);
                      }), (route) => false);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(color: Color(0xFF00C664), fontSize: 24),
                    ),
                  )),
              Positioned(
                top: 180,
                right: 40,
                left: 40,
                bottom: 100,
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        'Welcome to the\nAdeo Experience',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "You currently have\n",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                        TextSpan(
                            text: "NO",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24)),
                        TextSpan(
                            text: " Subscriptions.",
                            style: TextStyle(color: Colors.white, fontSize: 24))
                      ])),
                      SizedBox(
                        height: 40,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "First take a",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                            TextSpan(
                                text: " DIAGNOSTIC TEST\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 24)),
                            TextSpan(
                                text: "  to determine the right course\n",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                            TextSpan(
                                text: "  for you. ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24))
                          ])),
                      SizedBox(
                        height: 60,
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(60, 10, 60, 10)),
                          side: MaterialStateProperty.all(BorderSide(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
