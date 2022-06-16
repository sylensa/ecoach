import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget questionAppBar() {
  return AppBar(
    actions: [
      Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: Stack(
            children: const [
              CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
                value: 0.7,
              ),
              Center(
                child: Text(
                  "7",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ],
    title: const Text(
      'Living things and Non-living things',
      style: TextStyle(fontSize: 14),
    ),
  );
}
