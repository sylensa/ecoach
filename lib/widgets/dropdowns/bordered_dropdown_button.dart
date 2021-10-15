import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class BorderedDropdownButton extends StatelessWidget {
  const BorderedDropdownButton({
    required this.value,
    required this.items,
    this.onChanged,
    this.isExpanded,
    this.size,
  });

  final String value;
  final List<String> items;
  final Function? onChanged;
  final bool? isExpanded;
  final Sizes? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: isExpanded! ? 1 : 0,
          child: Container(
            height: () {
              switch (size) {
                case Sizes.small:
                  return 24.0;
                case Sizes.medium:
                  return 32.0;
                case Sizes.large:
                  return 48.0;
                default:
                  return 24.0;
              }
            }(),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xAAFFFFFF), width: 0.5),
            ),
            child: DropdownButton(
              value: value,
              dropdownColor: kAnalysisScreenBackground,
              underline: Container(),
              icon: Image.asset('assets/icons/arrows/arrow_down.png'),
              isExpanded: isExpanded!,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Color(0xAAFFFFFF),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                onChanged!(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
