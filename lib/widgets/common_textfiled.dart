import 'package:flutter/material.dart';


class CommonTextFiled extends StatelessWidget{
  
  final String labelText;
  final TextEditingController controller;
  final Icon icon;

  CommonTextFiled({this.controller, this.icon, this.labelText});

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
        ),
      ),
    );
  }
}