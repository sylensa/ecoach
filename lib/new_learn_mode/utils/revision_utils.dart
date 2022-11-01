import '../widgets/bullet_rule.dart';

List<String> revisionRules = [
  "Take a 10 question test on a topic",
  "Score 7 or higher to progress to the next topic",
  "A score of less than 7 will open up the topic notes for revision",
  "Progress is saved all the time so you can continue where ever you left off",
  "Start a new revision round whenever you want you "
];

List<BulletRule> revisionRulesList = List.generate(revisionRules.length, (index) {
  return BulletRule(rule: revisionRules[index]);
});