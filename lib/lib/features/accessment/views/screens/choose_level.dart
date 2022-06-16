import 'package:ecoach/lib/features/accessment/views/widgets/select_level_container.dart';
import 'package:flutter/material.dart';

class ChooseAccessmentLevel extends StatefulWidget {
  const ChooseAccessmentLevel({Key? key}) : super(key: key);

  @override
  State<ChooseAccessmentLevel> createState() => _ChooseAccessmentLevelState();
}

class _ChooseAccessmentLevelState extends State<ChooseAccessmentLevel> {
  String selectedLevel = '';
  List<String> levels = [
    'Lower Primary',
    'Upper Primary',
    'Junior High',
    'Senior High'
  ];

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
                image: "images/primary.png",
                title: "Lower Primary",
                isSelected: selectedLevel == levels[0],
                onTap: () {
                  setState(() {
                    selectedLevel = levels[0];
                    
                  });
                },
              ),
              const SizedBox(width: 21),
              SelectLevelContainer(
                isSelected: selectedLevel == levels[1],
                image: "images/upper_primary.png",
                title: "Upper Primary",
                onTap: () {
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
                    image: "images/junior_hight.png",
                    title: "Junior High",
                    isSelected: selectedLevel == levels[2],
                    onTap: () {
                      setState(() {
                        selectedLevel = levels[2];
                      });
                    }),
                const SizedBox(width: 21),
                SelectLevelContainer(
                  isSelected: selectedLevel == levels[3],
                  image: "images/sernior_high.png",
                  title: "Sernior High",
                  onTap: () {
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
