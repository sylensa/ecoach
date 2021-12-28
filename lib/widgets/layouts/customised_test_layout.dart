import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class CustomizedTestLayout extends StatelessWidget {
  final List<CustomizedLayoutPage> pages;
  static PageController _controller = PageController();

  static Function goForward = () {
    _controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  };
  static Function goBack = () {
    _controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  };

  CustomizedTestLayout({
    required this.pages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAdeoTaupe,
      body: Stack(
        children: [
          Positioned(
            left: -36.0,
            right: -36.0,
            top: 85,
            child: Container(
              height: backgroundIllustrationHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/deep_pool_orange_accent.png',
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: pages
                  .map(
                    (page) => Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 141),
                              Text(
                                page.title,
                                style: TextStyle(
                                  color: kDefaultBlack,
                                  fontSize: 44.0,
                                ),
                              ),
                              if (page.subText != null)
                                Column(
                                  children: [
                                    SizedBox(height: 11),
                                    Text(
                                      page.subText!,
                                      style: kCustomizedTestSubtextStyle,
                                    ),
                                  ],
                                ),
                              page.middlePiece,
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            page.footer,
                            SizedBox(height: 53),
                          ],
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// class _CustomizedTestLayoutState extends State<CustomizedTestLayout> {
//   @override
//   void initState() {
//     super.initState();
//     // _controller = PageController();

//     // CustomizedLayoutPage.goForward = () {
//     //   // if (!mounted) return;
//     //   setState(() {
//     //     _controller.nextPage(
//     //       duration: Duration(milliseconds: 300),
//     //       curve: Curves.fastLinearToSlowEaseIn,
//     //     );
//     //   });
//     // };
//     // CustomizedLayoutPage.goBack = () {
//     //   // if (!mounted) return;
//     //   setState(() {
//     //     _controller.previousPage(
//     //       duration: Duration(milliseconds: 300),
//     //       curve: Curves.fastLinearToSlowEaseIn,
//     //     );
//     //   });
//     // };
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kAdeoTaupe,
//       body: Stack(
//         children: [
//           Positioned(
//             left: -36.0,
//             right: -36.0,
//             top: 85,
//             child: Container(
//               height: backgroundIllustrationHeight,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage(
//                     'assets/images/deep_pool_orange_accent.png',
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: PageView(
//               controller: CustomizedTestLayout._controller,
//               physics: NeverScrollableScrollPhysics(),
//               children: widget.pages
//                   .map(
//                     (page) => Column(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             children: [
//                               SizedBox(height: 141),
//                               Text(
//                                 page.title,
//                                 style: TextStyle(
//                                   color: kDefaultBlack,
//                                   fontSize: 44.0,
//                                 ),
//                               ),
//                               if (page.subText != null)
//                                 Column(
//                                   children: [
//                                     SizedBox(height: 11),
//                                     Text(
//                                       page.subText!,
//                                       style: kCustomizedTestSubtextStyle,
//                                     ),
//                                   ],
//                                 ),
//                               page.middlePiece,
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             page.footer,
//                             SizedBox(height: 53),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CustomizedLayoutPage {
  final String title;
  final String? subText;
  final Widget middlePiece;
  final Widget footer;

  CustomizedLayoutPage({
    required this.title,
    required this.middlePiece,
    required this.footer,
    this.subText,
  });
}
