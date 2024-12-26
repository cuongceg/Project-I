import 'package:flutter/material.dart';
import 'colors.dart';

class ConstDecoration{
  InputDecoration inputDecoration({required String hintText}){
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ConstColor().primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ConstColor().primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: ConstColor().primary),
      ),
    );
  }

  OutlineInputBorder outlinedBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: ConstColor().primary),
    );
  }
}