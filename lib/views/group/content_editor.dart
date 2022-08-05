import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/active_package_model.dart';
import 'package:ecoach/models/group_list_model.dart';
import 'package:ecoach/models/group_packages_model.dart';
import 'package:ecoach/utils/app_url.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/commission/commission_agent_page.dart';
import 'package:ecoach/views/group/group_list.dart';
import 'package:ecoach/views/group/not_content_editor.dart';
import 'package:ecoach/views/user_setup.dart';
import 'package:ecoach/widgets/toast.dart';
import 'package:ecoach/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentEditor extends StatefulWidget {
  const ContentEditor({Key? key}) : super(key: key);

  @override
  State<ContentEditor> createState() => _ContentEditorState();
}

class _ContentEditorState extends State<ContentEditor> {
  late String generatedLink = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  authorisePayment(BuildContext context, int packageId) async {
    var res = await doPost(AppUrl.groupPackagesPaymentInitialization, {
      "group_package_id": packageId,
    });
    if (res["status"]) {
      Navigator.pop(_scaffoldKey.currentContext!);
      generatedLink = res["data"]["authorization_url"];
      paymentPage(generatedLink);
    } else {
      Navigator.pop(_scaffoldKey.currentContext!);
      toastMessage(res["message"]);
    }
  }

  paymentPage(String authorizationUrl) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: authorizationUrl,
          navigationDelegate: (navigation) async {
            //Listen for callback URL
            if (navigation.url.contains('https://standard.paystack.co/close')) {
              Navigator.of(context).pop(); //close webview
            }
            if (navigation.url.contains(AppUrl.payment_callback)) {
              Navigator.of(context).pop(); //close webview
              setState(() {});
            }
            return NavigationDecision.navigate;
          },
        );
      },
    );
  }

  upgradePackageModalBottomSheet(
    context,
  ) {
    TextEditingController productKeyController = TextEditingController();
    bool isActivated = true;
    double sheetHeight = 400;
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return Container(
                  height: sheetHeight,
                  decoration: BoxDecoration(
                      color: kAdeoGray,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 5,
                        width: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                            child: sText("Upgrade Packages",
                                weight: FontWeight.bold,
                                size: 20,
                                align: TextAlign.center)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: sText("Select Your Preferred Upgrade",
                            color: kAdeoGray3,
                            weight: FontWeight.w400,
                            align: TextAlign.center),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: listGroupPackageData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showLoaderDialog(context);
                                    authorisePayment(context,
                                        listGroupPackageData[index].id!);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        sText(listGroupPackageData[index].name,
                                            color: kAdeoGray3),
                                        sText(
                                            "GHS ${listGroupPackageData[index].price}",
                                            color: Colors.black,
                                            weight: FontWeight.bold),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ));
            },
          );
        });
  }

  getGroupList() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      listGroupListData.clear();
      try {
        listGroupListData = await groupManagementController.getGroupList();
        if (listGroupListData.isNotEmpty) {
          Navigator.pop(context);
          goTo(context, GroupListPage());
        } else {
          Navigator.pop(context);
          goTo(context, GroupListPage());
        }
      } catch (e) {
        Navigator.pop(context);
        toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  getActivePackage() async {
    listActivePackageData.clear();
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      try {
        listActivePackageData =
            await groupManagementController.getActivePackage();
        if (listActivePackageData.isNotEmpty) {
          await getGroupList();
        } else {
          Navigator.pop(context);
          goTo(context, NotContentEditor());
        }
      } catch (e) {
        Navigator.pop(context);
        toastMessage("Failed");
      }
    } else {
      Navigator.pop(context);
      showNoConnectionToast(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Color(0XFF2D3E50),
            )),
        title: Text(
          "Group Management",
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0XFF2D3E50),
              height: 1.1,
              fontFamily: "Poppins"),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText("Free Editor",
                    color: Color(0xFF2A9CEA),
                    weight: FontWeight.bold,
                    align: TextAlign.center,
                    size: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText(
                    "Free editor account enables you to create only one group with a limited number of members",
                    color: kAdeoGray3,
                    weight: FontWeight.w400,
                    align: TextAlign.center),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/images/Kids reading-rafiki.png",
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showLoaderDialog(context);
                  getActivePackage();
                  // getGroupList();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF00C9B9),
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: sText("Create Group",
                      color: Colors.white,
                      weight: FontWeight.w500,
                      align: TextAlign.center,
                      size: 18),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: sText(
                    "Upgrade your editor account to experience the full power of groups",
                    color: kAdeoGray3,
                    weight: FontWeight.w400,
                    align: TextAlign.center),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  upgradePackageModalBottomSheet(_scaffoldKey.currentContext);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 30, right: 20, left: 20),
                  decoration: BoxDecoration(
                      color: Color(0xFFFFF0CF),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/system-update.png"),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Upgrade Editor Account",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFD6A843),
                            height: 1.1,
                            fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
