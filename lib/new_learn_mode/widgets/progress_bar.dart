import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final bool isLevel;
  final String? subTitle;
  final String? secondarySubTitle;
  const ProgressBar(
      {Key? key,
      required this.value,
      this.isLevel = false,
      this.subTitle,
      this.secondarySubTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: isLevel ? (value / 5) : (value / 100),
            minHeight: 6,
            backgroundColor: const Color(0xFF0367B4),
            color: const Color(0xFF00C9B9),
          ),
        ),
        isLevel
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  value == 0
                      ? const Text(
                          'try it',
                          style: TextStyle(
                              color: Color(0xFF8BB9DC),
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          subTitle != null
                              ? subTitle ?? ""
                              : value == 5
                                  ? 'completed'
                                  : 'Level ${value.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Color(0xFF8BB9DC),
                              fontWeight: FontWeight.w500),
                        )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  secondarySubTitle == null
                      ? const SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : Text(
                          secondarySubTitle!,
                          style: const TextStyle(
                            color: Color(0xFF8BB9DC),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  value == 0
                      ? const Text(
                          'try it',
                          style: TextStyle(
                              color: Color(0xFF8BB9DC),
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          subTitle != null
                              ? subTitle ?? ""
                              : value == 100
                                  ? 'completed'
                                  : '${value.toStringAsFixed(0)}% complete',
                          style: const TextStyle(
                              color: Color(0xFF8BB9DC),
                              fontWeight: FontWeight.w500),
                        )
                ],
              )
      ],
    );
  }
}
