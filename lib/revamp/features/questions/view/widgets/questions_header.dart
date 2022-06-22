import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionsHeader extends StatefulWidget {
  const QuestionsHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionsHeader> createState() => _QuestionsHeaderState();
}

class _QuestionsHeaderState extends State<QuestionsHeader> {
  bool swichValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2D3E50),
      height: 47,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "00:40:55",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          const SizedBox(
            height: 16,
            child: VerticalDivider(
              color: Color(0xFF9EE4FF),
              width: 1,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          SvgPicture.asset(
            "assets/images/fav.svg",
          ),
          const SizedBox(
            width: 5,
          ),
          const Text(
            "65.60%",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 18.2,
          ),
          SvgPicture.asset(
            "assets/images/speed.svg",
          ),
          const SizedBox(
            width: 6.4,
          ),
          const Text(
            "240s",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 17.6,
          ),
          SvgPicture.asset(
            "assets/images/add.svg",
            height: 13.8,
            width: 13.8,
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            "258",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 17,
          ),
          const Icon(
            Icons.remove,
            color: Colors.red,
          ),
          const SizedBox(
            width: 6.4,
          ),
          const Text(
            "25",
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF9EE4FF),
            ),
          ),
          const SizedBox(
            width: 4.2,
          ),
          const SizedBox(
            height: 16,
            child: VerticalDivider(
              color: Color(0xFF9EE4FF),
              width: 1,
            ),
          ),
          const SizedBox(
            width: 6.2,
          ),
          InkWell(
            onTap: () {
              setState(() {
                swichValue = !swichValue;
              });
            },
            child: SvgPicture.asset(
              swichValue ? "assets/images/off_switch.svg" : "assets/images/on_switch.svg",
            ),
          ),
        ],
      ),
    );
  }
}
