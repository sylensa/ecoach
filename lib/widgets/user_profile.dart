import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/widgets/adeo_outlined_button.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile(this.user);

  final UserInfo user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFCEFFE7),
                        borderRadius: BorderRadius.circular(64.0),
                        border: Border.all(
                          width: 2.0,
                          color: Color(0xFF00C664),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 32.0,
                        backgroundColor: Colors.redAccent,
                        child: Text(user.initials ?? ""),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      width: (MediaQuery.of(context).size.width - 64) * .3,
                      child: Text(
                        user.name,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: kDefaultBlack,
                          height: 1.1,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 32.0),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 1.0,
                          color: Color(0x28707070),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        DetailStrip(text: user.email, imageURL: 'envelope'),
                        SizedBox(height: 6),
                        DetailStrip(text: user.phoneNumber, imageURL: 'phone'),
                        SizedBox(height: 6),
                        DetailStrip(text: user.country, imageURL: 'flag'),
                        SizedBox(height: 6),
                        DetailStrip(
                            text: user.dateJoined.split(' ')[0],
                            imageURL: 'date'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Divider(),
            SizedBox(height: 4.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: AdeoOutlinedButton(
                size: Sizes.small,
                label: 'Logout',
                color: kAdeoBlue,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return Logout();
                  }), (route) => false);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailStrip extends StatelessWidget {
  const DetailStrip({
    required this.text,
    required this.imageURL,
  });

  final String text;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 4.0),
            Container(
              width: 12.0,
              child: Image.asset(
                'assets/icons/$imageURL.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Container(
            child: Text(
              text,
              softWrap: true,
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 13.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class UserInfo {
  UserInfo({
    required this.name,
    this.profileImageURL,
    this.initials,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.dateJoined,
  });

  final String name;
  String? profileImageURL;
  String? initials;
  final String email;
  final String phoneNumber;
  final String country;
  final String dateJoined;
}
