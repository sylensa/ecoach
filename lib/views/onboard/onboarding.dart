import 'package:ecoach/controllers/plan_controllers.dart';
import 'package:ecoach/database/plan.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/auth/login_view.dart';
import 'package:ecoach/views/auth/register_view.dart';
import 'package:ecoach/views/onboard/onboard_data.dart';
import 'package:flutter/material.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/revamp/features/account/view/screen/log_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../revamp/features/account/view/screen/create_account.dart';


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
    // PlanController().getPlan();
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
        return {'hue': kAdeoCoral, 'shade': Color(0xFF00C9B9)};
      default:
        return {'hue': kAdeoBlue, 'shade': Color(0xFF057395)};
    }
  }

  goToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogInPage(),
      ),
    );
  }

  goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: page < 3 ? getColors(page)['hue'] :  Color(0xFF00C9B9) ,
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
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  page < 3 ? getColors(page)['hue']! : Color(0xFF00C9B9),
                  page < 3 ? getColors(page)['hue']! : Color(0xFF00A396),
                ],
              ),
            ),
            child: Column(
              children: [

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
                            if(page < 3){
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
                            }else{
                             return Column(
                               children: [
                                 Expanded(
                                   child:   WelcomePage(),
                                 ),

                               ],
                             );
                            }

                          },
                        ),
                      )
                      ,
                      //skip
                     page < 3 ?
                      Container(
                          // height: 60,
                          padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                          child:
                              Row(
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

                      ) :
                     Container(
                       decoration: const BoxDecoration(
                         gradient: LinearGradient(
                           colors: [
                             Color(0xFF00A396),
                             Color(0xFF00A396),
                             // Color(0xFF00C9B9),

                           ],
                         ),
                       ),
                       padding: const EdgeInsets.only(left: 27.0, right: 27.0,bottom: 20),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: [
                           // const Text(
                           //   'Welcome \nto Adeo',
                           //   style: TextStyle(
                           //     fontSize: 38,
                           //     fontWeight: FontWeight.w500,
                           //     color: Colors.white,
                           //   ),
                           // ),
                           // const SizedBox(
                           //   height: 9,
                           // ),
                           // const Text(
                           //   """Prep for your upcoming exams with ease.\nBECE | WASSCE | JAMB and many others.""",
                           //   style: TextStyle(
                           //     color: kHomeTextColor,
                           //     fontSize: 13,
                           //   ),
                           // ),
                           // const SizedBox(
                           //   height: 66,
                           // ),
                           InkWell(
                             onTap: () {
                               goToRegisterPage();
                             },
                             child: Material(
                               borderRadius: BorderRadius.circular(35),
                               child: const Padding(
                                 padding: EdgeInsets.all(15.0),
                                 child: Text(
                                   "Join Now",
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                     color: Color(0xFF00A89B),
                                     fontSize: 18,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                           const SizedBox(
                             height: 16,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                 "Alredy a member?",
                                 style: TextStyle(
                                     color: Colors.grey.shade300,
                                     fontSize: 15,
                                     fontWeight: FontWeight.w300),
                               ),
                               const SizedBox(
                                 width: 5,
                               ),
                               InkWell(
                                 onTap: () {
                                   goToLoginPage();
                                 },
                                 child: const Text(
                                   "Login",
                                   style: TextStyle(color: Colors.white, fontSize: 15),
                                 ),
                               ),
                             ],
                           )
                         ],
                       ),
                     ),
                      // SizedBox(height: 20),

              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
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

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00C9B9),
            Color(0xFF00A396),
          ],
        ),
        image: DecorationImage(image: AssetImage("assets/images/welcome_new.png"),fit: BoxFit.fitWidth)
      ),

    );
  }
}
