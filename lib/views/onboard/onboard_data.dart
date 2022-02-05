class OnBoardPage {
  String title;
  String subTitle;
  String imgUrl;

  OnBoardPage({
    required this.title,
    required this.subTitle,
    required this.imgUrl,
  });
}

List<OnBoardPage> onBoardData = [
  OnBoardPage(
    title: 'The educational system\nin your hands',
    subTitle:
        'Basic to SHS, all subjects, tests on various topics and past exam questions; instant test scoring',
    imgUrl: 'assets/onboard/page_1.png',
  ),
  OnBoardPage(
    title: 'Learn in different modes',
    subTitle:
        'Revision, course completion, speed enhancement, mastery improvement',
    imgUrl: 'assets/onboard/page_2.png',
  ),
  OnBoardPage(
    title: 'Track your progress',
    subTitle:
        'Get real-time progress report on average score, speed, total points, grade, rank and strength',
    imgUrl: 'assets/onboard/page_3.png',
  ),
  OnBoardPage(
    title: 'Learn anytime, anywhere',
    subTitle: 'Download all courses onto your device and practice offline',
    imgUrl: 'assets/onboard/page_4.png',
  )
];
