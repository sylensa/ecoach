import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn gSignIn = GoogleSignIn();

class GLoginScreen extends StatefulWidget {
  const GLoginScreen({Key? key}) : super(key: key);

  @override
  State<GLoginScreen> createState() => _GLoginScreenState();
}

class _GLoginScreenState extends State<GLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
