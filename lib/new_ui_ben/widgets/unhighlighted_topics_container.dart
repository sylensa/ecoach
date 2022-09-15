
import 'package:ecoach/new_ui_ben/widgets/unhighlighted_topic.dart';
import 'package:flutter/material.dart';

class UnhighlightedTopicsContainer extends StatelessWidget {
  final List<UnhighlightedTopic> topics;
  const UnhighlightedTopicsContainer({Key? key, required this.topics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: topics,
      ),
    );
  }
}
