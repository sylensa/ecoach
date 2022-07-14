import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/agent_transaction.dart';
import 'package:ecoach/models/get_agent_code.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommissionAgentPage extends StatefulWidget {
  const CommissionAgentPage({Key? key}) : super(key: key);

  @override
  State<CommissionAgentPage> createState() => _CommissionAgentPageState();
}

class _CommissionAgentPageState extends State<CommissionAgentPage> {
  bool progressCode = true;
  getAgentTransactionDetails()async {
    listDataResponse.clear();
    try{
      var js = await doGet('${AppUrl.agentTransaction}');
      print("res agentTransaction : $js");
      if (js["status"] && js["data"]["data"].isNotEmpty) {
        AgentTransactionResponse agentData = AgentTransactionResponse.fromJson(js["data"]);
        listDataResponse.add(agentData);
        setState((){
          progressCode = true;
        });
      }else{
        setState((){
          progressCode = false;
        });
      }

    }catch(e){
      setState((){
        progressCode = false;
      });
      toastMessage("Failed");
    }
  }
  getPromoCodes()async {
    // try{
      var js = await doPost(AppUrl.agentPromoCodes, {});
      print("res agentPromoCodes : $js");
      if (js["status"]) {
        DataCodes agentData = DataCodes.fromJson(js["data"]);
        agentData.subscribers = 0;
        agentData.commission = 0.00;
        listAgentData[0].data!.add(agentData);
        toastMessage("${js["message"]}");
        Navigator.pop(context);
        successModalBottomSheet(context);
        setState((){

        });
      }else{
        Navigator.pop(context);
        failedModalBottomSheet(context);
        toastMessage("${js["message"]}");
      }
    // }catch(e){
    //   Navigator.pop(context);
    //   toastMessage("Failed");
    // }
  }
  deleteCard(int cardId,int index)async {
    var js;
    try{
       js = await doDelete('${AppUrl.agentPromoCodes}/$cardId');
      print("res delete card : $js");
      if (js["status"]) {
        setState((){
          listAgentData[0].data!.removeAt(index);
        });
        toastMessage("${js["message"]}");
        Navigator.pop(context);

      }else{
        Navigator.pop(context);
        toastMessage("${js["message"]}");
      }
    }catch(e){
      Navigator.pop(context);
      toastMessage("Failed,$js");
    }
  }
  successModalBottomSheet(context){
    double sheetHeight = 350.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20,),
                              child: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),

                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green,width: 15),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.check,color: Colors.green,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Promo Code Generated Successfully",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  failedModalBottomSheet(context){
    double sheetHeight = 330.00;
    bool isSubmit = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(),

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20,),
                              child: Icon(Icons.clear,color: Colors.black,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0,),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.red,width: 15),
                              shape: BoxShape.circle
                          ),
                          child: Icon(Icons.close,color: Colors.red,size: 100,)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                        child: sText("Error, Promo Generate Failed",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      )
                    ],
                  )
              );
            },

          );
        }
    );
  }
  deleteModalBottomSheet(context,int codeId,int index){
    bool generateLink = true;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent ,
        isScrollControlled: true,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (BuildContext context,StateSetter stateSetter){
              return Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      border: Border.all(color: Color(0xFFBBCFD6,),width: 2),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child: sText("Are you sure to delete this promo code?",weight: FontWeight.bold,size: 20,align: TextAlign.center),
                      ),
                      Expanded(
                        child: ListView(
                          children: [

                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: ()async{
                                Navigator.pop(context);
                                showLoaderDialog(context, message: "Deleting Promo Code...");
                                await deleteCard(codeId,index);
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("Yes",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold),
                                    SizedBox(width: 10,),
                                    generateLink ? Container() : progress()
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:  Color(0xFFBBCFD6,))
                                ),
                              ),
                            ),


                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: ()async{
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    sText("No",color: Colors.white,align: TextAlign.center,weight: FontWeight.bold),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color:Color(0xFF0367B4,),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:  Color(0xFFBBCFD6,))
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  )
              );
            },

          );
        }
    );
  }

  @override
  void initState(){
    getAgentTransactionDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText("Total Commission",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 16),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    child: sText("GHC",color: kDefaultBlack,weight: FontWeight.bold,align: TextAlign.left,size: 16),
                  ),
                  SizedBox(width: 5,),
                  Container(
                    child: sText("$totalCommission",color: Color(0XFF2D3E50),weight: FontWeight.bold,align: TextAlign.left,size: 30),
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for(int i = 0; i < listAgentData[0].data!.length; i++)
                  GestureDetector(
                    onLongPress: (){
                      if(listAgentData[0].data![i].isDefault != 1){
                        deleteModalBottomSheet(context, listAgentData[0].data![i].id!,i);
                      }else{
                        toastMessage("Your default promo code cant be deleted");
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: leftPadding(10),
                          child: Image.asset("assets/images/commission1.png"),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 30,
                          child:Row(
                            children: [
                              sText("RS",color: kAdeoGray3,weight: FontWeight.w500,size: 14),
                              sText("${listAgentData[0].data![i].subscribers}",color: Colors.white,weight: FontWeight.bold,size: 20)
                            ],
                          ),

                        ),

                        Positioned(
                          top: 30,
                          left: 120,
                          child: Center(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    sText("${listAgentData[0].data![i].code}",color: Colors.white,weight: FontWeight.bold,size: 30),
                                    sText("Referral codes",color: kAdeoGray3,weight: FontWeight.w500,size: 14,align: TextAlign.center)
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Clipboard.setData( ClipboardData(text: "Adeo educational app The adeo educational app helps students prep better for their exams. It covers all subjects from Primary to Senior High School. Take a free assessment to determine your performance and buy a bundle to enjoy the full benefits of the adeo app Download the adeo educational app today from the google play store by clicking on this link https://play.google.com/store/apps/details?id=com.ecoach.adeo You can also download the desktop version by clicking here https://bit.ly/3Ia8r6t Use the promo code ${listAgentData[0].data![i].code} to get discounts on all your subscriptions or purchases. Do check our website for more information https://adeo.africa adeo ……………….easy prep, easy pass"));
                                    toastMessage("Copied to clipboard");
                                  },
                                    child: Icon(Icons.copy,color: kAdeoGray3,),
                                )
                              ],
                            ),
                          ),

                        ),


                        Positioned(
                          bottom: 20,
                          right: 20,
                          child:Row(
                            children: [
                              sText("GHC",color: kAdeoGray3,weight: FontWeight.w500,size: 14),
                              sText("${listAgentData[0].data![i].commission}",color: Colors.white,weight: FontWeight.bold,size: 20),
                            ],
                          ),

                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      showLoaderDialog(context, message: "Generating Promo Code...");
                      getPromoCodes();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset("assets/images/commission2.png",fit: BoxFit.fitHeight,),
                    ),
                  )
                  
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: sText("Transaction History",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 16),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 95,
                    child: sText("Date & Time",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 14),
                  ),
                  Container(
                    width: 80,
                    child: sText("Activity",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 14),
                  ),
                  Container(
                    width: 80,
                    child: sText("Code",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 14),
                  ),
                  Container(
                    width: 80,
                    child: sText("Amount",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: Divider(color: kDefaultBlack,thickness: 1,),
            ),
            SizedBox(height: 0,),
            listDataResponse.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: listDataResponse[0].data!.length,
                  itemBuilder: (BuildContext context, int index){
                  return  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 95,
                          child: sText("${listDataResponse[0].data![index].createdAt.toString().split(".").first.split(" ").first} | ${listDataResponse[0].data![index].createdAt.toString().split(".").first.split(" ").last}",color: kDefaultBlack,weight: FontWeight.w500,align: TextAlign.left,size: 12),
                        ),
                        Container(
                          width: 80,
                          child: sText("${listDataResponse[0].data![index].activity}",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 12),
                        ),
                        Container(
                          width: 80,
                          child: sText("${listDataResponse[0].data![index].promoCode}",color: kAdeoGray3,weight: FontWeight.w500,align: TextAlign.center,size: 12),
                        ),
                        Container(
                          width: 80,
                          child: sText("GHC ${listDataResponse[0].data![index].amount}",color: kDefaultBlack,weight: FontWeight.w500,align: TextAlign.right,size: 12),
                        ),
                      ],
                    ),
                  );
              }),
            ) :
            progressCode ?
            Expanded(child: Center(child: progress(),)) :
            Expanded(child: Center(child: sText("No transaction history"),))
          ],
        ),
      ),
    );
  }
}
