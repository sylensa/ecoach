import '../widgets/bullet_rule.dart';

List<String> courseCompletionRules = [
  "Read or listen to notes on a topic",
  "Take a 10 question test ",
  "Score 7 or higher to progress to the next topic",
  "A score of less than 7 will return you to topic notes for revision",
  "Progress is saved all the time so you can continue where ever you left off",
  "Start a new revision round whenever you want you "
];

List<BulletRule> courseCompletionRulesList =
    List.generate(courseCompletionRules.length, (index) {
  return BulletRule(rule: courseCompletionRules[index]);
});
