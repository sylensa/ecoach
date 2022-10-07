import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/views/user_group/category/categories.dart';
import 'package:ecoach/views/user_group/category/groups_by_category.dart';
import 'package:ecoach/views/user_group/group_activities/group_activity.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:ecoach/views/user_group/group_activities/no_activity.dart';
import 'package:ecoach/views/user_group/group_notification/notification.dart';
import 'package:ecoach/views/user_group/group_page/my_groups.dart';
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
        myGroupList.clear();
        myGroupList = await GroupManagementController().getJoinGroupList();
      } else {
        showNoConnectionToast(context);
      }

      print("myGroupList:${myGroupList.length}");
    // } catch (e) {
    //   print(e.toString());
    // }

    setState(() {
      progressCodeGroup = false;
    });
  }
  getGroupsByCategories(String sortBy,String orderBy) async {
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
    myGroupList.clear();
    getMyGroups();
    getGroupsByCategories(sortBy,orderBy);
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
                                  sText("Hi, ${widget.user.name}",size: 20,weight: FontWeight.bold),
                                  SizedBox(width: 5,),
                                  Icon(Icons.hide_image,color: Colors.yellow,)
                                ],
                              ),
                              sText("Let's start learning!",size: 16,weight: FontWeight.w400),
                            ],
                          ),
                        ),
                        Container(
                          child: Image.asset("assets/images/schedule_top.png"),
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
                                  groupBySearch.clear();
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
                          onTap: ()async{
                            await goTo(context, GroupNotificationActivity(widget.user,));
                            setState(() {

                            });
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
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             sText("My Groups",size: 16,weight: FontWeight.bold),
                             GestureDetector(
                               onTap: (){
                                 goTo(context, MyGroupsPage(widget.user,myGroupList: myGroupList,));
                               },
                                 child: sText("See all",size: 16,color: Colors.grey[400]!),
                             ),
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
                               return GestureDetector(
                                 onTap: (){
                                   goTo(context, GroupActivity(widget.user,groupData: myGroupList[index]));
                                 },
                                 child: Row(
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
                                                   child: sText("${myGroupList[index].currentTest != null ? myGroupList[index].currentTest!.name : "No testing available"}",weight: FontWeight.w500,size: 14,maxLines: 1),
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
                                                     sText("by ${myGroupList[index].owner!.name}",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
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
                                                           sText(myGroupList[index].endDate != null ? "${DateTime.parse(myGroupList[index].endDate.toString()).difference(DateTime.now()).inDays.toString()} days remaining" : "No Expiration",weight: FontWeight.w500,size: 12,color: Colors.grey[400]!),
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
                                 ),
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
                             GestureDetector(
                               onTap: (){
                                 goTo(context, CategoriesPage(widget.user));
                               },
                                 child: sText("See all",size: 16,color: Colors.grey[400]!),
                             ),
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
                               return MaterialButton(
                                 padding: EdgeInsets.zero,
                                 onPressed: (){
                                   List cat = categoryList[index].id.split("_");
                                   goTo(context, CategoryGroupsPage(widget.user,categoryName: cat.join(" "),));
                                 },
                                 child: Row(
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
                                 ),
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
                                 return GestureDetector(
                                   onTap: ()async{
                                     setState((){
                                       if(orderBy == "asc"){
                                         orderBy = "desc";
                                       }else{
                                         orderBy = "asc";
                                       }
                                       // sortBy = sortList[index].id;
                                       groupByCategory.clear();
                                     });
                                     await getGroupsByCategories(sortList[index].id,orderBy);
                                   },
                                   child: Row(
                                     children: [
                                       Container(
                                         padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                         decoration: BoxDecoration(
                                             color:  orderBy == "desc" ? Color(0XFF2D3E50) : Colors.white,
                                             borderRadius: BorderRadius.circular(20),
                                             border: Border.all(color: Colors.white)
                                         ),
                                         child: Image.asset("assets/images/up-and-down-arrow.png",color: orderBy == "desc" ? Colors.white : Colors.grey,),

                                       ),
                                       SizedBox(width: 10,),
                                     ],
                                   ),
                                 );
                               }
                               return MaterialButton(
                                 padding: EdgeInsets.zero,
                                 onPressed: ()async{
                                   setState((){
                                     sortBy = sortList[index].id;
                                     groupByCategory.clear();
                                   });
                                   await getGroupsByCategories(sortList[index].id,orderBy);
                                 },
                                 child: Row(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                       decoration: BoxDecoration(
                                           color: sortBy == sortList[index].id ? Color(0XFF2D3E50)  : Colors.white,
                                           borderRadius: BorderRadius.circular(20),
                                           border: Border.all(color: Colors.black)
                                       ),
                                       child: sText("${sortList[index].name}",size: 14,weight: FontWeight.normal,align: TextAlign.center,color: sortBy == sortList[index].id ? Colors.white : Color(0XFF2D3E50)),

                                     ),
                                     SizedBox(width: 5,),
                                   ],
                                 ),
                               );
                             }),
                       ),
                       Container(
                         color: Colors.grey[400],
                         width: appWidth(context),
                         height: 1,
                       ),
                       SizedBox(height: 10,),
                       groupByCategory.isNotEmpty ?
                      Column(
                        children: [
                          for(int i =0; i < groupByCategory.length; i++)
                            MaterialButton(
                              padding: EdgeInsets.zero,
                              onPressed: ()async{
                                if(groupByCategory[i].isMember! == 1){
                                  goTo(context, GroupActivity(widget.user,groupData: groupByCategory[i]));
                                }else{
                                  GroupListData groupList =  await goTo(context, GroupDetails(groupData: groupByCategory[i],));
                                  groupByCategory[i] = groupList;
                                }
                                setState((){

                                });
                              },
                              child: groupListWidget(groupByCategory[i]),
                            )
                        ],
                      ) : Container(
                         height: 100,
                           child: Center(child: progress(),),
                       )
                     ],
                   ),
                 )
                ],
              ),
            ) :
                groupBySearch.isNotEmpty ?
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: groupBySearch.length,
                        itemBuilder: (BuildContext context, int index){
                        return    MaterialButton(
                          padding: EdgeInsets.zero,
                          onPressed: ()async{
                            if(groupBySearch[index].isMember! == 1){
                              goTo(context, GroupActivity(widget.user,groupData: groupBySearch[index]));
                            }else{
                            GroupListData groupList =  await goTo(context, GroupDetails(groupData: groupBySearch[index],));
                            groupBySearch[index] = groupList;
                            }
                            setState((){
                            });
                          },
                          child:groupListWidget(groupBySearch[index]),
                        );
                    }),
                  ),
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
