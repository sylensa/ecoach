class GradingSystem {
  final double score;
  final String level;

  GradingSystem({required this.score, required this.level});

  get grade {
    String grade;
    if (level.toUpperCase().contains('SHS'))
      grade = gradeSecondCylce(score);
    else
      grade = gradeBasicLevel(score);
    return grade;
  }

  gradeBasicLevel(double score) {
    if (score < 18)
      return '9';
    else if (score >= 18 && score < 27)
      return '8';
    else if (score >= 27 && score < 36)
      return '7';
    else if (score >= 36 && score < 45)
      return '6';
    else if (score >= 45 && score < 55)
      return '5';
    else if (score >= 55 && score < 65)
      return '4';
    else if (score >= 65 && score < 75)
      return '3';
    else if (score >= 75 && score < 85)
      return '2';
    else if (score >= 85) return 1;
  }

  gradeSecondCylce(double score) {
    if (score < 40)
      return 'F9';
    else if (score >= 40 && score < 45)
      return 'E8';
    else if (score >= 45 && score < 50)
      return 'D7';
    else if (score >= 50 && score < 55)
      return 'C6';
    else if (score >= 55 && score < 60)
      return 'C5';
    else if (score >= 60 && score < 65)
      return 'C4';
    else if (score >= 65 && score < 70)
      return 'B3';
    else if (score >= 70 && score < 80)
      return 'B2';
    else if (score >= 80) return 'A1';
  }
}
