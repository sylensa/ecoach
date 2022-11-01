import 'package:flutter/material.dart';

import 'highlighted_topic.dart';

class HighlightedTopicsContainer extends StatelessWidget {
  final List<HighlightedTopic> topics;
  const HighlightedTopicsContainer({Key? key, required this.topics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFEEF7FF),
          borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      child: Column(
        children: topics,
      ),
    );
  }
}
