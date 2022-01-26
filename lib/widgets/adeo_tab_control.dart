import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class AdeoTabControl extends StatefulWidget {
  const AdeoTabControl({
    required this.tabs,
    this.tabPages,
    this.onPageChange,
    this.variant = 'default',
    Key? key,
  }) : super(key: key);

  final List<String> tabs;
  final List<Widget>? tabPages;
  final String variant;
  final Function? onPageChange;

  @override
  _AdeoTabControlState createState() => _AdeoTabControlState();
}

class _AdeoTabControlState extends State<AdeoTabControl> {
  int currentPageNumber = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  changePage(int page) {
    setState(() {
      currentPageNumber = page;
      pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
    if (widget.onPageChange != null) widget.onPageChange!(page);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (widget.variant.toUpperCase() == 'SQUARE')
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.tabs
                    .map(
                      (tab) => AdeoSquareTabButton(
                        onTap: changePage,
                        text: tab,
                        pageNumber: widget.tabs.indexOf(tab),
                        count: widget.tabs.length,
                        isSelected:
                            currentPageNumber == widget.tabs.indexOf(tab),
                      ),
                    )
                    .toList(),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.tabs
                    .map(
                      (tab) => AdeoTabButton(
                        variant: widget.variant,
                        onTap: changePage,
                        text: tab,
                        pageNumber: widget.tabs.indexOf(tab),
                        count: widget.tabs.length,
                        isSelected:
                            currentPageNumber == widget.tabs.indexOf(tab),
                      ),
                    )
                    .toList(),
              ),
            ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (page) {
                setState(() {
                  currentPageNumber = page;
                });
              },
              children: widget.tabPages!,
            ),
          ),
        ],
      ),
    );
  }
}

class AdeoSquareTabButton extends StatelessWidget {
  const AdeoSquareTabButton({
    required this.text,
    required this.onTap,
    required this.pageNumber,
    required this.count,
    this.isSelected: false,
    Key? key,
  }) : super(key: key);

  final String text;
  final int pageNumber;
  final bool isSelected;
  final int count;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Feedback.wrapForTap(() {
        onTap(pageNumber);
      }, context),
      child: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 300),
        height: 48.0,
        padding: EdgeInsets.only(left: 28.0, right: 28.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? kAdeoGray2 : Colors.white,
              width: isSelected ? 3 : 1.5,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text.toTitleCase(),
            style: TextStyle(
              color: isSelected ? Colors.black : Color(0x80000000),
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class AdeoTabButton extends StatelessWidget {
  const AdeoTabButton({
    required this.text,
    required this.onTap,
    required this.pageNumber,
    required this.count,
    this.isSelected: false,
    this.variant: 'default',
    Key? key,
  }) : super(key: key);

  final String text;
  final int pageNumber;
  final bool isSelected;
  final String variant;
  final int count;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: Feedback.wrapForTap(() {
            onTap(pageNumber);
          }, context),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn,
            height: 40.0,
            padding: EdgeInsets.only(left: 28.0, right: 28.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft:
                    pageNumber == 0 ? Radius.circular(24) : Radius.circular(0),
                bottomLeft:
                    pageNumber == 0 ? Radius.circular(24) : Radius.circular(0),
                topRight: pageNumber == count - 1
                    ? Radius.circular(24)
                    : Radius.circular(0),
                bottomRight: pageNumber == count - 1
                    ? Radius.circular(24)
                    : Radius.circular(0),
              ),
              color: variant.toUpperCase() == 'DEFAULT'
                  ? isSelected
                      ? Color(0xFF2589CE)
                      : Color(0xFF2A9CEA)
                  : isSelected
                      ? Colors.black
                      : Color(0x88000000),
            ),
            child: Center(
              child: Text(
                text.toTitleCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xB3FFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: isSelected ? 15 : 12,
                ),
              ),
            ),
          ),
        ),
        if (pageNumber != count - 1)
          Container(
            width: 0.5,
            color: Color(0x80000000),
          )
      ],
    );
  }
}
