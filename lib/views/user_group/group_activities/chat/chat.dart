import 'dart:convert';

import 'package:ecoach/helper/helper.dart';
import 'package:ecoach/models/group_chat_model.dart';
import 'package:ecoach/models/user.dart';
import 'package:ecoach/utils/constants.dart';
import 'package:ecoach/utils/style_sheet.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io' as io;

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


class GroupChatScreen extends StatefulWidget {
  User user;
  GroupChatScreen(this.user);
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  bool progressCode = true;
  String statusMessage = '';
  int galleryState = 0;

  List <XFile> _imageFile = [];
  dynamic _pickImageError;
  bool isVideo = false;
  bool isPic = false;
  var sendingActualVideo ;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  bool _isPlaying = false;
  var url;
  final LocalFileSystem localFileSystem = LocalFileSystem();
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  double chatLat = 0.00;
  double chatLng = 0.00;
  TextEditingController sendMessageController = TextEditingController();
  String audioPath = '';
  List selectedMember = [];



  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder!.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder!.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder!.stop();
    audioPath = result!.path!;
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory? appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory!.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
        _start();
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions"))
        );
      }
    } catch (e) {
      print(e);
    }
  }
  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }



  _buildMessage(Messages message, bool isMe) {
    final text = message.message;
    final style = TextStyle(fontSize: 30);

    TextPainter textPainter = TextPainter()
      ..text = TextSpan(text: text, style: style)
      ..textDirection = TextDirection.ltr
      ..layout(minWidth: 0, maxWidth: double.infinity);

    print("text size: ${textPainter.size}");
    final Container msg =
    Container(
      child: Row(
        children: [
          !isMe ?
          Container(
              margin: rightPadding(5),
              child: displayImage("${message.senderDp}",radius: 20)
          ):Container(),

          Column(
            crossAxisAlignment: !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  !isMe ?
                  Container(
                    child: sText("${message.senderName != null ? properCase(message.senderName!.split(" ").last) : message.senderName}, ", color: Colors.white, size: 10, weight: FontWeight.w600),
                  ):Container(),
                  Container(
                    child: sText("${message.stamp.toString().split(" ").last.split(".").first}", color: Colors.white, size: 10, weight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                margin: isMe
                    ? EdgeInsets.only(top: 0, bottom: 8, left: 0)
                    : EdgeInsets.only(top: 0, bottom: 8, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.mediatype == "img" ?
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        width: appWidth(context) * 0.75,
                        height: 200,
                        child: displayImage(message.message,radius: 0),
                      ),
                    ) :  message.mediatype == "aud" ?
                    Container(
                        width: appWidth(context) * 0.75,
                        height: 115,
                        child: sText("audio player")
                    )
                        :  message.mediatype == "vid" ?
                    Container(
                      width: appWidth(context) * 0.75,

                      child: sText("video player"),
                    ) :  message.mediatype == 'loc' ?
                    GestureDetector(
                      onTap: ()async{
                      },
                      child: Container(
                          width: appWidth(context) * 0.75,
                          height: 50,
                          child:Image.asset("assets/map.png",fit: BoxFit.cover,)
                      ),
                    ) :
                    textPainter.size.width >  300 ?
                    Container(
                      width:  300  ,
                      padding: appPadding(5),
                      child: sText(utf8convert(message.message!),maxLines: 20),
                    ) :
                    Container(
                      padding: appPadding(5),
                      child: sText(utf8convert(message.message!),maxLines: 20),
                    )
                    ,
                  ],
                ),
                decoration: BoxDecoration(
                    color: isMe ? Colors.yellow : Color(0XFFFFEFEE),
                    borderRadius: isMe
                        ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                        : BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ],
          )
        ],
      ),
    )
    ;
    if (isMe) {
      return Container(
        width: appWidth(context),
        child: Row(
          children: [
            Expanded(
                child: Container()
            ),
            msg,

          ],
        ),
      );
    }
    return Row(
      children: [
        msg,
        // Expanded(
        //   child: displayImage("${widget.chat.dp}",radius: 20)
        // )
      ],
    );
  }

  _buildMessageComposer(List mems) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
              child: Icon(
                Icons.emoji_emotions,
                color:  Colors.grey,
              ),
              onTap: () {
                setState(() {
                  galleryState = 0;
                  emojiShowing = !emojiShowing;
                });
              }),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: TextField(
                  autofocus: false,
                  enabled: mems.contains("+") ? true : false,
                  controller: sendMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration:
                  InputDecoration.collapsed(hintText: "${mems.contains("+") ? "Send message..." : "You have been removed"}"),
                ),
              )
          ),
          GestureDetector(
              onTap: (){},
              child: Icon(Icons.send,color: kAdeoGray2,),
          ),
          GestureDetector(
            onTap: (){},
              child: Icon(Icons.attach_file,color: kAdeoGray2,),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                galleryState = 4;
              });
            },
              child: Icon(Icons.keyboard_voice_rounded,color: kAdeoGray2,),
          ),
        ],
      ),
    );
  }

  _buildGallery() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(
              Icons.keyboard,
              color:  Colors.grey,
            ),
            onPressed: () {
              setState(() {
                galleryState = 0;
                emojiShowing = !emojiShowing;
              });
            }),
        IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: 2 == galleryState ? Colors.white : Colors.grey,
            ),
            onPressed: () {

            }),
        IconButton(
            icon: Icon(
              Icons.location_on,
              color: 3 == galleryState ? Colors.white : Colors.grey,
            ),
            onPressed: () async {
            }),
        IconButton(
            icon: Icon(
              Icons.mic,
              color: 4 == galleryState ? Colors.white : Colors.grey,
            ),
            onPressed: () {
              setState((){
                galleryState = 4;
              });
            }),
      ],
    );
  }

  _buildRecording(){
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10,bottom: 10),
            child: sText("${_current?.duration.toString() == "null" ? "0:00:00" : _current?.duration.toString()}",color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: FlatButton(onPressed: _currentStatus != RecordingStatus.Unset ? _stop : null, child: sText("Stop",color: Colors.white)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30)),
                    color: appMainDarkGrey
                ),
              ),
              GestureDetector(
                onTap: (){
                  switch (_currentStatus) {

                    case RecordingStatus.Initialized:
                      {
                        _start();
                        break;
                      }
                    case RecordingStatus.Recording:
                      {
                        _pause();
                        break;
                      }
                    case RecordingStatus.Paused:
                      {
                        _resume();
                        break;
                      }
                    case RecordingStatus.Stopped:
                      {
                        _init();
                        break;
                      }

                    case RecordingStatus.Unset:
                      {
                        _init();

                        break;
                      }
                    default:
                      break;
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/rec.png"),
                      radius: 40,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                    ),
                    // label:  _buildText(_currentStatus),
                  ),
                ),
              ),
              Container(
                child: FlatButton(onPressed: ()async{
                  await  _stop();
                  if(_current != null){
                  }
                }, child: sText("Send",color: Colors.white)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30)),
                    color: appMainDarkGrey
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    sendMessageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: sendMessageController.text.length));
  }

  _onBackspacePressed() {
    sendMessageController
      ..text = sendMessageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: sendMessageController.text.length));
  }

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              groupChatBetweenList.isNotEmpty ?
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child:Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: groupChatBetweenListDate.length,
                                itemBuilder: (BuildContext context, int indexs){
                                  return  Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Container(
                                        child: sText2("${getOutDays(groupChatBetweenListDate[indexs].stamp!)}",color: Colors.white,weight: FontWeight.normal,size: 10),
                                      ),
                                      for(int i = 0; i < groupChatBetweenList.length; i++)
                                        intl.DateFormat.yMMMEd().format(groupChatBetweenListDate[indexs].stamp!) == intl.DateFormat.yMMMEd().format(groupChatBetweenList[i].stamp!) ?
                                        _buildMessage(groupChatBetweenList[i], "" == "") : Container()
                                    ],
                                  );

                                }),
                          ),

                        ],
                      )
                  ),
                ),
              ) :
              groupChatBetweenList.isEmpty && progressCode == true ? Expanded(child: Center(child:  progress(),)) : Expanded(child: Center(child: sText2("No Conversation Chat",color: Colors.white),)),

              _buildMessageComposer(selectedMember),
              galleryState == 4 ?_buildRecording() : SizedBox.shrink(),
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          progressIndicatorColor: Colors.blue,
                          backspaceColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: sText('No Recents'),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


