// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:ecoach/utils/style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInput extends StatefulWidget {
  PinInput({
    required this.onChanged,
    required this.length,
    this.autoFocus = false,
    this.focusNode,
    this.textColor = kDefaultBlack,
  });

  final onChanged;
  final int length;
  final bool autoFocus;
  final FocusNode? focusNode;
  final Color textColor;

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enablePinAutofill: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      appContext: context,
      pastedTextStyle: TextStyle(color: kDefaultBlack),
      length: widget.length,
      obscureText: false,
      animationType: AnimationType.fade,
      validator: (v) {
        if (v!.length == 0) {
          return "Please enter a valid number";
        } else {
          return null;
        }
      },
      pinTheme: PinTheme(
        fieldHeight: 96,
        fieldWidth: 56,
        borderWidth: 4.0,
        activeColor: widget.textColor,
        inactiveColor: widget.textColor,
        selectedColor: widget.textColor,
        inactiveFillColor: widget.textColor,
        activeFillColor: widget.textColor,
        selectedFillColor: widget.textColor,
        fieldOuterPadding: EdgeInsets.all(0),
        errorBorderColor: hasError ? Colors.red : kDefaultBlack,
      ),
      enableActiveFill: false,
      hintCharacter: '0',
      hintStyle: TextStyle(color: widget.textColor),
      cursorColor: widget.textColor,
      animationDuration: Duration(milliseconds: 300),
      textStyle: kPinInputTextStyle,
      controller: textEditingController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9 ]'))],
      onCompleted: (v) {},
      onChanged: (value) {
        value = value.replaceAll(" ", "0");
        print(value);
        widget.onChanged(value);
      },
      beforeTextPaste: (text) => true,
    );
  }
}
