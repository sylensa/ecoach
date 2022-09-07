import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:flutter/material.dart';

class MyGroupsPage extends StatefulWidget {
  static const String routeName = '/user_group';
  MyGroupsPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,

      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        elevation: 0,
        title: sText("My Groups",weight: FontWeight.bold),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: appWidth(context) * 0.9,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.arrow_back_ios,color: Colors.white,),
                                      Container(
                                        width: 150,
                                        child: sText("Physics Assignment due",weight: FontWeight.w500,size: 14,maxLines: 1),
                                      ),
                                      Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          sText("Adeo Group",weight: FontWeight.w500,size: 20),
                                          SizedBox(height: 0,),
                                          sText("by Mr. Afram Dzidefo",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Color(0XFF00C9B9),
                                                        shape: BoxShape.circle
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "1",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10,),
                                          Container(
                                            child: Row(
                                              children: [
                                                Image.asset("assets/images/user_group.png"),
                                                SizedBox(width: 5,),
                                                sText("100 members",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            child: Row(
                                              children: [
                                                Image.asset("assets/images/calendar.png"),
                                                SizedBox(width: 5,),
                                                sText("20 days remaining",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(Icons.arrow_forward),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                        ],
                      ),
                      SizedBox(height: 10,)
                    ],
                  );
              }),
            )
          ],
        ),
      ),
    );
  }
}
