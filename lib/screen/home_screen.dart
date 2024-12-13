
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

} //class

class _HomeScreenState extends State<HomeScreen>{
  XFile? video; // 동영상 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      //동영상이 선택 시 또는 미선택시 보여줄 위젯
      body: video == null? renderEmpty() : renderVideo(),
    );
  }
  Widget renderEmpty(){  // 동영상 선택전 보여줄 위젯
    return Container(
      width: MediaQuery.of(context).size.width,//너비 최대한 늘려주기
      decoration: getBoxDecoration(), // 함수를 만들고 값 가져오기
      child: Column(
        //위젯 가운데 정렬
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ), // 로고 이미지
          SizedBox(height: 30.0),
          _AppName(),//앱 이름
        ],
      ),
    );
  }

  void onNewVideoPressed() async{ // 이미지 선택하는 기능을 구현
    final video = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
    );

    if (video != null){
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration(){
    return BoxDecoration(
      // 그라데이션으로 색상 적용
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A3A73),
            Color(0xff000118),
          ],
      ),
    );
  }

  Widget renderVideo(){ // 동영상 선택후 보여줄 위젯
    return Center(
      child: CustomVideoPlayer(
        video: video!, // 선택된 동영상 입력해주기
        onNewVideoPressed : onNewVideoPressed,
      ),//동영상 재생기 위젯
    );
  }

}//class

//_Logo Class
class _Logo extends StatelessWidget{
  final GestureTapCallback onTap; // 탭했을때 실행할 함수

  const _Logo({
    required this.onTap,
    Key? key
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 상위 위젯으로부터 탭 콜백받기
      // : onTap의 경우 _HomeScreenState의 onNewVideoPressed() 함수를 입력받음.
      child: Image.asset(
      'asset/img/logo.png',
      ),
    );
  }

}// class

//_Appname class
class _AppName extends StatelessWidget{
  const _AppName({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'VIDEO',
            style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            // textStyle에서 두께만 700으로 변경
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

}//class