import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:flutter/material.dart';

class AnalysisInfoSnippetCard extends StatelessWidget {
  const AnalysisInfoSnippetCard({required this.info});

  final AnalysisInfoSnippet info;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: 100.0,
        color: info.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        child: Image.asset(
                          'assets/icons/progress_${info.performanceImproved ? 'up' : 'down'}.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(width: 2.0),
                      Text(
                        info.performance,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Center(
                child: Text(
                  info.bodyText,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: darken(info.background, 30),
                  ),
                ),
              ),
            ),
            Container(
              height: 1.0,
              width: 56.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  double.infinity,
                ),
                boxShadow: [
                  BoxShadow(
                    color: darken(info.background, 80),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              color: darken(info.background, 20),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: Text(
                  info.footerText,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
