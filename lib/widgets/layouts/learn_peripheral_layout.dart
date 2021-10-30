import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/widgets/buttons/adeo_gray_outlined_button.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:flutter/material.dart';

class LearnPeripheralWidget extends StatelessWidget {
  const LearnPeripheralWidget({
    required this.heroText,
    required this.subText,
    required this.heroImageURL,
    required this.topActionLabel,
    this.topActionColor,
    this.topActionOnPressed,
    required this.mainActionLabel,
    this.mainActionColor,
    this.mainActionBackground,
    this.mainActionOnPressed,
    this.largeSubs = false,
  });

  final String heroText;
  final String subText;
  final String heroImageURL;
  final String mainActionLabel;
  final mainActionOnPressed;
  final Color? mainActionColor;
  final Color? mainActionBackground;
  final String topActionLabel;
  final Color? topActionColor;
  final topActionOnPressed;
  final bool largeSubs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdeoGrayOutlinedButton(
                  label: topActionLabel,
                  onPressed: topActionOnPressed,
                  size: Sizes.small,
                  color: topActionColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  heroText,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFFACACAC),
                    fontSize: 80.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    subText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontSize: largeSubs ? 24.0 : 16.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          largeSubs ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Container(
                  height: 270.0,
                  width: double.infinity,
                  child: Image.asset(
                    heroImageURL,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          AdeoTextButton(
            label: mainActionLabel,
            onPressed: mainActionOnPressed,
            color: mainActionColor,
            background: mainActionBackground,
          )
        ],
      ),
    );
  }
}
