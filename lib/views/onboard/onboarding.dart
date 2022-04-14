import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/onboard/onboard_data.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int page = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: page);
    UserPreferences().setSeenOnboard();
  }

  Map<String, Color> getColors(int page) {
    switch (page) {
      case 0:
        return {'hue': kAdeoBlue, 'shade': Color(0xFF057395)};
      case 1:
        return {'hue': kAdeoGreen, 'shade': Color(0xFF037D41)};
      case 2:
        return {'hue': kAdeoTaupe, 'shade': Color(0xFFDC880B)};
      case 3:
        return {'hue': kAdeoCoral, 'shade': Color(0xFFB74C48)};
      default:
        return {'hue': kAdeoBlue, 'shade': Color(0xFF057395)};
    }
  }

  goToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColors(page)['hue'],
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 38,
            child: Container(
              height: (MediaQuery.of(context).size.height / 2) - 38,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/onboard/gradient_pool.png'),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 62,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 20,
                    right: 24,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: onBoardData.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 4),
                    itemBuilder: (context, index) {
                      return OnboardPageIndicator(
                        color: getColors(page)['shade']!,
                        isActive: page == index,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: onBoardData.length,
                    onPageChanged: (newPage) {
                      setState(() {
                        page = newPage;
                      });
                    },
                    itemBuilder: (context, index) {
                      OnBoardPage pageData = onBoardData[index];
                      return Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(
                                top: 40,
                                left: 74,
                                right: 74,
                                bottom: 56,
                              ),
                              // constraints: BoxConstraints(
                              //   maxWidth: 240,
                              //   maxHeight: 240,
                              // ),
                              child: Image.asset(
                                pageData.imgUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 56,
                                left: 24,
                                right: 24,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    pageData.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'Helvetica Rounded',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    pageData.subTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: page < 3
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OnboardButton(
                              onPressed: goToLoginPage,
                              label: 'skip',
                              isPlain: true,
                            ),
                            OnboardButton(
                              onPressed: () {
                                setState(() {
                                  controller.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.bounceInOut,
                                  );
                                  page += 1;
                                });
                              },
                              label: 'next',
                              color: getColors(page)['hue'],
                              isPlain: false,
                            ),
                          ],
                        )
                      : Container(
                          width: 275,
                          child: Row(
                            children: [
                              Expanded(
                                child: OnboardButton(
                                  onPressed: goToLoginPage,
                                  label: 'let\'s go',
                                  color: getColors(page)['hue'],
                                  isPlain: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardPageIndicator extends StatelessWidget {
  OnboardPageIndicator({
    required this.color,
    this.isActive = false,
    Key? key,
  }) : super(key: key);

  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        border: Border.all(color: color),
        shape: BoxShape.circle,
      ),
      duration: Duration(milliseconds: 400),
    );
  }
}

class OnboardButton extends StatelessWidget {
  const OnboardButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.isPlain = false,
  });

  final String label;
  final onPressed;
  final Color? color;
  final bool isPlain;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(onPressed, context),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        padding:
            EdgeInsets.symmetric(horizontal: isPlain ? 0 : 32, vertical: 16),
        decoration: BoxDecoration(
          color: isPlain ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
