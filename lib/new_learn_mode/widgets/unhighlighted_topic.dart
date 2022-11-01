import 'package:flutter/material.dart';

class UnhighlightedTopic extends StatelessWidget {
  final String number;
  final String topic;
  final Widget barsWidget;
  const UnhighlightedTopic({Key? key, required this.number, required this.topic, required this.barsWidget}) : super(key: key);

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
          Text(topic, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
          const Expanded(child: SizedBox()),
          barsWidget
        ],
      ),
    );
  }
}
