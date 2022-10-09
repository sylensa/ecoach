import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class RevisionChart extends StatelessWidget {
  final List<charts.Series<RevisionData, int>> seriesList;
  final bool animate;

  RevisionChart(this.seriesList, {this.animate = true});

  factory RevisionChart.withSampleData(List<RevisionData> data) {
    return RevisionChart(
      _createSampleData(data),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        defaultRenderer:
            new charts.LineRendererConfig(includeArea: true, stacked: true),
        animate: animate);
  }

  static List<charts.Series<RevisionData, int>> _createSampleData(
      List<RevisionData> data) {
    final revisionData = data;

    return [
      new charts.Series<RevisionData, int>(
        id: 'revisions',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (RevisionData sales, _) => sales.position,
        measureFn: (RevisionData sales, _) => sales.score,
        data: revisionData,
      ),
    ];
  }
}

/// Sample linear data type.
class RevisionData {
  final int position;
  final int score;

  RevisionData(this.position, this.score);

  String get string => "$score";
}
