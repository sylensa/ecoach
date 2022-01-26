import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/arrow_button.dart';
import 'package:flutter/material.dart';

class StatsSliderCard extends StatefulWidget {
  final List<Stat> items;
  final Function? onChanged;

  const StatsSliderCard({
    Key? key,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatsSliderCard> createState() => _StatsSliderCardState();
}

class _StatsSliderCardState extends State<StatsSliderCard> {
  PageController controller = PageController(initialPage: 0);
  Duration animationDuration = Duration(milliseconds: 300);
  Curve animationCurve = Curves.fastLinearToSlowEaseIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 90),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ArrowButton(
            arrow: 'assets/icons/arrows/chevron_left.png',
            onPressed: () {
              double current = controller.page!;
              setState(() {
                if (current == 0) {
                  if (widget.onChanged != null)
                    widget.onChanged!(widget.items.length - 1);
                  controller.animateToPage(
                    widget.items.length - 1,
                    duration: animationDuration,
                    curve: animationCurve,
                  );
                } else {
                  if (widget.onChanged != null) widget.onChanged!(current - 1);
                  controller.previousPage(
                    duration: animationDuration,
                    curve: animationCurve,
                  );
                }
              });
            },
          ),
          Expanded(
            child: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: widget.items
                  .map(
                    (item) => Column(
                      children: [
                        if (item.hasStandaloneWidgetAsValue == true)
                          Column(
                            children: [
                              item.value,
                              SizedBox(height: 6),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (item.hasAppreciated == true)
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 16,
                                      child: Image.asset(
                                        'assets/icons/progress_up.png',
                                        // fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 12)
                                  ],
                                )
                              else if (item.hasDeprecated == true)
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 16,
                                      child: Image.asset(
                                        'assets/icons/progress_down.png',
                                        // fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 12)
                                  ],
                                ),
                              Text(
                                item.value,
                                style: TextStyle(
                                  color: kAdeoBlue2,
                                  fontSize: 41,
                                  fontFamily: 'Helvetica Rounded',
                                ),
                              ),
                            ],
                          ),
                        Text(
                          item.statLabel.toTitleCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0x80000000),
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
          ArrowButton(
            arrow: 'assets/icons/arrows/chevron_right.png',
            onPressed: () {
              double current = controller.page!;
              setState(() {
                if (current == widget.items.length - 1) {
                  if (widget.onChanged != null) widget.onChanged!(0);
                  controller.animateToPage(
                    0,
                    duration: animationDuration,
                    curve: animationCurve,
                  );
                } else {
                  if (widget.onChanged != null) widget.onChanged!(current + 1);
                  controller.nextPage(
                    duration: animationDuration,
                    curve: animationCurve,
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class Stat {
  const Stat({
    required this.value,
    required this.statLabel,
    this.hasAppreciated,
    this.hasDeprecated,
    this.hasStandaloneWidgetAsValue,
    Key? key,
  });

  final dynamic value;
  final String statLabel;
  final bool? hasAppreciated;
  final bool? hasDeprecated;
  final bool? hasStandaloneWidgetAsValue;
}
