import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
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
                      sText("200")
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                    return   MultiPurposeCourseCard(
                      title: 'Photosynthesis',
                      subTitle: 'Create and view definitions',
                      onTap: () async {

                      },
                    );

                  }),
            )
          ],
        ),
      ),
    );
  }
}
