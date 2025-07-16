import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:juggle_im/juggle_const.dart';
import 'package:juggle_im/juggle_im.dart';
import 'package:juggle_im/model/call/call_session.dart';
import 'package:juggle_im/model/call/video_view.dart';
import 'package:juggle_im/model/connection_listener.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_info.dart';
import 'package:juggle_im/model/get_conversation_info_option.dart';
import 'package:juggle_im/model/get_message_option.dart';
import 'package:juggle_im/model/init_config.dart';
import 'package:juggle_im/model/message.dart';
import 'package:juggle_im/model/message/image_message.dart';
import 'package:juggle_im/model/message/text_message.dart';
import 'package:juggle_im_example/group_notify_message.dart';

void main() {
  runApp(const MyApp());
}

class _MainConnectionListener implements ConnectionListener {
  @override
  void onConnectionStatusChange(int connectionStatus, int code, String extra) {
    print("_MainConnectionListener, onConnectionStatusChange, status is " + connectionStatus.toString());
  }

  @override
  void onDbOpen() {
    print("_MainConnectionListener, onDbOpen");
  }

  @override
  void onDbClose() {
    print("_MainConnectionListener, onDbClose");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _juggleImPlugin = JuggleIm.instance;
  CallSession? callSession2;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _juggleImPlugin.getPlatformVersion() ?? 'Unknown platform version';
      
      await _juggleImPlugin.setServers(["wss://ws.juggleim.com"]);
      InitConfig config = InitConfig();
      LogConfig logConfig = LogConfig();
      logConfig.consoleLevel = 6;
      config.logConfig = logConfig;
      await _juggleImPlugin.init('nsw3sue72begyv7y', config);
      await _juggleImPlugin.initZegoEngine(1881186044, '');
      _juggleImPlugin.registerMessageType(() => GroupNotifyMessage());
      await _juggleImPlugin.connect('ChBuc3czc3VlNzJiZWd5djd5GiCJQefp9NOXL23cc_ux0o53VypAkehIqxPVZZ2sbCi6tA==');

      _juggleImPlugin.onConnectionStatusChange = (status, code, extra) async {
        print('onConnectionStatusChange, status is ' + status.toString() + ', code is ' + code.toString());
        int? s = await _juggleImPlugin.getConnectionStatus();
        print('getConnectionStatus status is ' + s.toString());
        if (status == ConnectionStatus.connected) {
          List<ConversationInfo>? l = await _juggleImPlugin.getConversationInfoList();
          int length = 0;
          if (l != null) {
            length = l.length;
          }
          print("getConversationInfoList, count is " + length.toString());

          Conversation cc = Conversation(1, 'YvoGswbXyqU');

          var session = await _juggleImPlugin.startSingleCall('YvoGswbXyqU', 0, 'flutter extra');
          // int r = await _juggleImPlugin.setMessageTop('n2bbjeh4k4qgzrn9', cc, false);
          

          Conversation ccc = Conversation(2, '22GkgKbSwJ6asdfasdf');
          // var rr = await _juggleImPlugin.getTopMessage(cc);
          // var rrr = await _juggleImPlugin.getTopMessage(ccc);
          // int iiii = 1;

          // Conversation c1 = Conversation(2, '7FRQ9M8eCnv');
          // Result<void>? r = await _juggleImPlugin.setMute(c1, true);
          // ConversationInfo? info1 = await _juggleImPlugin.getConversationInfo(c1);

          // r = await _juggleImPlugin.setTop(c1, true);
          // info1 = await _juggleImPlugin.getConversationInfo(c1);
          

          // GetConversationInfoOption option = GetConversationInfoOption();
          // option.conversationTypes = [2];
          // option.count = 100;
          // option.timestamp = 0;
          // option.direction = 1;
          // l = await _juggleImPlugin.getConversationInfoListByOption(option);
          // length = 0;
          // if (l != null) {
          //   length = l.length;
          // }
          // print("getConversationInfoListByOption, count is " + length.toString());


          // GetMessageOption getMessageOption = GetMessageOption();
          // getMessageOption.count = 5;
          // var messages = await _juggleImPlugin.getMessages(c1, 1, getMessageOption);
          // var cml = [6];
          // int? code = await _juggleImPlugin.deleteMessagesByClientMsgNoList(c1, cml, true);


          // // Result<Message>? rm = await _juggleImPlugin.recallMessage('nzcyxtgktxqjxmya');

          // GetMessageOption o = GetMessageOption();
          // o.count = 20;
          // Result<List<Message>>? messageListResult = await _juggleImPlugin.getMessages(c1, 1, o);
          // print('getMessages');

          // List<String> llll = ["nzcyxtgktxqjxmya", "nzc3rmccbzyjxmya"];
          // List<Message>? l2 = await _juggleImPlugin.getMessagesByMessageIdList(llll);
          // print('getMessagesByMessageIdList');

          // UserInfo? userInfo = await _juggleImPlugin.getUserInfo('YvoGswbXyqU');




          // Conversation c2 = Conversation(1, 'YvoGswbXyqU');
          // TextMessage textMessage = TextMessage.content('flutter text Android');
          // ImageMessage image = ImageMessage();
          // image.localPath = 'asdfadf';
          // image.thumbnailLocalPath = '23232';
          // GroupNotifyMessage groupNotifyMessage = GroupNotifyMessage();
          // groupNotifyMessage.content = 'This is content';
          // groupNotifyMessage.aaa = 'This is aaa';
          // callback(message, errorCode) {
          //     if (errorCode == 0) {
          //       print("sendMessage success, messageId is " + message.messageId!);
          //     } else {
          //       print('sendMessage error, errorCode is ' + errorCode.toString() + ', clientMsgNo is ' + message.clientMsgNo!.toString());
          //     }
          // }
          // progressCallback(message, progress) {

          // }
          // Message? message = await _juggleImPlugin.sendMessage(textMessage, c2, callback);
          // Message? message2 = await _juggleImPlugin.resendMessage(message, callback);

          // Conversation cError = Conversation(1, 'asdfasdfasdfasdf');
          // ConversationInfo? info = await _juggleImPlugin.getConversationInfo(cError);

          // await _juggleImPlugin.setMute(c2, true);
          

          // Message? message = await _juggleImPlugin.sendMediaMessage(image, c2, callback, progressCallback);
          // print('after sendMessage, message clientMsgNo is ' + message!.clientMsgNo!.toString());
          // await _juggleImPlugin.setMessageLocalAttribute(message.clientMsgNo, "asdfasdfasdfasdfasdf");
          // List<Message> localAttributeMessageList = await _juggleImPlugin.getMessagesByClientMsgNoList([message.clientMsgNo]);
          // GetMessageOption op = GetMessageOption();
          // op.count = 20;
          // var localAttributeMessageList2 = await _juggleImPlugin.getMessages(c2, 1, op);

          // var userIdList = ['YvoGswbXyqU'];
          // var userId = 'YvoGswbXyqU';
          // CallSession? callSession = await _juggleImPlugin.startMultiCall(userIdList, 0);
          // callSession2 = await _juggleImPlugin.getCallSession(callSession!.callId);
          // VideoView view = VideoView(viewId: 'viewId');
          // await callSession2?.setVideoView(userId, view);
          callSession2?.onCallFinish = (finishReason){
            print('onCallFinish ' + finishReason.toString());
          };
          // callSession2?.onSoundLevelUpdate = (map) {
          //   print('onSoundLevelUpdate: $map');
          // };
          callSession2?.onCallConnect = (){
            print('onCallConnect');
            callSession2?.hangup();
          };


          


          print('end');

        }
      };
      _juggleImPlugin.onDbOpen = (){
        print('onDbOpen');
      };
      _juggleImPlugin.onConversationInfoAdd = (list) {
        print('onConversationInfoAdd, length is ' + list.length.toString());
      };
      _juggleImPlugin.onConversationInfoUpdate = (list) {
        print('onConversationInfoUpdate, length is ' + list.length.toString());
      };
      _juggleImPlugin.onConversationInfoDelete = (list) {
        print('onConversationInfoDelete, length is ' + list.length.toString());
      };
      _juggleImPlugin.onTotalUnreadMessageCountUpdate = (count) {
        print('onTotalUnreadMessageCountUpdate, count is ' + count.toString());
      };
      // _juggleImPlugin.onMessageReceive = (message) {
      //   print('onMessageReceive');
      // };
      _juggleImPlugin.onMessagesRead = (conversation, list) {
        print('onMessagesRead, count is ' + list.length.toString());
      };
      _juggleImPlugin.onMessageDelete = (conversation, list) {
        print('onMessageDelete, count is ' + list.length.toString());
      };

      _juggleImPlugin.onCallReceive = (callSession) {
        print('onCallReceive');
        // callSession2 = callSession;
        // callSession.accept();
        // callSession2?.onCallFinish = (finishReason){
        //   print('onCallFinish ' + finishReason.toString());
        // };
        // callSession2?.onCallConnect = (){
        //   print('onCallConnect');
        //   callSession2?.hangup();
        // };
      };

      _juggleImPlugin.onMessageSetTop = (message, userInfo, isTop) {
        print('onMessageSetTop');
      };

      _juggleImPlugin.onMessageUpdate = (message) {
        print('onMessageUpdate');
      };
      

      final connectionListener = _MainConnectionListener();
      _juggleImPlugin.addConnectionListener('main', connectionListener);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
