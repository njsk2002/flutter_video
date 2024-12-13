
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget{
  final GestureTapCallback onPressed; // 아이콘을 눌렸을때 실행할 함수
  final IconData iconData; // 아이콘

  //CustomIconButton(this.onPressed, this.iconData);

  CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key
   }): super(key: key);


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        iconSize: 30.0,
        color: Colors.white,
        icon: Icon(    // 아이콘
          iconData,
        ),
    );
  }

}//class