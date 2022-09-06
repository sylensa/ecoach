import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/revamp/core/utils/app_colors.dart';
import 'package:ecoach/views/user_group/category/groups_by_category.dart';
import 'package:ecoach/views/user_group/group_page/group_details.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  static const String routeName = '/user_group';
  CategoriesPage(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<ListNames> categoryList = [ListNames(name: "Ages 6-8",id: "lower_primary"),ListNames(name: "Ages 9-11",id: "upper_primary"),ListNames(name: "12-14",id: "junior_high"),ListNames(name: "15-17",id: "senior_high")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHomeBackgroundColor,

      appBar: AppBar(
        backgroundColor: kHomeBackgroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        elevation: 0,
        title: sText("Categories",weight: FontWeight.bold),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 10),
        child: Column(
          children: [
            Expanded(
              child:  GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3/2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        goTo(context, CategoryGroupsPage(widget.user));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 150 ,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/${categoryList[index].id}.png",width: 20),
                                  SizedBox(height: 10,),
                                  sText("${categoryList[index].name}",size: 16,weight: FontWeight.bold),
                                ],
                              )
                          ),
                          SizedBox(width: 10,),
                        ],
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
