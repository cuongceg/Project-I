import 'package:flutter/material.dart';
import 'package:recipe/core/colors.dart';

class BaseComponent{
  Widget loadingCircle({double size = 50}){
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: ConstColor().primary,
        strokeWidth: 5,
      ),
    );
  }
}