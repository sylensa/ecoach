import 'package:ecoach/controllers/test_controller.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/revamp/features/accessment/views/screens/start_accessment_page.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/text_styles.dart';

List<String> subjects = [
  "Mathematics",
  "English",
  "Science",
  "ICT",
  "French",
];

class SelectSubjectWidget extends StatefulWidget {
  final String title;
  final User? user;
  const SelectSubjectWidget(
      {
        required this.title,
        this.user,
        Key? key})
      : super(key: key);

  @override
  State<SelectSubjectWidget> createState() => _SelectSubjectWidgetState();
}

class _SelectSubjectWidgetState extends State<SelectSubjectWidget> {
  var futureLevels;
  var futureCourses;
  Level? selectedLevel;
  Course? selectedCourse;
  List<Course> responseCourses = [];
 List<String> lowerPrimary = ["01LP","02LP","03LP"];
 List<String> upperPrimary = ["04UP","05UP","06UP"];
 List<String> juniorHigh = ["01JS","02JS","03JS"];
 List<String> seniorHigh = ["01SS","02SS","03SS"];

  @override
  void initState() {
  print("widget.title:${widget.title}");
    getCourses();

    super.initState();
  }


  getCourses() async {
    if(widget.title.toUpperCase() == "LOWER PRIMARY"){
      responseCourses  = await CourseDB().coursesByCourseID(lowerPrimary);

    }else if(widget.title.toUpperCase() == "UPPER PRIMARY"){
      responseCourses = await CourseDB().coursesByCourseID(upperPrimary);

    }else if(widget.title.toUpperCase() == "JUNIOR HIGH"){
      responseCourses = await CourseDB().coursesByCourseID(juniorHigh);

    }else if(widget.title.toUpperCase() == "SENIOR HIGH"){
      responseCourses = await CourseDB().coursesByCourseID(seniorHigh);

    }
   setState((){
     print("object:${responseCourses.length}");
   });
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      height: 600,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SizedBox(
              width: 20.w,
              child: const Divider(
                thickness: 3,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           Text(
            "${widget.title}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 29,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            "Select Your Course",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: responseCourses.length,
                itemBuilder: (BuildContext context, int index){
                  return InkWell(
                  onTap: () async{
                    final bool isConnected = await InternetConnectionChecker().hasConnection;
                    if(isConnected){
                      showLoaderDialog(context);
                      Future futureList = TestController().loadDiagnoticQuestionAnnex(responseCourses[index]);
                      futureList.then((apiResponse) {
                        Navigator.pop(context);
                        apiResponse.data.length > 0 ?
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return StartAccessmentPage(
                                widget.user!,
                                apiResponse.data,
                                name: "Test Diagnostic",
                                course: responseCourses[index],
                                time: 60 * 20,
                                diagnostic: true,
                              );
                            })
                        )  :
                        showDialogOk(message: "No questions",context: context,dismiss: false);
                      });
                    }else{
                      showDialogOk(message: "No internet connection",context: context,dismiss: false);
                    }
                  },
                  child: Container(
                    height: 58,
                    width: 354,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        responseCourses[index].name!,
                        textAlign: TextAlign.center,
                        style: TextStyles.headline(context).copyWith(
                          color: const Color(0xFF8D8D8D),
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
            }),
          )

        ],
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.h),
          topRight: Radius.circular(4.h),
        ),
      ),
    );
  }
}
