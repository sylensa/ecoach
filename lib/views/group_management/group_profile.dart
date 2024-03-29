import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupProfilePage extends StatefulWidget {
  GroupProfilePage();

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kHomeBackgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
        title:    Text(
          "SHS Physics A1",
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color:  Color(0XFF2D3E50),
              height: 1.1,
              fontFamily: "Poppins"
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText("01290",color: Color(0xFF2A9CEA),weight: FontWeight.w500,align: TextAlign.center,size: 25),
            ),
            Container(
              padding: EdgeInsets.only(left: 0,right: 0,bottom: 20,top: 30),

              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0FDFC),
                      borderRadius: BorderRadius.circular(64.0),
                      border: Border.all(
                        width: 5.0,
                        color: Color(0xFF00C9B9),
                      ),
                    ),
                    child: displayImage("",radius: 40),
                  ),
                  // SizedBox(
                  //   height: 100,
                  //   width: 100,
                  //   child: Stack(
                  //     children:  [
                  //       Container(
                  //         width: 200,
                  //         height: 200,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(64.0),
                  //           color: Color(0xFFF0FDFC),
                  //
                  //         ),
                  //         child: CircularProgressIndicator(
                  //           color:  Color(0xFF00C9B9),
                  //           strokeWidth: 5,
                  //           value: 0.6
                  //             ),
                  //       ),
                  //       Center(
                  //         child: displayImage("${widget.user.avatar != null ? widget.user.avatar! : ""}",radius: 40),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    width: 1,
                    height: 70,
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Joined",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              height: 1.1,
                              fontFamily: "Poppins"
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "${StringExtension.displayTimeAgoFromTimestamp(DateTime.now().toString())} ago",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color:  Color(0XFF2D3E50),
                              height: 1.1,
                              fontFamily: "Poppins"
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 0,),
            Container(
              margin: leftPadding(40),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${properCase("Victor")}",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      color:  Color(0XFF2D3E50),
                      height: 1.1,
                      fontFamily: "Poppins",

                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        "${properCase("Adatsi")}",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                          height: 1.1,
                        ),
                      ),
                      Icon(Icons.edit,color:  Color(0XFF2D3E50),)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(color: Colors.white,thickness: 2,),
            SizedBox(height: 20,),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Container(
                            width: 120,
                            child: Text(
                              "Tests",
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child:  Text(
                            "0",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              height: 1.1,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Container(
                            width: 120,
                            child: Text(
                              "Questions",
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child:  Text(
                            "0",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              height: 1.1,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Container(
                            width: 120,
                            child: Text(
                              "Avg. Score",
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child:  Text(
                            "0",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              height: 1.1,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Container(
                            width: 120,
                            child: Text(
                              "Speed",
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child:  Text(
                            "0",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                              height: 1.1,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward_ios,size: 20,color: Colors.grey,),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
