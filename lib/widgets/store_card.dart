
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    Key? key,
    this.cardImage,
    this.description,
    this.isFeaturedTest = false,
    this.isBundle = false,
    this.label = "",
    this.imgHeight = 110,
    this.bundlePrice,
    this.bundleTasks,
    this.onClick,
    this.ownerName,
    this.isLightTheme = false,
  }) : super(key: key);
  final String label;
  final String? ownerName;
  final String? cardImage;
  final String? description;
  final dynamic bundlePrice;
  final String? bundleTasks;
  final double? imgHeight;
  final bool isFeaturedTest;
  final bool isBundle;
  final bool? isLightTheme;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    String _cardImage = cardImage ?? "assets/images/store/store-img-1.png";
    final List ellipseCount = [1, 2, 3];
    Function() _onClick = onClick ?? () {};

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onClick,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: isLightTheme! ? Colors.white : kAdeoDark_Gray,
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.hardEdge,
            constraints: BoxConstraints(minHeight: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  height: imgHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: isFeaturedTest
                      ? Stack(
                          children: [
                            Image.asset(
                              _cardImage,
                              width: double.maxFinite,
                              height: double.maxFinite,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: kAdeoDark_Green,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  "JOIN",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.asset(
                          _cardImage,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                ),
                Stack(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          maxLines: 2,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isLightTheme!
                                                ? kDefaultBlack
                                                : Colors.white,
                                            fontFamily: "Poppins",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isFeaturedTest)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "4.5",
                                                maxLines: 3,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: isLightTheme!
                                                      ? kDefaultBlack
                                                      : Colors.white,
                                                  fontFamily: "Poppins",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              SvgPicture.asset(
                                                "assets/icons/star.svg",
                                                width: 13,
                                                height: 13,
                                              ),
                                            ],
                                          )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    if (!isBundle)
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.asset(
                                              "assets/images/store/store-img-2.png",
                                              width: double.maxFinite,
                                              height: double.maxFinite,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "by ${ownerName}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isLightTheme!
                                                  ? kDefaultBlack
                                                  : kAdeoDark_Gray2,
                                              fontFamily: "Poppins",
                                            ),
                                          )
                                        ],
                                      ),
                                    if (isBundle)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            description!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isLightTheme!
                                                  ? kDefaultBlack
                                                      .withOpacity(0.5)
                                                  : Colors.white
                                                      .withOpacity(0.5),
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            bundlePrice!.toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isLightTheme!
                                                  ? kDefaultBlack
                                                  : Colors.white,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              if (!isFeaturedTest && !isBundle)
                                Container(
                                  width: 24,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: kAdeoDark_Green,
                                  ),
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isFeaturedTest)
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [...ellipseCount].map((count) {
                              return Container(
                                width: 3,
                                height: 3,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isLightTheme!
                                      ? kAdeoDark_Gray2
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
