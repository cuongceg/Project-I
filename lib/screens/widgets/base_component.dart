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

  Widget continueButton({required Function() onPressed, required String text}){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ConstColor().primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text,style: const TextStyle(fontSize: 18,color: Colors.white,),),
    );
  }

  Widget signInButton({required Function() onPressed, required String text,required Widget icon}){
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: icon,
      label: Text(text,style: const TextStyle(fontSize: 14,color: Colors.black,),),
    );
  }
}