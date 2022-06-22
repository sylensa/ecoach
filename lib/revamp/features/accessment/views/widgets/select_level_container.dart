import 'package:ecoach/revamp/features/accessment/views/screens/selected_subject.dart';
import 'package:ecoach/models/level.dart';
import 'package:ecoach/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectLevelContainer extends StatefulWidget {
  final String image, title;
  final bool isSelected;
  final User? user;
  final Function onTap;
   SelectLevelContainer(
      {required this.image,
      required this.title,
      required this.onTap,
      this.isSelected = false,
        this.user,
      Key? key})
      : super(key: key);

  @override
  State<SelectLevelContainer> createState() => _SelectLevelContainerState();
}

class _SelectLevelContainerState extends State<SelectLevelContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        Get.bottomSheet( SelectSubjectWidget(title: widget.title,user: widget.user,));
      },
      child: Container(
        height: 223,
        width: 173,
        child: Column(
          children: [
            const SizedBox(height: 49),
            Image.asset(
              widget.image,
              height: 126,
              width: 126,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: widget.isSelected ? const Color(0xFF075591) : null,
          border: Border.all(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(22.0),
        ),
      ),
    );
  }
}
