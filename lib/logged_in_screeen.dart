import 'package:ecoach/provider/google_sign_in_provider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class LoggedInScreen extends StatelessWidget {
  GoogleSignInProvider? model;
  LoggedInScreen(GoogleSignInProvider model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage:
                  Image.network(model!.userDetailsModel!.photoURL ?? "").image,
              radius: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                Text(
                  model!.userDetailsModel!.email ?? "",
                ),
                SizedBox(height: 20),
                ActionChip(
                  label: Text("logout"),
                  onPressed: () {
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .allowUserToLogout();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
