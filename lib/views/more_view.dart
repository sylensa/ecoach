import 'package:ecoach/models/ui/analysis_info_snippet.dart';
import 'package:ecoach/models/ui/bundle.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/bundle_download.dart';
import 'package:ecoach/widgets/tab_bars/analysis_info_snippet_card_tab_bar.dart';
import 'package:ecoach/widgets/user_profile.dart';
import 'package:flutter/material.dart';

class MoreView extends StatefulWidget {
  static const String routeName = '/more';
  const MoreView({Key? key}) : super(key: key);

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  late User user;
  List<AnalysisInfoSnippet> infoList = [];
  int selectedTabIndex = 1;
  List<Bundle> bundleList = [];

  handleSelectChanged(index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    user = User(
      country: 'Ghana',
      dateJoined: '30th January, 2027',
      email: 'sfquaye@ecoachsolutions.gh',
      name: 'SF Quaye',
      phoneNumber: '+233 123 456 789',
      profileImageURL: '',
    );

    infoList = [
      AnalysisInfoSnippet(
        bodyText: '19',
        footerText: 'users',
        performance: '3',
        performanceImproved: true,
        background: kAnalysisInfoSnippetBackground1,
      ),
      AnalysisInfoSnippet(
        bodyText: '3',
        footerText: 'bundles',
        performance: '3',
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground2,
      ),
      AnalysisInfoSnippet(
        bodyText: '205',
        footerText: 'ghc',
        performance: '3',
        performanceImproved: false,
        background: kAnalysisInfoSnippetBackground3,
      ),
    ];

    bundleList = [
      Bundle(name: 'JHS 1 Bundle', timeLeft: '100 days'),
      Bundle(name: 'JHS 2 Bundle', timeLeft: '100 days'),
      Bundle(name: 'JHS 3 Bundle', timeLeft: '100 days'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: kAdeoGray,
          child: Column(
            children: [
              UserProfile(user),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  top: 12.0,
                ),
                child: AnalysisInfoSnippetCardTabBar(
                  infoList: infoList,
                  subLabels: ['referrals', 'subscriptions', 'wallet'],
                  selectedIndex: selectedTabIndex,
                  onActiveTabChange: handleSelectChanged,
                  theme: 'light',
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: infoList.length,
                    itemBuilder: (context, index) {
                      return BundleListItem(
                        bundle: bundleList[index],
                        isFirstChild: index == 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BundleDownload(
                                bundle: bundleList[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BundleListItem extends StatelessWidget {
  const BundleListItem({
    required this.bundle,
    required this.isFirstChild,
    this.onTap,
  });

  final Bundle bundle;
  final bool isFirstChild;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 32.0,
          right: 20.0,
          top: 12.0,
          bottom: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: isFirstChild ? BorderSide(width: 1.0, color: kAdeoGray) : BorderSide.none,
            bottom: BorderSide(width: 1.0, color: kAdeoGray),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bundle.name,
                    style: TextStyle(
                      color: kDefaultBlack,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${bundle.timeLeft} left',
                    style: TextStyle(
                      color: kBlack38,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 32.0,
              height: 32.0,
              child: Image.asset(
                'assets/icons/arrows/arrow_right.png',
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}
