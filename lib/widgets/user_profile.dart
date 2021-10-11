import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile(this.user);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.0),
        child: Row(
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
                    // Quaye, you can use the backgroundImage property
                    // to insert the image
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: kDefaultBlack,
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
                      color: Color(0x4F707070),
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
                    DetailStrip(text: user.dateJoined, imageURL: 'date'),
                  ],
                ),
              ),
            ),
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
      children: [
        Container(
          width: 12.0,
          child: Image.asset(
            'assets/icons/$imageURL.png',
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Container(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: kDefaultBlack,
                fontSize: 12.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class User {
  const User({
    required this.name,
    required this.profileImageURL,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.dateJoined,
  });

  final String name;
  final String profileImageURL;
  final String email;
  final String phoneNumber;
  final String country;
  final String dateJoined;
}
