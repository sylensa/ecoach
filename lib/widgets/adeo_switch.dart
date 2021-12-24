import 'package:flutter/material.dart';

class AdeoSwitch extends StatefulWidget {
  const AdeoSwitch({
    this.value,
    required this.activeColor,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  final bool? value;
  final Color activeColor;
  final Function? onChanged;

  @override
  State<AdeoSwitch> createState() => _AdeoSwitchState();
}

class _AdeoSwitchState extends State<AdeoSwitch> {
  bool switched = false;

  @override
  void initState() {
    switched = widget.value ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.value != null) {
          setState(() {
            switched = !widget.value!;
          });
          widget.onChanged!(!widget.value!);
        } else {
          setState(() {
            switched = !switched;
          });
          widget.onChanged!(switched);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.value ?? switched
                  ? widget.activeColor
                  : Color(0xFFBEBEBE),
              borderRadius: BorderRadius.circular(13),
            ),
            height: 18,
            width: 32,
          ),
          Positioned(
            top: 3,
            left: widget.value ?? switched ? 16 : 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
