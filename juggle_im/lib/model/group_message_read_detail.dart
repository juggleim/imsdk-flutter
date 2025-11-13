import 'package:juggle_im/model/group_message_member_read_detail.dart';

class GroupMessageReadDetail {
  int readCount = 0;
  int memberCount = 0;
  List<GroupMessageMemberReadDetail> readMembers = [];
  List<GroupMessageMemberReadDetail> unreadMembers = [];
}