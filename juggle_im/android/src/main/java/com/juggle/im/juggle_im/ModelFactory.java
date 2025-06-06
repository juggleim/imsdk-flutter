package com.juggle.im.juggle_im;

import android.text.TextUtils;

import com.juggle.im.JIMConst;
import com.juggle.im.interfaces.GroupMember;
import com.juggle.im.model.Conversation;
import com.juggle.im.model.ConversationInfo;
import com.juggle.im.model.ConversationMentionInfo;
import com.juggle.im.model.GetConversationOptions;
import com.juggle.im.model.GetMessageOptions;
import com.juggle.im.model.GroupInfo;
import com.juggle.im.model.GroupMessageReadInfo;
import com.juggle.im.model.MediaMessageContent;
import com.juggle.im.model.Message;
import com.juggle.im.model.MessageContent;
import com.juggle.im.model.MessageMentionInfo;
import com.juggle.im.model.MessageOptions;
import com.juggle.im.model.MessageReaction;
import com.juggle.im.model.MessageReactionItem;
import com.juggle.im.model.PushData;
import com.juggle.im.model.UserInfo;
import com.juggle.im.model.messages.FileMessage;
import com.juggle.im.model.messages.ImageMessage;
import com.juggle.im.model.messages.RecallInfoMessage;
import com.juggle.im.model.messages.TextMessage;
import com.juggle.im.model.messages.VideoMessage;
import com.juggle.im.model.messages.VoiceMessage;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class ModelFactory {
    static Map<String, Object> conversationToMap(Conversation conversation) {
        Map<String, Object> map = new HashMap<>();
        map.put("conversationType", conversation.getConversationType().getValue());
        map.put("conversationId", conversation.getConversationId());
        return map;
    }

    static Map<String, Object> conversationMentionMessageToMap(ConversationMentionInfo.MentionMsg message) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(message.getSenderId())) {
            map.put("senderId", message.getSenderId());
        }
        if (!TextUtils.isEmpty(message.getMsgId())) {
            map.put("msgId", message.getMsgId());
        }
        map.put("msgTime", message.getMsgTime());
        map.put("type", message.getType().getValue());
        return map;
    }

    static Map<String, Object> conversationMentionInfoToMap(ConversationMentionInfo info) {
        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> list = new ArrayList<>();
        for (ConversationMentionInfo.MentionMsg message : info.getMentionMsgList()) {
            list.add(conversationMentionMessageToMap(message));
        }
        map.put("mentionMsgList", list);
        return map;
    }

    static Map<String, Object> conversationInfoToMap(ConversationInfo info) {
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationToMap(info.getConversation()));
        map.put("unreadCount", info.getUnreadCount());
        map.put("hasUnread", info.hasUnread());
        map.put("sortTime", info.getSortTime());
        if (info.getLastMessage() != null) {
            map.put("lastMessage", messageToMap(info.getLastMessage()));
        }
        map.put("isTop", info.isTop());
        map.put("topTime", info.getTopTime());
        map.put("mute", info.isMute());
        if (!TextUtils.isEmpty(info.getDraft())) {
            map.put("draft", info.getDraft());
        }
        if (info.getMentionInfo() != null) {
            map.put("mentionInfo", conversationMentionInfoToMap(info.getMentionInfo()));
        }
        return map;
    }

    static String messageContentToString(MessageContent content) {
        byte[] bytes = content.encode();
        return new String(bytes, StandardCharsets.UTF_8);
    }

    static Map<String, Object> groupMessageReadInfoToMap(GroupMessageReadInfo info) {
        Map<String, Object> map = new HashMap<>();
        map.put("readCount", info.getReadCount());
        map.put("memberCount", info.getMemberCount());
        return map;
    }

    static Map<String, Object> userInfoToMap(UserInfo info) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(info.getUserId())) {
            map.put("userId", info.getUserId());
        }
        if (!TextUtils.isEmpty(info.getUserName())) {
            map.put("userName", info.getUserName());
        }
        if (!TextUtils.isEmpty(info.getPortrait())) {
            map.put("portrait", info.getPortrait());
        }
        if (info.getExtra() != null) {
            map.put("extraDic", info.getExtra());
        }
        return map;
    }

    static Map<String, Object> groupInfoToMap(GroupInfo info) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(info.getGroupId())) {
            map.put("groupId", info.getGroupId());
        }
        if (!TextUtils.isEmpty(info.getGroupName())) {
            map.put("groupName", info.getGroupName());
        }
        if (!TextUtils.isEmpty(info.getPortrait())) {
            map.put("portrait", info.getPortrait());
        }
        if (info.getExtra() != null) {
            map.put("extraDic", info.getExtra());
        }
        return map;
    }

    static Map<String, Object> groupMemberToMap(GroupMember member) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(member.getGroupId())) {
            map.put("groupId", member.getGroupId());
        }
        if (!TextUtils.isEmpty(member.getUserId())) {
            map.put("userId", member.getUserId());
        }
        if (!TextUtils.isEmpty(member.getGroupDisplayName())) {
            map.put("groupDisplayName", member.getGroupDisplayName());
        }
        if (member.getExtra() != null) {
            map.put("extraDic", member.getExtra());
        }
        return map;
    }

    static Map<String, Object> messageMentionInfoToMap(MessageMentionInfo info) {
        Map<String, Object> map = new HashMap<>();
        map.put("type", info.getType().getValue());
        if (info.getTargetUsers() != null && !info.getTargetUsers().isEmpty()) {
            List<Map<String, Object>> userList = new ArrayList<>();
            for (UserInfo userInfo : info.getTargetUsers()) {
                userList.add(userInfoToMap(userInfo));
            }
            map.put("targetUsers", userList);
        }
        return map;
    }

    static Map<String, Object> messageToMap(Message message) {
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationToMap(message.getConversation()));

        if (!TextUtils.isEmpty(message.getContentType())) {
            map.put("contentType", message.getContentType());
        }
        map.put("clientMsgNo", message.getClientMsgNo());
        if (!TextUtils.isEmpty(message.getMessageId())) {
            map.put("messageId", message.getMessageId());
        }
        map.put("direction", message.getDirection().getValue());
        map.put("messageState", message.getState().getValue());
        map.put("hasRead", message.isHasRead());
        map.put("timestamp", message.getTimestamp());

        if (!TextUtils.isEmpty(message.getSenderUserId())) {
            map.put("senderUserId", message.getSenderUserId());
        }

        if (message.getContent() != null) {
            String contentString = messageContentToString(message.getContent());
            if (!TextUtils.isEmpty(contentString)) {
                map.put("content", contentString);
            }
        }
        if (message.getGroupMessageReadInfo() != null) {
            map.put("groupReadInfo", groupMessageReadInfoToMap(message.getGroupMessageReadInfo()));
        }

        if (message.getMentionInfo() != null) {
            map.put("mentionInfo", messageMentionInfoToMap(message.getMentionInfo()));
        }

        if (message.getReferredMessage() != null) {
            map.put("referredMsg", messageToMap(message.getReferredMessage()));
        }

        if (message.getLocalAttribute() != null) {
            map.put("localAttribute", message.getLocalAttribute());
        }

        map.put("isEdit", message.isEdit());
        return map;
    }

    static Map<String, Object> messageReactionItemToMap(MessageReactionItem item) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(item.getReactionId())) {
            map.put("reactionId", item.getReactionId());
        }

        List<Map<String, Object>> userList = new ArrayList<>();
        if (item.getUserInfoList() != null && !item.getUserInfoList().isEmpty()) {
            for (UserInfo userInfo : item.getUserInfoList()) {
                userList.add(userInfoToMap(userInfo));
            }
        }
        map.put("userInfoList", userList);
        return map;
    }

    static Map<String, Object> messageReactionToMap(MessageReaction reaction) {
        Map<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(reaction.getMessageId())) {
            map.put("messageId", reaction.getMessageId());
        }

        List<Map<String, Object>> itemList = new ArrayList<>();
        if (reaction.getItemList() != null && !reaction.getItemList().isEmpty()) {
            for (MessageReactionItem item : reaction.getItemList()) {
                itemList.add(messageReactionItemToMap(item));
            }
        }
        map.put("itemList", itemList);
        return map;
    }

    static Conversation conversationFromMap(Map<?, ?> map) {
        Integer valueObj = (Integer) map.get("conversationType");
        int value = valueObj != null ? valueObj : 0;
        Conversation.ConversationType type = Conversation.ConversationType.setValue(value);
        String conversationId = (String) map.get("conversationId");
        return new Conversation(type, conversationId);
    }

    static MessageOptions sendMessageOptionFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        MessageOptions option = new MessageOptions();
        if (map.containsKey("mentionInfo")) {
            Map<?, ?> mentionInfoMap = (Map<?, ?>) map.get("mentionInfo");
            option.setMentionInfo(messageMentionInfoFromMap(mentionInfoMap));
        }
        option.setReferredMessageId((String) map.get("referredMsgId"));
        if (map.containsKey("pushData")) {
            option.setPushData(pushDataFromMap((Map<?, ?>) map.get("pushData")));
        }
        return option;
    }

    static GetMessageOptions getMessageOptionFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        GetMessageOptions option = new GetMessageOptions();
        Integer startTimeObj = (Integer) map.get("startTime");
        int startTime = startTimeObj != null ? startTimeObj : 0;
        Integer countObj = (Integer) map.get("count");
        int count = countObj != null ? countObj : 0;
        option.setStartTime(startTime);
        option.setCount(count);
        if (map.containsKey("contentTypes")) {
            option.setContentTypes((List<String>) map.get("contentTypes"));
        }
        return option;
    }

    static MessageMentionInfo messageMentionInfoFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        MessageMentionInfo info = new MessageMentionInfo();
        Object typeObj = map.get("type");
        int type = 0;
        if (typeObj instanceof Number) {
            type = ((Number) typeObj).intValue();
        }
        info.setType(MessageMentionInfo.MentionType.setValue(type));
        List<Map<String, Object>> userDicList = (List) map.get("targetUsers");
        if (userDicList != null && !userDicList.isEmpty()) {
            List<UserInfo> userList = new ArrayList<>();
            for (Map<String, Object> userMap : userDicList) {
                userList.add(userInfoFromMap(userMap));
            }
            info.setTargetUsers(userList);
        }
        return info;
    }

    static UserInfo userInfoFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        UserInfo info = new UserInfo();
        info.setUserId((String) map.get("userId"));
        info.setUserName((String) map.get("userName"));
        info.setPortrait((String) map.get("portrait"));
        info.setExtra((Map) map.get("extraDic"));
        return info;
    }

    static PushData pushDataFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        PushData data = new PushData();
        data.setContent((String) map.get("content"));
        data.setExtra((String) map.get("extra"));
        return data;
    }

    static MessageContent messageContentFromString(String contentString, String contentType) {
        if (TextUtils.isEmpty(contentString) || TextUtils.isEmpty(contentType)) {
            return null;
        }
        byte[] data = contentString.getBytes(StandardCharsets.UTF_8);
        MessageContent content;
        switch (contentType) {
            case "jg:text":
                TextMessage textMessage = new TextMessage();
                textMessage.decode(data);
                content = textMessage;
                break;
            case "jg:file":
                FileMessage fileMessage = new FileMessage();
                fileMessage.decode(data);
                content = fileMessage;
                break;
            case "jg:img":
                ImageMessage imageMessage = new ImageMessage();
                imageMessage.decode(data);
                content = imageMessage;
                break;
            case "jg:recallinfo":
                RecallInfoMessage recallInfoMessage = new RecallInfoMessage();
                recallInfoMessage.decode(data);
                content = recallInfoMessage;
                break;
            case "jg:video":
                VideoMessage videoMessage = new VideoMessage();
                videoMessage.decode(data);
                content = videoMessage;
                break;
            case "jg:voice":
                VoiceMessage voiceMessage = new VoiceMessage();
                voiceMessage.decode(data);
                content = voiceMessage;
                break;
            default:
                content = null;
                break;
        }
        return content;
    }

    static MediaMessageContent mediaMessageContentFromString(String contentString, String contentType) {
        if (TextUtils.isEmpty(contentString) || TextUtils.isEmpty(contentType)) {
            return null;
        }

        byte[] data = contentString.getBytes(StandardCharsets.UTF_8);
        MediaMessageContent content;
        switch (contentType) {
            case "jg:file":
                FileMessage fileMessage = new FileMessage();
                fileMessage.decode(data);
                content = fileMessage;
                break;
            case "jg:img":
                ImageMessage imageMessage = new ImageMessage();
                imageMessage.decode(data);
                content = imageMessage;
                break;
            case "jg:video":
                VideoMessage videoMessage = new VideoMessage();
                videoMessage.decode(data);
                content = videoMessage;
                break;
            case "jg:voice":
                VoiceMessage voiceMessage = new VoiceMessage();
                voiceMessage.decode(data);
                content = voiceMessage;
                break;
            default:
                content = null;
                break;
        }
        return content;
    }

    static GetConversationOptions getConversationOptionsFromMap(Map<?, ?> map) {
        if (map == null) {
            return null;
        }
        GetConversationOptions options = new GetConversationOptions();
        List<Integer> conversationTypeList = (List) map.get("conversationTypes");
        if (conversationTypeList != null) {
            int[] conversationTypes = new int[conversationTypeList.size()];
            for (int i = 0; i < conversationTypeList.size(); i++) {
                conversationTypes[i] = conversationTypeList.get(i);
            }
            options.setConversationTypes(conversationTypes);
        }
        Integer countObject = (Integer) map.get("count");
        int count = countObject != null ? countObject : 0;
        options.setCount(count);
        Integer timestampObject = (Integer) map.get("timestamp");
        long timestamp = timestampObject != null ? timestampObject : 0;
        options.setTimestamp(timestamp);
        Integer directionObject = (Integer) map.get("direction");
        int directionValue = directionObject != null ? directionObject : 0;
        if (directionValue == 0) {
            options.setPullDirection(JIMConst.PullDirection.NEWER);
        } else if (directionValue == 1) {
            options.setPullDirection(JIMConst.PullDirection.OLDER);
        }
        options.setTagId((String) map.get("tagId"));
        return options;
    }
}
