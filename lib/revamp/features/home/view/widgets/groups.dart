import 'package:ecoach/controllers/store_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/manip.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/user_group/group_page/my_groups.dart';
import 'package:ecoach/widgets/buttons/adeo_text_button.dart';
import 'package:ecoach/widgets/section_heading.dart';
import 'package:ecoach/widgets/store_card.dart';
import 'package:flutter/material.dart';

class GroupClass extends StatefulWidget {
  GroupClass({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<GroupClass> createState() => _GroupClassState();
}

class _GroupClassState extends State<GroupClass> {
  List<GroupListData> _groups = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                SectionHeading('Groups'),
                SectionHeaderTextButton(
                  label: 'See More Groups',
                  onPressed: () {
                    // goTo(
                    //   context,
                    //   MyGroupsPage(
                    //     widget.user,
                    //     myGroupList: myGroupList,
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          primary: false,
          child: FutureBuilder<List<GroupListData>>(
              future: groupManagementController.getAllGroupList(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: 16,
                      height: 16,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: kAdeoGreen4,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.data != null) {
                      _groups = snapshot.data!;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _groups.map((group) {
                          if (_groups.indexOf(group) < 6) {
                            if (_groups.length - 1 != _groups.indexOf(group)) {
                              return Padding(
                                padding: EdgeInsets.only(right: 14),
                                child: StoreCard(
                                  label: group.name!.toCapitalized(),
                                  ownerName: group.owner!.name!.toCapitalized(),
                                  cardImage:
                                      "assets/images/store/store-img-1.png",
                                  onClick: () {},
                                  isLightTheme: true,
                                  imgHeight: 120,
                                ),
                              );
                            }
                            return StoreCard(
                              label: group.name!.toCapitalized(),
                              ownerName: group.owner!.name!.toCapitalized(),
                              cardImage: "assets/images/store/store-img-1.png",
                              onClick: () {},
                              isLightTheme: true,
                              imgHeight: 120,
                            );
                          }
                          return Container();
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                }
              }),
        ),
      ],
    );
  }
}

// ClassCard(
//   position: 0,
//   className: 'digital alliance',
//   instructor: 'warren walfes',
//   studentsEnrolled: 112,
//   duration: '12 days / month',
//   courseCount: 8,
//   likes: 1228,
// ),
