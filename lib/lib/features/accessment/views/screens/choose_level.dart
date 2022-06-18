import 'package:ecoach/database/level_db.dart';
import 'package:ecoach/lib/features/accessment/views/widgets/select_level_container.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0367B4),
      appBar: AppBar(
          backgroundColor: const Color(0xFF0367B4),
          title: const Text(
            "Accessment",
            style: TextStyle(color: Colors.white),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  image: "assets/images/sernior_high.png",
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
    );
  }
}
