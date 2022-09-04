import 'dart:io';

import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/database/course_db.dart';
import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/new_user_data.dart';
import 'package:ecoach/revamp/features/accessment/views/widgets/select_level_container.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChooseAccessmentLevel extends StatefulWidget {
  final User user;
  ChooseAccessmentLevel(this.user);

  @override
  State<ChooseAccessmentLevel> createState() => _ChooseAccessmentLevelState();
}

class _ChooseAccessmentLevelState extends State<ChooseAccessmentLevel> {
  List<String> levels = [
    'Lower Primary',
    'Upper Primary',
    'Junior High',
    'Senior High'
  ];

  List<Level> futureLevels = [];
  var futureCourses;
  String  selectedLevel = '';

  getLevelByGroup(String levelGroup)async{
    futureLevels = await LevelDB().levelByGroup(levelGroup);
    for(int i =0; i< futureLevels.length; i++){
      print("value[0].category:${futureLevels[i].id}");
    }
  }
  late BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  @override
  void initState() {
    print("_isBannerAdReady:$_isBannerAdReady");
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
        onAdLoaded: (_){
          setState((){
            _isBannerAdReady = true;
            print("_isBannerAdReady:$_isBannerAdReady");
          });
        },
        onAdFailedToLoad: (ad, error){
          print("Failed to load a banner Ad${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }
    ),
        request: AdRequest()
    )..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
          backgroundColor: const Color(0xFF0367B4),
          title: const Text(
            "Assessment",
            style: TextStyle(color: Colors.white),
          ),
        actions: [
          IconButton(onPressed:(){
            showLoaderDialog(context, message: "Refreshing Courses ...");
            ApiCall<Data>(AppUrl.new_user_data, isList: false,
                create: (Map<String, dynamic> json) {
                  return Data.fromJson(json);
                }, onCallback: (data) async{
                  if (data != null) {
                    await LevelDB().insertAll(data!.levels!);
                    await CourseDB().insertAll(data!.courses!);
                  }
                  Navigator.pop(context);
                  toastMessage("Courses refreshed successfully");
                }, onError: (e) {
                  Navigator.pop(context);
                }).get(context);
          }, icon: Icon(Icons.refresh,color: Colors.white,))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 21),
                const Center(
                  child: Text(
                    "Choose your preferred level",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(width: 11),
                    SelectLevelContainer(
                      image: "assets/images/primary.png",
                      title: "Lower Primary",
                      user: widget.user,
                      isSelected: selectedLevel == levels[0],
                      onTap: () async{
                        setState(() {
                          selectedLevel = levels[0];

                        });
                      },
                    ),
                    const SizedBox(width: 21),
                    SelectLevelContainer(
                      isSelected: selectedLevel == levels[1],
                      user: widget.user,
                      image: "assets/images/upper_primary.png",
                      title: "Upper Primary",
                      onTap: () async{
                        await getLevelByGroup("Primary");
                        setState(() {
                          selectedLevel = levels[1];
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 11),
                      SelectLevelContainer(
                          image: "assets/images/junior_hight.png",
                          title: "Junior High",
                          user: widget.user,
                          isSelected: selectedLevel == levels[2],
                          onTap: () async{
                            await getLevelByGroup(levels[2]);
                            setState(() {
                              selectedLevel = levels[2];
                            });
                          }),
                      const SizedBox(width: 21),
                      SelectLevelContainer(
                        isSelected: selectedLevel == levels[3],
                        user: widget.user,
                        image: "assets/images/senior_high.png",
                        title: "Senior High",
                        onTap: () async{
                          await getLevelByGroup(levels[3]);
                          setState(() {
                            selectedLevel = levels[3];
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // if(_isBannerAdReady && Platform.isAndroid)
          //   Container(
          //     height: _bannerAd.size.height.toDouble(),
          //     width: _bannerAd.size.width.toDouble(),
          //     child: AdWidget(ad: _bannerAd,),
          //   ),
        ],
      ),
    );
  }
}
