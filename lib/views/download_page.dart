import 'package:ecoach/models/download_update.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/src/provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({
    Key? key,
  }) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 7),
                child: Text(
                  context.read<DownloadUpdate>().message!,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                )),
            context.read<DownloadUpdate>().percentage > 0 &&
                    context.read<DownloadUpdate>().percentage < 100
                ? LinearPercentIndicator(
                    percent: context.read<DownloadUpdate>().percentage / 100,
                  )
                : LinearProgressIndicator(),
            SizedBox(
              height: 50,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: context.read<DownloadUpdate>().doneDownloads.length,
                itemBuilder: (context, index) {
                  return Text(
                      context.read<DownloadUpdate>().doneDownloads[index],
                      style: TextStyle(color: Colors.black));
                }),
          ],
        ),
      ),
    );
  }
}
