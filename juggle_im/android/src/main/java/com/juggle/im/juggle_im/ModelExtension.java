package com.juggle.im.juggle_im;

import android.text.TextUtils;

import com.juggle.im.JIM;
import com.juggle.im.model.Conversation;
import com.juggle.im.model.ConversationInfo;
import com.juggle.im.model.GroupInfo;
import com.juggle.im.model.Message;
import com.juggle.im.model.UserInfo;

import java.util.Map;

public class ModelExtension {
    static void extendMapForConversationInfo(Map<String, Object> map, ConversationInfo info) {
        if (info.getConversation().getConversationType() == Conversation.ConversationType.PRIVATE) {
            UserInfo userInfo = JIM.getInstance().getUserInfoManager().getUserInfo(info.getConversation().getConversationId());
            if (userInfo != null && !TextUtils.isEmpty(userInfo.getUserName())) {
                map.put("name", userInfo.getUserName());
            }
            if (userInfo != null && !TextUtils.isEmpty(userInfo.getPortrait())) {
                map.put("portrait", userInfo.getPortrait());
            }
            if (userInfo != null && userInfo.getExtra() != null) {
                map.put("extra", userInfo.getExtra());
            }
        } else if (info.getConversation().getConversationType() == Conversation.ConversationType.GROUP) {
            GroupInfo groupInfo = JIM.getInstance().getUserInfoManager().getGroupInfo(info.getConversation().getConversationId());
            if (groupInfo != null && !TextUtils.isEmpty(groupInfo.getGroupName())) {
                map.put("name", groupInfo.getGroupName());
            }
            if (groupInfo != null && !TextUtils.isEmpty(groupInfo.getPortrait())) {
                map.put("portrait", groupInfo.getPortrait());
            }
            if (groupInfo != null && groupInfo.getExtra() != null) {
                map.put("extra", groupInfo.getExtra());
            }
        }
    }

    static void extendMapForMessage(Map<String, Object> map, Message message) {
        UserInfo userInfo = JIM.getInstance().getUserInfoManager().getUserInfo(message.getSenderUserId());
        if (userInfo != null) {
            Map<String, Object> userInfoMap = ModelFactory.userInfoToMap(userInfo);
            map.put("sender", userInfoMap);
        }
    }
}
