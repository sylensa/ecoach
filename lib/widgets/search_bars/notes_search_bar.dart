import 'package:flutter/material.dart';

class NotesSearchBar extends StatelessWidget {
  const NotesSearchBar({this.searchHint = 'Search...', this.onChanged});

  final String searchHint;
  final onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x94FFFFFF))),
      ),
      child: Row(
        children: [
          SizedBox(width: 28.0),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                icon: Image.asset('assets/icons/search.png'),
                hintText: searchHint,
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: Color(0x94FFFFFF),
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.0),
                filled: false,
              ),
            ),
          )
        ],
      ),
    );
  }
}
