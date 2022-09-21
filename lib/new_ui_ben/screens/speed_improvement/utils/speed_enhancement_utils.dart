// create a class to hold speed enhancement levels

class SpeedEnhancementLevel {
  String backgroundImage, label, level, levelImage, timer;

  SpeedEnhancementLevel({
    required this.backgroundImage,
    required this.label,
    required this.level,
    required this.levelImage,
    required this.timer,
  });
}

// create a list of background images
List<String> levelBackgroundImages = [
  "assets/images/learn_mode2/level1bg.png",
  "assets/images/learn_mode2/level2bg.png",
  "assets/images/learn_mode2/level3bg.png",
  "assets/images/learn_mode2/level4bg.png",
  "assets/images/learn_mode2/level5bg.png",
  "assets/images/learn_mode2/level6bg.png",
];

// create a list of level images
List<String> levelImages = [
  "assets/images/learn_mode2/level1img.png",
  "assets/images/learn_mode2/level2img.png",
  "assets/images/learn_mode2/level3img.png",
  "assets/images/learn_mode2/level4img.png",
  "assets/images/learn_mode2/level5img.png",
  "assets/images/learn_mode2/level6img.png",
];

// create a list of level labels
// level labels are sub descriptions of a level
List<String> labels = [
  "slow but sure",
  "natural pace",
  "galloping",
  "fire up the speed",
  "let the eagle soar",
  "race to the summit"
];

List<String> levelTimer = ["120", "90", "60", "30", "20", "10"];

// create a list of speed enhancement levels
List<SpeedEnhancementLevel> speedEnhancementLevels = List.generate(
  levelImages.length,
  (index) => SpeedEnhancementLevel(
    backgroundImage: levelBackgroundImages[index],
    label: labels[index],
    level: "Level ${index + 1}",
    levelImage: levelImages[index],
    timer: levelTimer[index],
  ),
);
