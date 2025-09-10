import 'package:juggle_im/model/conversation.dart';

class MessageQueryOption {
  // 指定搜索内容
  String searchContent = '';
  //指定消息发送者 id
  List<String> senderUserIds = [];
  //指定消息类型
  List<String> contentTypes = [];
  //指定会话
  List<Conversation> conversations = [];
  //指定消息状态
  List<int> messageStates = [];
  //指定会话类型
  List<int> conversationTypes = [];
}