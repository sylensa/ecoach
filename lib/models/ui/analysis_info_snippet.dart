import 'package:flutter/material.dart';

class AnalysisInfoSnippet {
  AnalysisInfoSnippet({
    this.bodyText: 'body text',
    this.footerText: 'footer text',
    this.performance: '1',
    this.performanceImproved: true,
    this.background: Colors.orange,
  });

  final String bodyText;
  final String footerText;
  final String performance;
  final bool performanceImproved;
  final Color background;
}
