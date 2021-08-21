import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //AuthController authController = Get.find<AuthController>();
    AuthController authController = Get.find<AuthController>();
    Future<List<Question>> getUserData() async {
      // List<Question> questions = await DBProvider.db.questions(user);
      //user.addQuestions(questions);
      // return questions;
      return null;
    }

    return Scaffold(
      appBar: BaseAppBar(context, "Home"),
      drawer: AppDrawer(),
      body: FutureBuilder(
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
                  List<Question> items = snapshot.data;

                  return ListView.builder(
                    // Let the ListView know how many items it needs to build.
                    itemCount: items.length,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        title: Text('question $index'),
                        subtitle: Text(item.question),
                      );
                    },
                  );
                } else if (snapshot.data == null)
                  return NoSubWidget();
                else
                  return Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Center(
                          child: Text(authController.user.value.email ??
                              "Something isn't right")),
                      SizedBox(height: 100),
                    ],
                  );
            }
          }),
    );
  }
}

class NoSubWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Padding(
        padding: const EdgeInsets.all(44.0),
        child: new Container(
          child: Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Padding(
                    child: new Text(
                      "Welcom to the Adeo Experience",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 24.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto"),
                    ),
                    padding: const EdgeInsets.all(0.0),
                  ),
                  new Padding(
                    child: new Text(
                      "You currently have",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 24.0, 0, 0),
                  ),
                  new Padding(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "NO",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Roboto"),
                          ),
                          SizedBox(width: 10, height: 0),
                          new Text(
                            "Subscriptions",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 20.0,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Roboto"),
                          ),
                        ]),
                    padding: const EdgeInsets.all(0.0),
                  ),
                  new Padding(
                    child: new Text(
                      "Buy a subscription and enjoy a great content",
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                    padding: const EdgeInsets.all(24.0),
                  ),
                  new Padding(
                    child: GestureDetector(
                      child: new Text(
                        "Click here",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto",
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/store');
                      },
                    ),
                    padding: const EdgeInsets.all(24.0),
                  )
                ]),
          ),
          decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(color: Colors.blueAccent)),
          padding: const EdgeInsets.fromLTRB(40, 100, 40, 100),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
