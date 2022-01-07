import 'package:ecoach/widgets/adeo_switch.dart';
import 'package:flutter/material.dart';

class PercentageSwitch extends StatelessWidget {
  const PercentageSwitch(
      {required this.showInPercentage, this.onChanged, Key? key})
      : super(key: key);

  final bool showInPercentage;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              onChanged!(!showInPercentage);
            },
            child: Row(
              children: [
                Text(
                  '%',
                  style: TextStyle(
                    color: Color(0xFF2A9CEA),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(width: 5),
                AdeoSwitch(
                  value: showInPercentage,
                  activeColor: Color(0xFF2A9CEA),
                  onChanged: (bool value) {
                    onChanged!(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
