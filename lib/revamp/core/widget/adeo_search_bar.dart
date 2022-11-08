import 'package:flutter/material.dart';

class AdeoSearchBox extends StatelessWidget {
  const AdeoSearchBox({
    Key? key,
    this.placeholder,
    this.onChanged,
    this.onSubmit,
    this.onFieldSubmitted,
  }) : super(key: key);

  final Function(String val)? onChanged;
  final Function(String val)? onFieldSubmitted;
  final String? placeholder;
  final Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width:  MediaQuery.of(context).size.width * 0.88,
      constraints: BoxConstraints(maxHeight: 560),
      child: Material(
        color: Colors.transparent,
        child: TextFormField(
          onFieldSubmitted: (val) => onFieldSubmitted!(val),
          cursorHeight: 20,
          onChanged: (val) => onChanged!(val),
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Color(0xFF132239),
            fontFamily: 'PoppinsRegular',
            fontSize: 16,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 12),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: onSubmit,
                  icon: Image.asset(
                    'assets/icons/search.png',
                    height: 20,
                    width: 20,
                    color: Color(0xFFAFC2DE),
                  ),
                ),
              ),
            ),
            fillColor: Colors.white,
            hoverColor: Colors.white,
            contentPadding: EdgeInsets.only(
              top: 6,
              bottom: 6,
              left: 20,
              right: 74,
            ),
            filled: true,
            hintText: placeholder ?? 'Search...',
            hintStyle: TextStyle(
              color: Color(0xFFC8CED7),
              fontFamily: 'PoppinsMedium',
              fontSize: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  style: BorderStyle.solid, color: Color(0xFFFFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  style: BorderStyle.solid, color: Color(0xFF00C9B9)),
            ),
          ),
        ),
      ),
    );
  }
}
