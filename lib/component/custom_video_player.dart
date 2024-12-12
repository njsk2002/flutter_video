
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  // XFILE은 ImagePicker로 영상 또는 이미지를 선택했을때 반환하는 타입
  final XFile video;

  const CustomVideoPlayer({
    Key? key,
    required this.video
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
} //class

class _CustomVideoPlayerState extends State<CustomVideoPlayer>{

  @override
  Widget build(BuildContext context) {
   return Center(
     child: Text(
       'CustomVideoPlayer', // 샘플테스트
        style: TextStyle(
         color: Colors.white,
       ),
     ),
   );
  }

}