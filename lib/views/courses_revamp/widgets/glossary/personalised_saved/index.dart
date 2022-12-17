import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/personalised_saved/personalised_page.dart';
import 'package:ecoach/views/courses_revamp/widgets/glossary/personalised_saved/saved_page.dart';
import 'package:flutter/material.dart';


class PersonalisedSavedPage extends StatefulWidget {
  PersonalisedSavedPage(
      {Key? key,
        required this.currentIndex,
        required this.course,
        required this.user,
      })
      : super(key: key);
  Course course;
  int currentIndex;
  User user;

  @override
  _PersonalisedSavedPageState createState() => _PersonalisedSavedPageState();
}

class _PersonalisedSavedPageState extends State<PersonalisedSavedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.currentIndex);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.currentIndex,
        length: 2,
        child: Scaffold(

          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: TabBar(
              padding: EdgeInsets.zero,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 5,
              indicatorPadding: EdgeInsets.all(0.0),
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: "Personalised",
                ),
                Tab(
                  text: "Saved",
                ),
              ],
            ),
          ),
          body:  TabBarView(
            children: [
                PersonalisedPage(user: widget.user,course: widget.course,),
              SavedPage(user: widget.user,course: widget.course,)
            ],
          ),
        )
    );
  }
}
