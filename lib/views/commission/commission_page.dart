import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:flutter/material.dart';

class CommissionPage extends StatefulWidget {
  const CommissionPage({Key? key}) : super(key: key);

  @override
  State<CommissionPage> createState() => _CommissionPageState();
}

class _CommissionPageState extends State<CommissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color:  Color(0XFF2D3E50),)),
        title:    Text(
          "Commissions",
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText("Earn commissions fore referrals that subscribe",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("You are currently",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 18),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("Not",color: kDefaultBlack,weight: FontWeight.bold,align: TextAlign.center,size: 30),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: sText("an agent",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 18),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText("If you will like to be an agent for Adeo, Please click on the customer care button below",color: kAdeoGray3,weight: FontWeight.w400,align: TextAlign.center),
            ),
            GestureDetector(
              onTap: ()async{
                customerCare();
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 30,right: 20,left: 20),
                decoration: BoxDecoration(
                    color: Color(0xFFddfffc),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.headset_mic_outlined,color: Color(0xFF00C9B9),),
                    SizedBox(width: 20,),
                    Text(
                      "I want to be an agent",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00C9B9),
                          height: 1.1,
                          fontFamily: "Poppins"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
