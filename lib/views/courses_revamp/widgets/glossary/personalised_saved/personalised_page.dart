import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/cards/MultiPurposeCourseCard.dart';
import 'package:flutter/material.dart';

class PersonalisedPage extends StatefulWidget {
  const PersonalisedPage({Key? key}) : super(key: key);

  @override
  State<PersonalisedPage> createState() => _PersonalisedPageState();
}

class _PersonalisedPageState extends State<PersonalisedPage> {
  List<ListNames> listLevels = [ListNames(name: "Lower Primary",id: "1"),ListNames(name: "Upper Primary",id: "2",),ListNames(name: "Junior High",id: "3"),ListNames(name: "Senior High",id: "4")];
  ListNames? level;
  onSelectModalBottomSheet(
      context,
      ) {
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Photosynthesis",
                            color: Colors.black,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                            size: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("What action will you like to perform",
                            color: kAdeoGray3,
                            weight: FontWeight.normal,
                            align: TextAlign.center,),
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/delete.png")
                              ),
                              SizedBox(height: 10,),
                              sText("Delete",color: Colors.grey[400]!)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/push-pin.png")
                              ),
                              SizedBox(height: 10,),
                              sText("Pin",color: Colors.grey[400]!)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/edit.png")
                              ),
                              SizedBox(height: 10,),
                              sText("Edit",color: Colors.grey[400]!)
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(7.0),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset("assets/images/send.png")
                              ),
                              SizedBox(height: 10,),
                              sText("Share",color: Colors.grey[400]!)
                            ],
                          ),
                        ],
                      )
                    ],
                  ));
            },
          );
        });
  }

  createDialogModalBottomSheet(
      context,
      ) {
    double sheetHeight = appHeight(context) * 0.75;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20,right:20),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("Word",color: kAdeoGray3),
                                  SizedBox(height: 10,),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please check that you\'ve entered group_management email';
                                              }
                                              return null;
                                            },
                                            decoration: textDecorNoBorder(
                                              radius: 10,
                                              hintColor: Color(0xFFB9B9B9),
                                              borderColor: Colors.white,
                                              fill: Color(0xFFEDF3F7),
                                              padding: EdgeInsets.only(left: 10, right: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20,right:20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sText("Topic",color: kAdeoGray3),
                                  SizedBox(height: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Color(0xFFEDF3F7),
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      padding: EdgeInsets.only(left: 12, right: 20),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<ListNames>(
                                          value: level ?? listLevels[0],
                                          itemHeight: 60,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: kDefaultBlack,
                                          ),
                                          onChanged: (ListNames? value){
                                            setState((){
                                              level = value;
                                            });
                                          },
                                          items: listLevels.map(
                                                (item) => DropdownMenuItem<ListNames>(
                                              value: item,
                                              child: Text(
                                                item.name,
                                                style: TextStyle(
                                                  color: kDefaultBlack,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                           Container(
                             padding: EdgeInsets.only(left: 20,right:20),

                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 sText("Meaning",color: kAdeoGray3),
                                 SizedBox(height: 10,),
                                 Container(
                                   padding: EdgeInsets.only(left: 20, right: 20),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Expanded(
                                         child: TextFormField(
                                           validator: (value) {
                                             if (value == null || value.isEmpty) {
                                               return 'Please check that you\'ve entered your group description';
                                             }
                                             return null;
                                           },
                                           maxLines: 10,
                                           decoration: textDecorNoBorder(
                                             radius: 10,
                                             hintColor: Color(0xFFB9B9B9),
                                             borderColor: Colors.white,
                                             fill: Color(0xFFEDF3F7),
                                             padding: EdgeInsets.only(left: 10, right: 10),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           )

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          width: appWidth(context),
                          color: Color(0xFF1D4859),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          child: sText("Create",
                              color: Colors.white,
                              weight: FontWeight.w500,
                              align: TextAlign.center,
                              size: 18),
                        ),
                      ),
                    ],
                  ));
            },
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton:
      GestureDetector(
        onTap: (){
          createDialogModalBottomSheet(context);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.add,color: Colors.white,),
          decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle
          ),
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
                      onSelectModalBottomSheet(context);
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


