// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class Otp extends StatefulWidget {
//   final String email;
//   final String Email;
//   final bool isGuestCheckOut;

//   const Otp({
//     Key key,
//     required this.email,
//     this.Email = "",
//     this.isGuestCheckOut = false,
//   }) : super(key: key);

//   @override
//   _OtpState createState() => _OtpState();
// }

// class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
//   // Constants
//   final int time = 30;
//   AnimationController? _controller;

//   // Variables
//   Size? _screenSize;
//   int? _currentDigit;
//   int _firstDigit = 0;
//   int _secondDigit = 0;
//   int _thirdDigit = 0;
//   int _fourthDigit = 0;

//   Timer? timer;
//   int? totalTimeInSeconds;
//   bool? _hideResendButton;

//   String userName = "";
//   bool didReadNotifications = false;
//   int unReadNotificationsCount = 0;

//   // Returns "Appbar"
//   get _getAppbar {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       leading: InkWell(
//         borderRadius: BorderRadius.circular(30.0),
//         child: Icon(
//           Icons.arrow_back,
//           color: Colors.black54,
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//       centerTitle: true,
//     );
//   }

//   // Return "Verification Code" label
//   get _getVerificationCodeLabel {
//     return Text(
//       "Verification Code",
//       textAlign: TextAlign.center,
//       style: TextStyle(
//           fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
//     );
//   }

//   // Return "Email" label
//   get _getEmailLabel {
//     return Text(
//       "Please enter the OTP sent\non your registered Email ID.",
//       textAlign: TextAlign.center,
//       style: TextStyle(
//           fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
//     );
//   }

//   // Return "OTP" input field
//   get _getInputField {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         _otpTextField(_firstDigit),
//         _otpTextField(_secondDigit),
//         _otpTextField(_thirdDigit),
//         _otpTextField(_fourthDigit),
//       ],
//     );
//   }

//   // Returns "OTP" input part
//   get _getInputPart {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         _getVerificationCodeLabel,
//         _getEmailLabel,
//         _getInputField,
//         // _hideResendButton ? _getTimerText : _getResendButton,
//         _getOtpKeyboard
//       ],
//     );
//   }

//   // Returns "Timer" label
//   get _getTimerText {
//     return Container(
//       height: 32,
//       child: Offstage(
//         // offstage: !_hideResendButton,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(Icons.access_time),
//             SizedBox(
//               width: 5.0,
//             ),
//             OtpTimer(_controller!, 15.0, Colors.black)
//           ],
//         ),
//       ),
//     );
//   }

//   // Returns "Resend" button
//   get _getResendButton {
//     return InkWell(
//       child: Container(
//         height: 32,
//         width: 120,
//         decoration: BoxDecoration(
//             color: Colors.black,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(32)),
//         alignment: Alignment.center,
//         child: Text(
//           "Resend OTP",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//       ),
//       onTap: () {
//         // Resend you OTP via API or anything
//       },
//     );
//   }

//   // Returns "Otp" keyboard
//   get _getOtpKeyboard {
//     return Container(
//         height: _screenSize!.width - 80,
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "1",
//                       onPressed: () {
//                         _setCurrentDigit(1);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "2",
//                       onPressed: () {
//                         _setCurrentDigit(2);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "3",
//                       onPressed: () {
//                         _setCurrentDigit(3);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "4",
//                       onPressed: () {
//                         _setCurrentDigit(4);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "5",
//                       onPressed: () {
//                         _setCurrentDigit(5);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "6",
//                       onPressed: () {
//                         _setCurrentDigit(6);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   _otpKeyboardInputButton(
//                       label: "7",
//                       onPressed: () {
//                         _setCurrentDigit(7);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "8",
//                       onPressed: () {
//                         _setCurrentDigit(8);
//                       }),
//                   _otpKeyboardInputButton(
//                       label: "9",
//                       onPressed: () {
//                         _setCurrentDigit(9);
//                       }),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   SizedBox(
//                     width: 80.0,
//                   ),
//                   _otpKeyboardInputButton(
//                       label: "0",
//                       onPressed: () {
//                         _setCurrentDigit(0);
//                       }),
//                   _otpKeyboardActionButton(
//                       label: Icon(
//                         Icons.backspace,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           if (_fourthDigit != null) {
//                             _fourthDigit;
//                           } else if (_thirdDigit != null) {
//                             _thirdDigit = 0;
//                           } else if (_secondDigit != null) {
//                             _secondDigit;
//                           } else if (_firstDigit != null) {
//                             _firstDigit;
//                           }
//                         });
//                       }),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }

