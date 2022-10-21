import 'package:flutter/material.dart';

import '../../models/subscription_item.dart';

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
    return Material(
      color: Colors.transparent,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SubscriptionItem>(
          iconEnabledColor: Color(0xFF787E87),
          focusColor: Colors.transparent,
          value: value,
          itemHeight: 50,
          onChanged: onChanged,
          dropdownColor: Color(0xFFE5E5E5),
          style: TextStyle(
            color: Colors.white,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<SubscriptionItem>(
                  // alignment: AlignmentDirectional.center,
                  value: item,
                  child: Text(
                    item.name!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'PoppinsMedium',
                      color: Color(0xFF787E87),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
