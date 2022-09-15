import 'package:flutter/material.dart';

class HighlightedTopic extends StatelessWidget {
  final String number;
  final String topic;
  final Widget barsWidget;
  const HighlightedTopic({Key? key, required this.number, required this.topic, required this.barsWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
              width: 20,
              child: Text('$number.', style: const TextStyle(fontSize: 16, ))),
          const SizedBox(width: 10,),
          Text(topic, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
          const Expanded(child: SizedBox()),
          barsWidget
        ],
      ),
    );
  }
}