//   // Overridden methods
//   @override
//   void initState() {
//     totalTimeInSeconds = time;
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: time))
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.dismissed) {
//               setState(() {
//                 _hideResendButton = !_hideResendButton!;
//               });
//             }
//           });
//     _controller!
//         .reverse(from: _controller!.value == 0.0 ? 1.0 : _controller!.value);
//     _startCountdown();
//   }

//   @override
//   void dispose() {
//     _controller!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: _getAppbar,
//       backgroundColor: Colors.white,
//       body: Container(
//         width: _screenSize!.width,
// //        padding:  EdgeInsets.only(bottom: 16.0),
//         child: _getInputPart,
//       ),
//     );
//   }

//   // Returns "Otp custom text field"
//   Widget _otpTextField(int digit) {
//     return Container(
//       width: 35.0,
//       height: 45.0,
//       alignment: Alignment.center,
//       child: Text(
//         digit != null ? digit.toString() : "",
//         style: TextStyle(
//           fontSize: 30.0,
//           color: Colors.black,
//         ),
//       ),
//       decoration: BoxDecoration(
// //            color: Colors.grey.withOpacity(0.4),
//           border: Border(
//               bottom: BorderSide(
//         width: 2.0,
//         color: Colors.black,
//       ))),
//     );
//   }

//   // Returns "Otp keyboard input Button"
//   // Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
//   //   return Material(
//   //     color: Colors.transparent,
//   //     child: InkWell(
//   //       onTap: onPressed,
//   //       borderRadius: BorderRadius.circular(40.0),
//   //       child: Container(
//   //         height: 80.0,
//   //         width: 80.0,
//   //         decoration: BoxDecoration(
//   //           shape: BoxShape.circle,
//   //         ),
//   //         child: Center(
//   //           child: Text(
//   //             label,
//   //             style: TextStyle(
//   //               fontSize: 30.0,
//   //               color: Colors.black,
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Returns "Otp keyboard action Button"
//   // _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
//   //   return InkWell(
//   //     onTap: onPressed,
//   //     borderRadius: BorderRadius.circular(40.0),
//   //     child: Container(
//   //       height: 80.0,
//   //       width: 80.0,
//   //       decoration: BoxDecoration(
//   //         shape: BoxShape.circle,
//   //       ),
//   //       child: Center(
//   //         child: label,
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Current digit
//   void _setCurrentDigit(int i) {
//     setState(() {
//       _currentDigit = i;
//       if (_firstDigit == null) {
//         _firstDigit = _currentDigit;
//       } else if (_secondDigit == null) {
//         _secondDigit = _currentDigit;
//       } else if (_thirdDigit == null) {
//         _thirdDigit = _currentDigit;
//       } else if (_fourthDigit == null) {
//         _fourthDigit = _currentDigit;

//         var otp = _firstDigit.toString() +
//             _secondDigit.toString() +
//             _thirdDigit.toString() +
//             _fourthDigit.toString();

//         // Verify your otp by here. API call
//       }
//     });
//   }

//   Future<Null> _startCountdown() async {
//     setState(() {
//       _hideResendButton = true;
//       totalTimeInSeconds = time;
//     });
//     _controller.reverse(
//         from: _controller.value == 0.0 ? 1.0 : _controller.value);
//   }

//   void clearOtp() {
//     _fourthDigit = null;
//     _thirdDigit = null;
//     _secondDigit = null;
//     _firstDigit = null;
//     setState(() {});
//   }
// }

// class OtpTimer extends StatelessWidget {
//   final AnimationController controller;
//   double fontSize;
//   Color timeColor = Colors.black;

//   OtpTimer(this.controller, this.fontSize, this.timeColor);

//   String get timerString {
//     Duration duration = controller.duration * controller.value;
//     if (duration.inHours > 0) {
//       return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//     }
//     return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//   }

//   Duration get duration {
//     Duration duration = controller.duration;
//     return duration;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: controller,
//         builder: (BuildContext context, Widget child) {
//           return Text(
//             timerString,
//             style: TextStyle(
//                 fontSize: fontSize,
//                 color: timeColor,
//                 fontWeight: FontWeight.w600),
//           );
//         });
//   }
// }
