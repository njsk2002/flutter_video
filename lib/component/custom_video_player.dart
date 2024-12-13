
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/costom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  // XFILE은 ImagePicker로 영상 또는 이미지를 선택했을때 반환하는 타입
  final XFile video;

  // 새로운 동영상을 선택하면 실행되는 함수
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    Key? key,
    required this.video,
    required this.onNewVideoPressed,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
} //class


// ###############  _CustomVideoPlayerState #################
class _CustomVideoPlayerState extends State<CustomVideoPlayer>{
  bool showControls = false; // 아이콘 보여줄지 여부
 // 동영상 조작 컨트롤러
  VideoPlayerController? videoController;

  @override
  //covariant 키워드는 CustomVideoPlayer 클래스의 상속된 값도 허가해 줌
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    //새로 선택한 동영상이 같은 동영상인지 확인
    if(oldWidget.video.path != widget.video.path){
      initializeController();
    }
  }



  @override
  void initState() {
    super.initState();

    initializeController(); //컨트롤러 초기화
  }

  initializeController() async{ //선택한 동영상으로 컨트롤 초기회
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    // 컨트롤러의 속성이 변경될때 마다 실행할 함수 등록
    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });

  }

  //동영상의 재생 상태가 변결될때 마다
  // setState()를 실행해서 build()를 재실행 합니다.
  void videoControllerListener() {

    // videoController의 상태 변경 시 호출
    print("isPlaying: ${videoController?.value.isPlaying}");
    print("Position: ${videoController?.value.position}");
    print("Duration: ${videoController?.value.duration}");


    setState(() {
    });
  }

  //State가 폐기될때 같이 폐기할 함수들을 실행
  @override
  void dispose(){
    // listener 삭제
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 동영상 컨트롤러가 준비 중일때 로딩표시
    if (videoController == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

   // return Center(
   //   child: Text(
   //     'CustomVideoPlayer', // 샘플테스트
   //      style: TextStyle(
   //       color: Colors.white,
   //     ),
   //   ),
   // );
    return GestureDetector( // 화면 전체의 탭을 인식하기 위해 사용
      onTap: (){
        setState(() {
          showControls = !showControls;
        });
      },
      child : AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack( // children 위젯을 위로 쌓을수 있는 위젯
          children: [
            VideoPlayer( // VideoPlayer 위젯을 stack으로 이동
              videoController!,
            ),
            if(showControls)
              Container( // 아이콘 버튼을 보일 때 화면을 어둡게 변경
                // color: Colors.black.withOpacity(0.5),
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            Positioned( // child 위젯의 위치를 정함
                bottom: 0,
                right: 0,
                left:0,
                child : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.8),
                  child : Row(
                    children: [
                      renderTimeTextFromDuration(
                        //동영상 현재 위치
                        videoController!.value.position,
                      ),
                      Expanded(
                        child:Slider( // 동영상재생상태를 보여주는 슬라이더
                        //슬라이드가 이동할때마다 실행되는 함수
                        onChanged: (double val){
                          videoController!.seekTo(
                            Duration(seconds: val.toInt()),
                          );
                        },
                        value: videoController!.value.position.inSeconds.toDouble(),
                        // value : 0,
                        min: 0,
                        max: videoController!.value.duration.inSeconds.toDouble(),
                      ),
                      ),
                      renderTimeTextFromDuration(
                        //동영상 총길이
                        videoController!.value.duration,
                      )
                    ],
              ),
              ),
            ),

            if(showControls)
              Align( //오른쪽 위에 새 동영상 아이콘 위치
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  // 카메라 이이콘을 선택하면 새로운 동영상 선택 함수 실행
                    onPressed: widget.onNewVideoPressed,
                    iconData: Icons.photo_camera_back,
                ),
              ),

            if(showControls)
              Align( // 동영상 재생 관련 아이콘 중앙 위치
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(//앞으로
                        onPressed: onReversePressed,
                        iconData: Icons.rotate_left,
                    ),
                    CustomIconButton( // 재생버튼
                        onPressed: onPlayPressed,
                        iconData: videoController!.value.isPlaying?
                            Icons.pause : Icons.play_arrow,
                    ),
                    CustomIconButton( // 뒤로
                        onPressed: onForwardPressed,
                        iconData: Icons.rotate_right,
                    )
                  ],
                ),

              )
          ],
        ),
        ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    // Duration 값을 보기 편한 형태로 변환하기
    return Text(
    '${duration.inMinutes.toString().padLeft(2,'0')} :${(duration.inSeconds % 60).toString().padLeft(2,'0')}',
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  void onReversePressed() { // 뒤로 (되갑기)
    //앞으로 구현 함수
    final currentPosition = videoController!.value.position; // 현재실행중인위치

    Duration position = Duration(); // 0초로 실행 위치 초기화

    if (currentPosition.inSeconds > 3) { //현재 실행 위치가 3초보다 길때만 3초 빼기
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onForwardPressed(){ // 앞으로 감기 버튼
    final maxPosition = videoController!.value.duration; // 동영상길이
    final currentPosition = videoController!.value.position; // 현재위치

    Duration position = maxPosition; // 동영상 길이로 실행 위치 초기화

    // 동영상 길이에서 3초를 뺀값보다 현재 위치가 짧을때만 3초 더하기
    if(( maxPosition -Duration(seconds: 3)).inSeconds > currentPosition.inSeconds){
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() { //재생 버튼을 눌렸을때 함수
    if ( videoController!.value.isPlaying){
      videoController!.pause();
    }
    else{
      videoController!.play();
    }
  }

}//class