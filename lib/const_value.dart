import 'package:flutter/material.dart';
class ConstFonts{
  final TextStyle headingStyle = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  final TextStyle titleStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  final TextStyle bodyStyle = const TextStyle(
    fontSize: 16,
  );
  TextStyle copyWith({double? fontSize, FontWeight? fontWeight,Color? color}){
    return TextStyle(
      fontSize: fontSize ?? bodyStyle.fontSize,
      fontWeight: fontWeight ?? bodyStyle.fontWeight,
      color: color ?? Colors.black,
    );
  }
}