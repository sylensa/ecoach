import 'package:ecoach/models/subscription_item.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AdeoDropDown extends StatelessWidget {
  const AdeoDropDown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final SubscriptionItem value;
  final List<SubscriptionItem> items;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 14, right: 10),
        decoration: BoxDecoration(
          color: kPageBackgroundGray2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<SubscriptionItem>(
            value: value,
            itemHeight: 48,
            style: TextStyle(
              fontSize: 16,
              color: kDefaultBlack,
            ),
            onChanged: onChanged,
            items: items
                .map(
                  (item) => DropdownMenuItem<SubscriptionItem>(
                    value: item,
                    child: Text(
                      item.name!,
                      style: TextStyle(
                        color: kDefaultBlack,
                        fontSize: 14,
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
