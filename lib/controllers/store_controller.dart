import 'package:ecoach/api/api_call.dart';
import 'package:ecoach/models/plan.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:flutter/material.dart';

class StoreController extends ChangeNotifier {
  List tags = [
    {
      "id": "1",
      "label": "English",
    },
    {
      "id": "2",
      "label": "Mathematics",
    },
    {
      "id": "3",
      "label": "Physics",
    },
    {
      "id": "4",
      "label": "Social Studies",
    },
    {
      "id": "5",
      "label": "Integrated Science",
    },
    {
      "id": "6",
      "label": "Chemistry",
    },
    {
      "id": "7",
      "label": "Biology",
    },
  ];
  // List<Group> groups = [];
  List<dynamic> groups = [];

  List featuredTests = [
    {
      "id": "1",
      "testName": "English 1.0",
      "imgUrl": "assets/images/store/store-img-4.png",
    },
    {
      "id": "2",
      "testName": "Speed Test",
      "imgUrl": "assets/images/store/store-img-3.png",
    },
  ];

  Future<List<dynamic>> getGroups(BuildContext context) async {
    var response = await ApiCall<dynamic>(
      AppUrl.groups,
      params: {
        "sort": "popularity",
        "order": "asc",
      },
      create: (dataItem) {
        // return Group.fromJson(dataItem);
      },
    ).get(context);
    groups = response;

    return response;
  }

  Future<dynamic> getGroupDetail(BuildContext context, int groupId) async {
    // var response = await ApiCall<dynamic>(
    //   "${AppUrl.getGroupDetail}/${groupId}",
    //   isList: false,
    //   create: (dataItem) {
    //     return Group.fromJson(dataItem);
    //   },
    // ).get(context);

    // return response;
    return [];
  }

  Future<List<Plan>> getPlans(BuildContext context) async {
    var response = await ApiCall<Plan>(
      AppUrl.plans,
      create: (dataItem) {
        return Plan.fromJson(dataItem);
      },
    ).get(context);
    return response;
  }

  // showSubscriptionModal(BuildContext context, String bundleName, Plan plan) {
  //   return showDialogWithBlur(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     child: Container(
  //       padding: EdgeInsets.only(
  //         top: 44,
  //         right: 44,
  //         bottom: 42,
  //         left: 44,
  //       ),
  //       constraints: BoxConstraints(
  //           maxWidth: Responsive.isDesktop(context) ? 900 : 800,
  //           maxHeight: 800),
  //       decoration: BoxDecoration(
  //         color: kAdeoRoyalBlue,
  //         borderRadius: BorderRadius.circular(
  //           kAdeoBorderRadiusValueLg,
  //         ),
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 bundleName,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                   fontFamily: 'PoppinsSemiBold',
  //                 ),
  //               ),
  //               IconButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 iconSize: 15,
  //                 icon: Image.asset(
  //                   'assets/icons/close_red.png',
  //                   height: 15,
  //                   width: 15,
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //             ],
  //           ),
  //           SizedBox(
  //             height: 42,
  //           ),
  //           FutureBuilder<User?>(
  //             future: UserPreferences().getUser(),
  //             builder: (context, snapshot) {
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.none:
  //                 case ConnectionState.waiting:
  //                   return SizedBox(
  //                     width: 18,
  //                     height: 18,
  //                     child: Container(
  //                       width: 60,
  //                       height: 60,
  //                       child: CircularProgressIndicator(
  //                         color: kAdeoGreen4,
  //                         strokeWidth: 2,
  //                       ),
  //                     ),
  //                   );
  //                 default:
  //                   if (snapshot.hasError) {
  //                     return Container();
  //                   } else if (snapshot.data != null) {
  //                     User user = snapshot.data!;
  //                     return Expanded(
  //                       child: SingleChildScrollView(
  //                         child: SubscribeToPlan(
  //                           user,
  //                           plan,
  //                           key: UniqueKey(),
  //                         ),
  //                       ),
  //                     );
  //                   } else {
  //                     return Container();
  //                   }
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
