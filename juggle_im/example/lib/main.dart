import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:juggle_im/juggle_const.dart';
import 'package:juggle_im/juggle_im.dart';
import 'package:juggle_im/model/call/call_info.dart';
import 'package:juggle_im/model/call/call_session.dart';
import 'package:juggle_im/model/call/video_view.dart';
import 'package:juggle_im/model/connection_listener.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_info.dart';
import 'package:juggle_im/model/favorite_message_result.dart';
import 'package:juggle_im/model/get_conversation_info_option.dart';
import 'package:juggle_im/model/get_favorite_message_option.dart';
import 'package:juggle_im/model/get_message_option.dart';
import 'package:juggle_im/model/get_moment_comment_option.dart';
import 'package:juggle_im/model/get_moment_option.dart';
import 'package:juggle_im/model/init_config.dart';
import 'package:juggle_im/model/message.dart';
import 'package:juggle_im/model/message/file_message.dart';
import 'package:juggle_im/model/message/image_message.dart';
import 'package:juggle_im/model/message/merge_message.dart';
import 'package:juggle_im/model/message/text_message.dart';
import 'package:juggle_im/model/message/video_message.dart';
import 'package:juggle_im/model/message/voice_message.dart';
import 'package:juggle_im/model/message_query_option.dart';
import 'package:juggle_im/model/moment.dart';
import 'package:juggle_im/model/moment_comment.dart';
import 'package:juggle_im/model/moment_media.dart';
import 'package:juggle_im/model/result.dart';
import 'package:juggle_im/model/result_has_more.dart';
import 'package:juggle_im/model/search_conversation_result.dart';
import 'package:juggle_im/model/send_message_option.dart';
import 'package:juggle_im/model/user_info.dart';
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
      // await _juggleImPlugin.setServers(["wss://im.secretchat.im"]);
      InitConfig config = InitConfig();
      LogConfig logConfig = LogConfig();
      PushConfig pushConfig = PushConfig();
      pushConfig.hwConfig = HWConfig();
      pushConfig.jgConfig = JGConfig();
      logConfig.consoleLevel = 6;
      config.logConfig = logConfig;
      config.pushConfig = pushConfig;
      await _juggleImPlugin.init('nsw3sue72begyv7y', config);
      // await _juggleImPlugin.init('nwm6fxqt2aeebhb7', config);
      await _juggleImPlugin.initZegoEngine(1881186044, '');
      _juggleImPlugin.registerMessageType(() => GroupNotifyMessage());
      await _juggleImPlugin.connect('ChBuc3czc3VlNzJiZWd5djd5GiCJQefp9NOXL23cc_ux0o53VypAkehIqxPVZZ2sbCi6tA==');
      // await _juggleImPlugin.connect('ChBud202ZnhxdDJhZWViaGI3GiAAUR0yD9XzkXUx6XlF7IXkjoFQy7tYYsPhyZnktWV36A==');

      _juggleImPlugin.onConnectionStatusChange = (status, code, extra) async {
        print('onConnectionStatusChange, status is ' + status.toString() + ', code is ' + code.toString());
        int? s = await _juggleImPlugin.getConnectionStatus();
        print('getConnectionStatus status is ' + s.toString());
        if (status == ConnectionStatus.connected) {
          // String content = 'flutter moment';
          // MomentMedia m1 = MomentMedia();
          // m1.url = 'www.baidu.com';
          // m1.type = 0;
          // m1.duration = 111;
          // m1.height = 300;
          // m1.width = 600;
          // MomentMedia m2 = MomentMedia();
          // m2.url = 'www.google.com';
          // m2.type = 1;
          // m2.duration = 222;
          // m2.height = 1080;
          // m2.width = 2000;
          // m2.snapshotUrl = 'snapshot.com';
          // List<MomentMedia> l = [m1, m2];
          // Result<Moment> result = await _juggleImPlugin.addMoment(content, l);
          // int removeResult = await _juggleImPlugin.removeMoment('n453266x2b6yhvgy');
          // Result<MomentComment> comment = await _juggleImPlugin.addComment('n454cxxeaccyhvgy', 'flutter comment has parent', 'n454fu62jce4hvgy');
          // int removeCommentResult = await _juggleImPlugin.removeMomentComment('n454cxxeaccyhvgy', 'n454g4uejcg4hvgy');
          int addReactionResult = await _juggleImPlugin.addMomentReaction('n454cxxeaccyhvgy', 'shit');
          GetMomentOption o = GetMomentOption();
          List<Moment> cachedMomentList = await _juggleImPlugin.getCachedMomentList(o);
          ResultHasMore<List<Moment>> momentList = await _juggleImPlugin.getMomentList(o);
          Result<Moment> moment = await _juggleImPlugin.getMoment('n45334nrjcayhvgy');
          GetMomentCommentOption commentOption = GetMomentCommentOption();
          commentOption.momentId = 'n454cxxeaccyhvgy';
          ResultHasMore<List<MomentComment>> commentList = await _juggleImPlugin.getMomentCommentList(commentOption);
          int i = 1;





          // GetMessageOption option = GetMessageOption();
          // option.count = 10;
          // option.startTime = 0;

          // List<Message> messages = await _juggleImPlugin.searchMessagesInConversation(searchContent, conversation, 1, option);
          // int i = 1;

          // CallInfo? callInfo = await _juggleImPlugin.getConversationCallInfo(conversation);
          // if (callInfo != null) {
          //   CallSession? callSession = await _juggleImPlugin.joinCall(callInfo.callId);
          // }


          // List<String> messageIdList = ['n2wmlrafjaehvacu'];

          // int r1 = await _juggleImPlugin.removeFavoriteMessages(messageIdList);


          // GetFavoriteMessageOption option = GetFavoriteMessageOption();
          // option.count = 10;
          // // option.offset = "fGaw7BqtY";
          // Result<FavoriteMessageResult> r = await _juggleImPlugin.getFavoriteMessages(option);

          // int i = 1;

          
          

          // List<ConversationInfo>? l = await _juggleImPlugin.getConversationInfoList();
          // int length = 0;
          // if (l != null) {
          //   length = l.length;
          // }
          // print("getConversationInfoList, count is " + length.toString());
          // int difference = await _juggleImPlugin.getTimeDifference();

          // Conversation cc = Conversation(2, 'YvoGswbXyqU');
          // GetMessageOption o = GetMessageOption();
          // o.count = 50;



          // // TextMessage ttt = TextMessage.content('flutter text');


          // DataCallback<Message> callback = (mmmm, errorCode) {
          //   if (errorCode == 0) {
          //     print("sendMessage success, messageId is " + mmmm.messageId!);
          //   } else {
          //     print('sendMessage error, errorCode is ' + errorCode.toString() + ', clientMsgNo is ' + mmmm.clientMsgNo!.toString());
          //   }
          // };

          // Message? m1 = await _juggleImPlugin.sendMessage(mm, cc, callback);

          // var v = await _juggleImPlugin.getMergedMessageList('n2hsmcpfjbcgzrn9');
          


          // var messages = await _juggleImPlugin.getMessages(cc, 1, o);


          // GetMessageOption o1 = GetMessageOption();
          // o1.startTime = messageListResult.timestamp;
          // o1.count = 20;
          // var messageListResult1 = await _juggleImPlugin.getMessages(cc, 1, o1);


          // var session = await _juggleImPlugin.startSingleCall('YvoGswbXyqU', 0, 'flutter extra');
          // int r = await _juggleImPlugin.setMessageTop('n2bbjeh4k4qgzrn9', cc, false);
          

          // Conversation ccc = Conversation(2, '22GkgKbSwJ6asdfasdf');

          // var rr = await _juggleImPlugin.getTopMessage(cc);
          // var rrr = await _juggleImPlugin.getTopMessage(ccc);
          // int iiii = 1;

          // Conversation c1 = Conversation(2, '7FRQ9M8eCnv');
          // Result<void>? r = await _juggleImPlugin.setMute(c1, true);
          // ConversationInfo? info1 = await _juggleImPlugin.getConversationInfo(c1);

          // r = await _juggleImPlugin.setTop(c1, true);
          // info1 = await _juggleImPlugin.getConversationInfo(c1);
          

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
      _juggleImPlugin.onMessageReceive = (message) {
        print('onMessageReceive');
      };
      _juggleImPlugin.onMessagesRead = (conversation, list) {
        print('onMessagesRead, count is ' + list.length.toString());
      };
      _juggleImPlugin.onMessageDelete = (conversation, list) {
        print('onMessageDelete, count is ' + list.length.toString());
      };

      _juggleImPlugin.onMessageDestroyTimeUpdate = (messageId, conversation, destroyTime) {
        print('onMessageDestroyTimeUpdate, messageId is ' + messageId + ', destroyTime is ' + destroyTime.toString());
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

      _juggleImPlugin.onCallInfoUpdate = (callInfo, conversation, isFinished) {
          print('onCallInfoUpdate');
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
