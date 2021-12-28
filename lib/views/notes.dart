import 'package:ecoach/utils/style_sheet.dart';
import 'package:ecoach/views/notes_topics.dart';
import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: kAdeoBlue,
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 72.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NotesButton(
              label: 'Glossary',
              imageURL: 'glossary',
              onPressed: () {},
            ),
            SizedBox(height: 32.0),
            NotesButton(
              label: 'Topics',
              imageURL: 'topics',
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => NotesTopics()),
                // );
              },
            ),
            SizedBox(height: 32.0),
            NotesButton(
              label: 'Saved',
              imageURL: 'saved',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class NotesButton extends StatelessWidget {
  const NotesButton({
    required this.label,
    required this.imageURL,
    required this.onPressed,
  });

  final String label;
  final String imageURL;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: Feedback.wrapForTap(onPressed, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            child: Image.asset(
              'assets/images/notes/$imageURL.png',
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 24.0),
          Text(label),
        ],
      ),
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        textStyle: TextStyle(
          fontSize: 28.0,
          fontFamily: 'Poppins',
        ),
        side: BorderSide(color: kAdeoWhiteAlpha40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 44.0,
          vertical: 28.0,
        ),
      ),
    );
  }
}
