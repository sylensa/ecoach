import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AdeoDropdownBorderless extends StatelessWidget {
  const AdeoDropdownBorderless({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List items;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: value,
            itemHeight: 48,
            style: TextStyle(
              fontSize: 16,
              color: kDefaultBlack,
            ),
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: kDefaultBlack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
