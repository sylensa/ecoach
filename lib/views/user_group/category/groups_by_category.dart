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
  List<GroupListData> groupByCategory= [];
  bool progressCodeSearch = true;
  searchGroupByCategory() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    try {
      if (isConnected) {
        groupByCategory = await GroupManagementController().getGroupsByCategory(category: properCase(widget.categoryName));
      } else {
        showNoConnectionToast(context);
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      progressCodeSearch = false;
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
        title: sText("${properCase(widget.categoryName)}",weight: FontWeight.bold),
      ),
      body: Container(
        child: Column(
          children: [
            groupByCategory.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: groupByCategory.length,
                  itemBuilder: (BuildContext context, int index){
                    return  MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        goTo(context, GroupDetails(groupData: groupByCategory[index],));
                      },
                      child: groupListWidget(groupByCategory[index])
                    );
                  }),
            ) : progressCodeSearch ? Expanded(child: Center(child: progress(),)) : Expanded(child: Center(child:sText("No groups for this category"),))
          ],
        ),
      ),
    );
  }
}
