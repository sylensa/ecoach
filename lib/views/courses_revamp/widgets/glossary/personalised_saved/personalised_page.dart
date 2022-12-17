import 'package:ecoach/controllers/glossary_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/course.dart';
import 'package:ecoach/models/glossary_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class PersonalisedPage extends StatefulWidget {
  PersonalisedPage(
      {Key? key,
        required this.course,
        required this.user,
      })
      : super(key: key);
  Course course;
  User user;
  @override
  State<PersonalisedPage> createState() => _PersonalisedPageState();
}

class _PersonalisedPageState extends State<PersonalisedPage> {
  List<GlossaryData> glossaryData = [];
  bool progressCode = true;
  getPersonalisedData()async{
    try{
      glossaryData = await GlossaryController().getPersonalisedGlossariesList();
    }
    catch(e){

    }
    setState(() {
      progressCode = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPersonalisedData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.add,color: Colors.white,),
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/Polygon.png"),
                  Row(
                    children: [
                      Image.asset("assets/images/dictionary.png"),
                      SizedBox(width: 10,),
                      sText("${glossaryData.length}")
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            glossaryData.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: glossaryData.length,
                  itemBuilder: (BuildContext context, int index){
                    return   MultiPurposeCourseCard(
                      title: '${glossaryData[index].term}',
                      subTitle: 'Create and view definitions',
                      onTap: () async {

                      },
                    );

                  }),
            ) :
            progressCode ?
            Expanded(child: Center(child: progress(),)) :
            Expanded(child: Center(child: sText("Empty data"),))
          ],
        ),
      ),
    );
  }
}
