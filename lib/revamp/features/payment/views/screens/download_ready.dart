import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/download_update.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/download_failed.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DownloadReady extends StatefulWidget {
  DownloadReady(this.user, {Key? key,required this.selectedTableRows, required this.bundle, required this.controller}) : super(key: key);
  final Plan bundle;
  List<SubscriptionItem> selectedTableRows;
  User user;
  MainController controller;

  @override
  State<DownloadReady> createState() => _DownloadReadyState();
}

class _DownloadReadyState extends State<DownloadReady> {

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:
        context.watch<DownloadUpdate>().isDownloading ?
        Container(
          height: MediaQuery.of(context).size.height * .25,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 24, color: Color(0x4D000000))
            ],
          ),
          child: Column(
            children: [
              context.read<DownloadUpdate>().percentage > 0 &&
                  context.read<DownloadUpdate>().percentage < 100
                  ? LinearPercentIndicator(
                percent:
                context.read<DownloadUpdate>().percentage /
                    100,
                linearStrokeCap: LinearStrokeCap.butt,
                progressColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 0),
                lineHeight: 4,
              )
                  : LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  context
                      .read<DownloadUpdate>()
                      .message!
                      .toTitleCase(),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  shrinkWrap: true,
                  itemCount: context
                      .read<DownloadUpdate>()
                      .doneDownloads
                      .length,
                  itemBuilder: (context, index) {
                    return Text(
                      context
                          .read<DownloadUpdate>()
                          .doneDownloads[index],
                      style: TextStyle(color: kAdeoGray2),
                    );
                  },
                ),
              )

            ],
          ),
        ) : Container(child: sText("word",color: Colors.white),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sText("Download Ready",size: 40,weight: FontWeight.bold,color: Color(0XFF2D3E50),align: TextAlign.center),
              Column(
                children: [
                  sText("${widget.bundle.name}",size: 40,weight: FontWeight.bold,color: Color(0XFF00C9B9),align: TextAlign.center),
                  SizedBox(height: 20,),
                  sText("size: 20mb",weight: FontWeight.normal,color: Color(0XFF2D3E50),align: TextAlign.center),
                ],
              ),

            Column(
              children: [
                GestureDetector(
                  onTap: ()async{
                    final bool isConnected = await InternetConnectionChecker().hasConnection;
                    if(!isConnected){
                      goTo(context, DownloadFailed(),replace: true);
                    }else{
                      widget.controller.downloadSubscription(
                        widget.selectedTableRows,
                            (success) {
                          UserPreferences().getUser().then(
                                (user) {
                              setState(() {
                                widget.user = user!;

                              });
                            },
                          );
                          toastMessage("Bundle download successfully");
                         Navigator.pop(context);
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    width: appWidth(context),
                    child: sText("Download Now",color: Colors.white,size: 16,align: TextAlign.center,weight: FontWeight.bold),
                    decoration: BoxDecoration(
                        color: Color(0XFF00C9B9),
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                sText("or",weight: FontWeight.bold,color: Color(0XFF2D3E50),align: TextAlign.center,size: 20),
                SizedBox(height: 40,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    width: appWidth(context),
                    child: sText("Download Later",color: Colors.grey[400]!,size: 16,align: TextAlign.center,weight: FontWeight.bold),
                    decoration: BoxDecoration(
                        color: kAdeoGray,
                        borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                ),
              ],
            )
            ],
          ),
        ),
      ),
    );
  }
}
