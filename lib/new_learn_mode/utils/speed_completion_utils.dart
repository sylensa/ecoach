import '../widgets/bullet_rule.dart';

List<String> speedCompletionRules = [
  "Start with the lowest speed to answer a question",
  "Get 10 consecutive questions correct and move to the next level ",
  "Get 3 consecutive questions wrong and it returns to the previous level",
  "Higher levels have shorter question time",
];

List<BulletRule> speedCompletionRulesList =
    List.generate(speedCompletionRules.length, (index) {
  return BulletRule(rule: speedCompletionRules[index]);
});
