import 'package:ecoach/controllers/main_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/features/payment/views/screens/download_failed.dart';
import 'package:ecoach/revamp/features/payment/views/screens/download_ready.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/index.dart';

class PreparingDownload extends StatefulWidget {

  PreparingDownload(this.user, {Key? key,required this.selectedTableRows, required this.bundle, required this.controller}) : super(key: key);
  final Plan bundle;
  List<SubscriptionItem> selectedTableRows;
  User user;
  MainController controller;

  @override
  State<PreparingDownload> createState() => _PreparingDownloadState();
}

class _PreparingDownloadState extends State<PreparingDownload> {
  CountdownTimerController? controller;
  int endTime = 3;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  void onEnd() {
    print('onEnd');
    if(widget.selectedTableRows.isNotEmpty){
      goTo(context, DownloadReady(widget.user,selectedTableRows: widget.selectedTableRows,controller: widget.controller,bundle: widget.bundle,),replace: true);
    }else{
      goTo(context, DownloadFailed(),replace: true);
    }

  }
  @override
 void initState(){
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 5;
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Expanded(child: sText("Preparing Download File",size: 40,weight: FontWeight.bold,color: Color(0XFF2D3E50),align: TextAlign.center)),
              Expanded(
                child: CountdownTimer(
                  endTime: endTime,
                  controller: controller,
                  widgetBuilder: (_, CurrentRemainingTime? time) {
                    if(time != null){
                      return sText('${time.sec}',size: 100,weight: FontWeight.bold,color:  Color(0XFF2D3E50),align: TextAlign.center);
                    }
                  return sText('0',size: 100,weight: FontWeight.bold,color:  Color(0XFF2D3E50),align: TextAlign.center);
                  },
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
