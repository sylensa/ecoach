
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdeoTextBoxDark extends StatelessWidget {
  const AdeoTextBoxDark(
      {this.placeholder,
        this.header,
        this.onChanged,
        this.obscureText = false,
        this.textInputType = TextInputType.text,
        this.error,
        this.size = Sizes.small,
        this.validator,
        this.onSaved,
        this.backgroundColor,
        this.borderColor,
        this.errorBackgroundColor,
        this.borderRadius,
        this.inputFormatters,
        Key? key})
      : super(key: key);

  final Function? onChanged;
  final String? placeholder;
  final String? header;
  final bool obscureText;
  final TextInputType textInputType;
  final dynamic error;
  final Sizes size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? errorBackgroundColor;
  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final validator;
  final onSaved;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius:
      BorderRadius.circular(borderRadius != null ? borderRadius! + 1 : 5),
      clipBehavior: Clip.antiAlias,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          color: errorBackgroundColor ?? backgroundColor ?? kInactiveOnDarkMode,
        ),
        child: TextFormField(
          inputFormatters: inputFormatters,
          cursorColor: Colors.white,
          style: TextStyle(
            color: Colors.white,
            fontSize: size == Sizes.large
                ? 32
                : size == Sizes.medium
                ? 24
                : size == Sizes.small
                ? 14
                : 16,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor ?? kInactiveOnDarkMode,
            hintText: placeholder,
            hintStyle: TextStyle(color: kAdeoWhiteAlpha50),
            contentPadding: EdgeInsets.symmetric(
              horizontal: size == Sizes.large
                  ? 32
                  : size == Sizes.medium
                  ? 24
                  : size == Sizes.small
                  ? 14
                  : 16,
              vertical: size == Sizes.large
                  ? 32
                  : size == Sizes.medium
                  ? 24
                  : size == Sizes.small
                  ? 14
                  : 16,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: error != null ? Colors.red : borderColor ?? kAdeoGreen,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: error != null
                    ? Colors.red
                    : borderColor ?? kInputBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
            ),
            errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onSaved: onSaved,
          validator: validator,
        ),
      ),
    );
  }
}
