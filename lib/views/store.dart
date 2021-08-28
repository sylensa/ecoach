import 'dart:developer';

import 'package:ecoach/controllers/subscribe_controller.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/shared_preference.dart';
import 'package:ecoach/widgets/appbar.dart';
import 'package:ecoach/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'subscribe.dart';

class StorePage extends StatefulWidget {
  static const String routeName = '/store';
  final User user;
  StorePage(this.user);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  SubscribeController subscribeController = Get.put(SubscribeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: BaseAppBar(
        context,
        "Store",
        user: widget.user,
      ),
      drawer: AppDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Subscriptions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 4),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new GridTile(
                        header: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bundle name",
                            style: TextStyle(backgroundColor: Colors.amber),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SubscribePage(widget.user)));
                          },
                          child: Card(
                            color: Colors.yellow,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 150,
                                    child: Icon(Icons.home_outlined)),
                                Spacer(),
                                Text("footer name"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
