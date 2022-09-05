import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:ecoach/views/user_group/group_activities/no_activity.dart';
import 'package:ecoach/views/user_group/group_notification/notification.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserGroupPage extends StatefulWidget {
  static const String routeName = '/user_group';
  UserGroupPage(this.user, {Key? key}) : super(key: key);
  User user;
  @override
  State<UserGroupPage> createState() => _UserGroupPageState();
}

class _UserGroupPageState extends State<UserGroupPage> {
  String searchController = "";
  bool progressCodeGroup = true;
  bool progressCodeCategory = true;
  bool progressCodeSearch = false;
  List<GroupListData> myGroupList= [];
  List<GroupListData> groupByCategory= [];
  List<GroupListData> groupBySearch= [];
  String categoryType = "lower_primary";
  String orderBy = "asc";
  String sortBy = "popularity";
  List<ListNames> sortList = [ListNames(name: "",id: ""),ListNames(name: "Popularity",id: "popularity"),ListNames(name: "Date Created",id: "date_created"),ListNames(name: "Ratings",id: "rating"),ListNames(name: "Price",id: "amount")];
  List<ListNames> categoryList = [ListNames(name: "Ages 6-8",id: "lower_primary"),ListNames(name: "Ages 9-11",id: "upper_primary"),ListNames(name: "12-14",id: "junior_high"),ListNames(name: "15-17",id: "senior_high")];
  getMyGroups() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
      if (isConnected) {
        myGroupList = await GroupManagementController().getJoinGroupList();
      } else {
        showNoConnectionToast(context);
      }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeGroup = false;
    });
  }
  getGroupsByCategories() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // try {
      if (isConnected) {
        groupByCategory = await GroupManagementController().getAllGroupList(sort: sortBy,order: orderBy);
      } else {
        showNoConnectionToast(context);
      }
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeCategory = false;
    });
  }
  searchGroup() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        groupBySearch = await GroupManagementController().searchGroupList(search: searchController);
      } else {
        showNoConnectionToast(context);
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      progressCodeSearch = true;
    });
  }
  @override
  void initState(){
    super.initState();
    getMyGroups();
    getGroupsByCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,
      body: Container(
        // padding: EdgeInsets.only(top: 2.h, bottom: 2.h, left: 2.h, right: 2.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only( bottom: 2.h, left: 2.h,),
              decoration: BoxDecoration(
                color: Color(0XFFDBF1A8),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 3.h,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  sText("Hi, Victor",size: 20,weight: FontWeight.bold),
                                  SizedBox(width: 5,),
                                  Icon(Icons.hide_image,color: Colors.yellow,)
                                ],
                              ),
                              sText("Let's start learning!",size: 16,weight: FontWeight.w400),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            goTo(context, GroupNotificationActivity(widget.user));
                          },
                          child: Container(
                            child: Image.asset("assets/images/schedule_top.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only( right: 2.h,),

                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 0,right: 0,top: 0),
                            child:  TextFormField(
                                onChanged:(value)async{
                                  if(value.isNotEmpty){
                                    setState((){
                                      searchController = value;
                                      progressCodeSearch = false;
                                    });
                                    await searchGroup();
                                  }else{
                                    setState((){
                                      searchController = value;
                                      progressCodeSearch = false;
                                    });
                                  }
                                },
                              decoration: textDecorSuffix(
                                  size: 15,
                                  icon: Icon(Icons.search,color: Colors.grey),
                                  suffIcon: Icon(Icons.filter_alt,color: Colors.white,),
                                  label: "Search for learning groups",
                                  enabled: true
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            goTo(context, NoGroupActivity(widget.user));
                          },
                            child: Image.asset("assets/images/schedule.png"),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),

            searchController.isEmpty ?
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                 Container(
                   padding: EdgeInsets.all(20),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // my groups
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             sText("My Groups",size: 16,weight: FontWeight.bold),
                             sText("See all",size: 16,color: Colors.grey[400]!),
                           ],
                         ),
                       ),
                       SizedBox(height: 10,),
                       myGroupList.isNotEmpty ?
                       Container(
                         height: 170,
                         child: ListView.builder(
                             itemCount: myGroupList.length,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               return Row(
                                 children: [
                                   Container(
                                     width: appWidth(context) * 0.7 ,
                                     padding: EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Container(
                                           padding: EdgeInsets.all(10),
                                           decoration: BoxDecoration(
                                               color: Colors.grey[100],
                                               borderRadius: BorderRadius.circular(10)
                                           ),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Icon(Icons.arrow_back_ios,color: Colors.white,),
                                               Container(
                                                 width: 150,
                                                 child: sText("Physics Assignment due",weight: FontWeight.w500,size: 14,maxLines: 1),
                                               ),
                                               Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,),
                                             ],
                                           ),
                                         ),
                                         SizedBox(height: 10,),
                                         Container(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   sText("${myGroupList[index].name}",weight: FontWeight.w500,size: 20),
                                                   SizedBox(height: 0,),
                                                   sText("by Mr. Afram Dzidefo",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                 ],
                                               ),

                                               Row(
                                                 children: [
                                                   Center(
                                                     child: SizedBox(
                                                       height: 22,
                                                       width: 22,
                                                       child: Stack(
                                                         children: [
                                                           Container(
                                                             decoration: BoxDecoration(
                                                                 color: Color(0XFF00C9B9),
                                                                 shape: BoxShape.circle
                                                             ),
                                                           ),
                                                           Center(
                                                             child: Text(
                                                               "1",
                                                               style: TextStyle(
                                                                 fontSize: 12,
                                                                 color: Colors.white,
                                                                 fontWeight: FontWeight.bold
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ],
                                           ),
                                         ),
                                         Container(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   SizedBox(height: 10,),
                                                   Container(
                                                     child: Row(
                                                       children: [
                                                         Image.asset("assets/images/user_group.png"),
                                                         SizedBox(width: 5,),
                                                         sText("${myGroupList[index].membersCount} members",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(height: 10,),
                                                   Container(
                                                     child: Row(
                                                       children: [
                                                         Image.asset("assets/images/calendar.png"),
                                                         SizedBox(width: 5,),
                                                         sText("20 days remaining",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
                                                       ],
                                                     ),
                                                   ),
                                                   SizedBox(height: 10,),
                                                 ],
                                               ),
                                               Container(
                                                 padding: EdgeInsets.all(10),
                                                 child: Icon(Icons.arrow_forward),
                                                 decoration: BoxDecoration(
                                                   color: Colors.grey[200],
                                                   borderRadius: BorderRadius.circular(10)
                                                 ),
                                               )
                                             ],
                                           ),
                                         )

                                       ],
                                     ),
                                   ),
                                   SizedBox(width: 10,),
                                 ],
                               );
                             }),
                       ) : !progressCodeGroup ? Center(child: sText("Empty group"),) : Center(child: progress(),),
                       // categories
                       SizedBox(height: 30,),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             sText("Categories",size: 16,weight: FontWeight.bold),
                             sText("See all",size: 16,color: Colors.grey[400]!),
                           ],
                         ),
                       ),
                       Container(
                         height: 70,
                         child: ListView.builder(
                             itemCount: categoryList.length,
                             padding: EdgeInsets.zero,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               return Row(
                                 children: [
                                   Container(
                                       width: 130 ,
                                       padding: EdgeInsets.all(10),
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         children: [
                                          Image.asset("assets/images/${categoryList[index].id}.png",width: 20),
                                           SizedBox(width: 10,),
                                           sText("${categoryList[index].name}",size: 16,weight: FontWeight.bold),
                                         ],
                                       )
                                   ),
                                   SizedBox(width: 10,),
                                 ],
                               );
                             }),
                       ),
                       SizedBox(height: 0,),
                     ],
                   ),
                 ),
                 Container(
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                   ),
                   child: Column(
                     children: [
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 20),
                         height: 50,
                         child: ListView.builder(
                           padding: EdgeInsets.zero,
                             itemCount: sortList.length,
                             shrinkWrap: true,
                             scrollDirection: Axis.horizontal,
                             itemBuilder: (BuildContext context, int index){
                               if(index == 0){
                                 return Row(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                       decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(20),
                                           border: Border.all(color: Colors.white)
                                       ),
                                       child: Image.asset("assets/images/up-and-down-arrow.png"),

                                     ),
                                     SizedBox(width: 10,),
                                   ],
                                 );
                               }
                               return Row(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(20),
                                         border: Border.all(color: Colors.black)
                                     ),
                                     child: sText("${sortList[index].name}",size: 14,weight: FontWeight.normal,align: TextAlign.center),

                                   ),
                                   SizedBox(width: 5,),
                                 ],
                               );
                             }),
                       ),
                       Container(
                         color: Colors.grey[400],
                         width: appWidth(context),
                         height: 1,
                       ),
                       SizedBox(height: 10,),
                       for(int i =0; i < groupByCategory.length; i++)
                         MaterialButton(
                           padding: EdgeInsets.zero,
                           onPressed: (){
                             goTo(context, GroupDetails(widget.user));
                           },
                           child: Container(
                             padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                             margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                             decoration: BoxDecoration(
                               color: Color(0XFFF5F5F5),
                               borderRadius: BorderRadius.circular(10)
                             ),
                             child: Row(
                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   child: Image.asset("assets/images/fCvBipe.png"),
                                 ),
                                 SizedBox(width: 5,),
                                 Container(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         child: Row(
                                           children: [
                                             Container(
                                               child: sText("${groupByCategory[i].name}",size: 14,weight: FontWeight.bold),
                                             ),
                                             SizedBox(width: 5,),
                                             Container(
                                               child: sText("by Afram Dzidefo",size: 10,weight: FontWeight.normal,color: Colors.grey),
                                             ),
                                           ],
                                         ),
                                       ),
                                       Row(
                                         children: [
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Icon(Icons.groups,color: Colors.grey,size: 14,),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("${groupByCategory[i].settings}",size: 10,weight: FontWeight.normal,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           SizedBox(width: 5,),
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Icon(Icons.star,color: Colors.orange,size: 14,),
                                                 ),
                                                 SizedBox(width: 0,),
                                                 Container(
                                                   child: sText("4.0",size: 10,weight: FontWeight.w400,),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("(200 reviews)",size: 10,weight: FontWeight.normal,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           SizedBox(width: 5,),
                                           Container(
                                             child: Row(
                                               children: [
                                                 Container(
                                                   child: Image.asset("assets/images/label.png"),
                                                 ),
                                                 SizedBox(width: 5,),
                                                 Container(
                                                   child: sText("${groupByCategory[i].settings!.settings!.currency} ${groupByCategory[i].settings!.settings!.amount}",size: 10,weight: FontWeight.bold,),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                                 Expanded(child: Container()),
                                 Container(
                                   padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                   child: sText("JOIN",color: Colors.white,weight: FontWeight.bold),
                                   decoration: BoxDecoration(
                                       color: Colors.orange,
                                       borderRadius: BorderRadius.circular(10)
                                   ),
                                 )
                               ],
                             ),
                           ),
                         )
                     ],
                   ),
                 )
                ],
              ),
            ) :
                groupBySearch.isNotEmpty ?
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index){
                      return MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          goTo(context, GroupDetails(widget.user));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                              color: Color(0XFFF5F5F5),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Image.asset("assets/images/fCvBipe.png"),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: sText("${groupBySearch[index].name}",size: 14,weight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            child: sText("by Afram Dzidefo",size: 10,weight: FontWeight.normal,color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(Icons.groups,color: Colors.grey,size: 14,),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                child: sText("${groupBySearch[index].membersCount}",size: 10,weight: FontWeight.normal,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(Icons.star,color: Colors.orange,size: 14,),
                                              ),
                                              SizedBox(width: 0,),
                                              Container(
                                                child: sText("${groupBySearch[index].rating}",size: 10,weight: FontWeight.w400,),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                child: sText("(${groupBySearch[index].reviews} reviews)",size: 10,weight: FontWeight.normal,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Image.asset("assets/images/label.png"),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                child: sText("${groupBySearch[index].settings!.settings!.currency} ${groupBySearch[index].settings!.settings!.amount}",size: 10,weight: FontWeight.bold,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                child: sText("JOIN",color: Colors.white,weight: FontWeight.bold),
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                  }),
                ):
                groupBySearch.isEmpty && progressCodeSearch ?
                Expanded(child: Center(child: sText("Empty result"),)) :
                 Expanded(child: Center(child: progress(),))
          ],
        ),

      ),

    );
  }
}
