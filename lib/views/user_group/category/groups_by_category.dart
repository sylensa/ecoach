import 'package:ecoach/controllers/group_management_controller.dart';
import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CategoryGroupsPage extends StatefulWidget {
  static const String routeName = '/user_group';
  String categoryName;
  CategoryGroupsPage({Key? key,this.categoryName = ''}) : super(key: key);

  @override
  State<CategoryGroupsPage> createState() => _CategoryGroupsPageState();
}

class _CategoryGroupsPageState extends State<CategoryGroupsPage> {
  List<GroupListData> groupBySearch= [];
  bool progressCodeSearch = false;
  searchGroupByCategory() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        groupBySearch = await GroupManagementController().searchGroupList(category: properCase(widget.categoryName));
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
    searchGroupByCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        elevation: 0,
        title: sText("Category Name",weight: FontWeight.bold),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index){
                    return  MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        goTo(context, GroupDetails());
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
                                          child: sText("Adeo Group",size: 14,weight: FontWeight.bold),
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
                                              child: sText("1,200",size: 10,weight: FontWeight.normal,),
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
                                              child: sText("GHS 99",size: 10,weight: FontWeight.bold,),
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
            )
          ],
        ),
      ),
    );
  }
}
