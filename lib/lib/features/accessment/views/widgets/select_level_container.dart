import 'package:ecoach/lib/features/accessment/views/screens/selected_subject.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectLevelContainer extends StatelessWidget {
  final String image, title;
  final bool isSelected;
  final Function onTap;
  const SelectLevelContainer(
      {required this.image,
      required this.title,
      required this.onTap,
      this.isSelected = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        Get.bottomSheet(const SelectSubjectWidget());
      },
      child: Container(
        height: 223,
        width: 173,
        child: Column(
          children: [
            const SizedBox(height: 49),
            Image.asset(
              image,
              height: 126,
              width: 126,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF075591) : null,
          border: Border.all(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(22.0),
        ),
      ),
    );
  }
}
