import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/models/plan2.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/buttons/adeo_filled_button.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreItemDetailsPage extends StatefulWidget {
  const StoreItemDetailsPage({
    Key? key,
    this.itemProps,
  }) : super(key: key);
  final dynamic itemProps;

  @override
  State<StoreItemDetailsPage> createState() => _StoreItemDetailsPageState();
}

class _StoreItemDetailsPageState extends State<StoreItemDetailsPage> {
  StoreController storeController = StoreController();

  @override
  Widget build(BuildContext context) {
    StoreDetails _itemType = widget.itemProps["itemType"];
    late int _itemID;
    bool _isGroup = false;
    bool _isBundle = false;

    switch (_itemType) {
      case StoreDetails.GROUP:
        _itemID = int.parse(widget.itemProps["groupId"] ?? 0);
        _isGroup = true;
        break;
      case StoreDetails.BUNDLE:
        _itemID = int.parse(widget.itemProps["bundleId"] ?? 0);
        _isBundle = true;
        break;
      default:
        _itemID = 0;
    }

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        color: kAdeoDark,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: FutureBuilder<Plan>(
            future: storeController.getPlanDetails(context, _itemID),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kAdeoGreen4,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.data != null) {
                    Plan _plan = snapshot.data!;

                    return StoreItemDetailsPageContent(
                      _plan,
                      storeController: storeController,
                      isBundle: _isBundle,
                      isGroup: false,
                    );
                  } else {
                    return Container();
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

class StoreItemDetailsPageContent extends StatefulWidget {
  const StoreItemDetailsPageContent(
    this.item, {
    required this.storeController,
    this.isGroup = false,
    this.isBundle = false,
    Key? key,
  }) : super(key: key);

  final dynamic item;
  final StoreController storeController;
  final bool isGroup;
  final bool isBundle;

  @override
  State<StoreItemDetailsPageContent> createState() =>
      _StoreItemDetailsPageContentState();
}

class _StoreItemDetailsPageContentState
    extends State<StoreItemDetailsPageContent> {
  late Plan _plan;

  @override
  Widget build(BuildContext context) {
    StoreController storeController = widget.storeController;
    if (widget.isBundle) {
      setState(() {
        _plan = widget.item;
      });
    } else {
      // setState(() {
      //   _group = widget.item;
      // });
    }
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 42),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 42,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.only(
                                  bottom: 24,
                                ),
                                constraints: BoxConstraints(
                                  minHeight: 430,
                                ),
                                decoration: BoxDecoration(
                                  color: kAdeoDark,
                                  // borderRadius: BorderRadius.only(
                                  //   topLeft: Radius.circular(24),
                                  //   topRight: Radius.circular(24),
                                  //   bottomLeft: Radius.zero,
                                  //   bottomRight: Radius.zero,
                                  // ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: "poppins",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            width: double.maxFinite,
                                            child: Text(
                                              "${widget.item.description}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: kAdeoDark_Gray2,
                                                fontFamily: "poppins",
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          if (widget.isBundle)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Courses",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontFamily: "poppins",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 18,
                                                ),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: _plan.features!
                                                      .map(
                                                        (feature) => RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "${feature.name}",
                                                                style:
                                                                    TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              _plan.features!.indexOf(
                                                                          feature) !=
                                                                      _plan.features!
                                                                              .length -
                                                                          1
                                                                  ? TextSpan(
                                                                      text:
                                                                          "  |",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    )
                                                                  : TextSpan()
                                                            ],
                                                          ),
                                                        ),

                                                        // Container(
                                                        //   padding: EdgeInsets
                                                        //       .symmetric(
                                                        //     horizontal: 18,
                                                        //     vertical: 8,
                                                        //   ),
                                                        //   decoration:
                                                        //       BoxDecoration(
                                                        //     color: Colors.white,
                                                        //     borderRadius:
                                                        //         BorderRadius
                                                        //             .circular(
                                                        //                 8),
                                                        //   ),
                                                        //   child: Column(
                                                        //     crossAxisAlignment:
                                                        //         CrossAxisAlignment
                                                        //             .start,
                                                        //     children: [
                                                        //       Text(
                                                        //         "${feature.name}",
                                                        //       ),
                                                        //       if (feature
                                                        //               .description !=
                                                        //           null)
                                                        //         Padding(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                   .only(
                                                        //             top: 8.0,
                                                        //           ),
                                                        //           child: Text(
                                                        //             "${feature.description}",
                                                        //           ),
                                                        //         ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                      )
                                                      .toList(),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (() => storeController.showSubscriptionModal(
                  context, widget.item.name.toString(), widget.item)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: kAdeoGreen,
                child: Center(
                  child: Text(
                    "Subscribe",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            width: MediaQuery.of(context).size.width,
            color: kAdeoDark,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 24.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (() => Navigator.pop(context)),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        widget.item.name.toString().toTitleCase(),
                        style: kTwentyFourPointText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                  if (widget.isGroup && widget.item.owner != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "by ${widget.item.owner!.name}",
                          style: TextStyle(
                            fontSize: 16,
                            color: kAdeoDark_Gray2,
                            fontFamily: "poppins",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  if (widget.isGroup)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.item.membersCount != null)
                              Container(
                                margin: EdgeInsets.only(
                                  right: 24.0,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/star.svg",
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${widget.item.membersCount}",
                                      style: kTwentyFourPointText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.item.reviews != null)
                              Container(
                                margin: EdgeInsets.only(
                                  right: 24.0,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/star.svg",
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "${widget.item.reviews.toString()}",
                                      style: kTwentyFourPointText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.item.settings != null)
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/star.svg",
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  if (widget.item.settings!.access == "Paid")
                                    Text(
                                      money(
                                        double.parse(
                                          widget.item.settings!.amount
                                              .toString(),
                                        ),
                                      ),
                                      style: kTwentyFourPointText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
