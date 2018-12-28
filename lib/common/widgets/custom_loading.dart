import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180.0,
        width: 180.0,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
