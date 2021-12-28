import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AdeoBottomNavigationBar extends StatelessWidget {
  static double navbarHeight = 64.0;
  final int selectedIndex;
  final Function onItemSelected;
  final List items;

  AdeoBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: navbarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: kNavigationTopBorderColor, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          int index = items.indexOf(item);

          return GestureDetector(
            onTap: Feedback.wrapForTap(() {
              onItemSelected(index);
            }, context),
            child: Icon(
              index == selectedIndex ? item['active'] : item['inactive'],
              size: index == selectedIndex ? 44 : 32,
              color: index == selectedIndex ? Color(0xFF2A9CEA) : kAdeoGray3,
            ),
            // child: Container(
            //   width: navbarHeight,
            //   height: navbarHeight,
            //   child: Stack(
            //     children: [
            //       // if (selectedIndex == index)
            //       //   Container(
            //       //     width: double.infinity,
            //       //     height: 2.0,
            //       //     color: Color(0xFF00C664),
            //       //   ),
            //       Container(
            //         color: Colors.transparent,
            //         child: Center(
            //           child: Image.asset(
            //             'assets/icons/navigation/${item + '_'}${index == selectedIndex ? 'active' : 'inactive'}.png',
            //             fit: BoxFit.fill,
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          );
        }).toList(),
      ),
    );
  }
}
