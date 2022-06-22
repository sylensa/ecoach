import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final  TextInputType textInputType;
  final String hintText;
  final String labelText;
  final String title;
  final bool obscureText ;
  const CustomTextField(
      {required this.controller,
      required this.hintText,
      required this.labelText,
      required this.title,
      required this.textInputType,
      required this.obscureText,

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFFB9B9B9,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
