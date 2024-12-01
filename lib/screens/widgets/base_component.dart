import 'package:flutter/material.dart';
import 'package:recipe/core/colors.dart';

class BaseComponent{
  Widget loadingCircle(){
    return CircularProgressIndicator(
      color: ConstColor().primary,
      strokeWidth: 5,
    );
  }
}