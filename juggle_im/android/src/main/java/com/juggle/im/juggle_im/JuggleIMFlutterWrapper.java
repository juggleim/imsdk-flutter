package com.juggle.im.juggle_im;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.juggle.im.JErrorCode;
import com.juggle.im.JIM;
import com.juggle.im.JIMConst;
import com.juggle.im.interfaces.GroupMember;
import com.juggle.im.interfaces.IConnectionManager;
import com.juggle.im.interfaces.IConversationManager;
import com.juggle.im.interfaces.IMessageManager;
import com.juggle.im.internal.logger.JLogConfig;
import com.juggle.im.internal.logger.JLogLevel;
import com.juggle.im.model.Conversation;
import com.juggle.im.model.ConversationInfo;
import com.juggle.im.model.GetConversationOptions;
import com.juggle.im.model.GetMessageOptions;
import com.juggle.im.model.GroupInfo;
import com.juggle.im.model.GroupMessageReadInfo;
import com.juggle.im.model.MediaMessageContent;
import com.juggle.im.model.Message;
import com.juggle.im.model.MessageContent;
import com.juggle.im.model.MessageOptions;
import com.juggle.im.model.MessageReaction;
import com.juggle.im.model.UserInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

 class JuggleIMFlutterWrapper implements IConnectionManager.IConnectionStatusListener, IConversationManager.IConversationListener, IMessageManager.IMessageListener, IMessageManager.IMessageReadReceiptListener {
    public static JuggleIMFlutterWrapper getInstance() {
        return SingletonHolder.sInstance;
    }

    public void setChannel(MethodChannel channel) {
        mChannel = channel;
    }

    public void setContext(Context context) {
        mContext = context;
    }

    private MethodChannel mChannel;
    private Context mContext;

    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "init":
                init(call.arguments, result);
                break;
            case "setServers":
                setServers(call.arguments, result);
                break;
            case "connect":
                connect(call.arguments, result);
                break;
            case "disconnect":
                disconnect(call.arguments, result);
                break;
            case "getConnectionStatus":
                getConnectionStatus(result);
                break;
            case "getConversationInfoList":
                getConversationInfoList(result);
                break;
            case "getConversationInfoListByOption":
                getConversationInfoListByOption(call.arguments, result);
                break;
            case "getConversationInfo":
                getConversationInfo(call.arguments, result);
                break;
            case "deleteConversationInfo":
                deleteConversationInfo(call.arguments, result);
                break;
            case "setDraft":
                setDraft(call.arguments, result);
                break;
            case "createConversationInfo":
                createConversationInfo(call.arguments, result);
                break;
            case "getTotalUnreadCount":
                int count = getTotalUnreadCount(call.arguments);
                result.success(count);
                break;
            case "clearUnreadCount":
                clearUnreadCount(call.arguments, result);
                break;
            case "setMute":
                setMute(call.arguments, result);
                break;
            case "setTop":
                setTop(call.arguments, result);
                break;
            case "clearTotalUnreadCount":
                clearTotalUnreadCount(result);
                break;
            case "setUnread":
                setUnread(call.arguments, result);
                break;
            case "sendMessage":
                sendMessage(call.arguments, result);
                break;
            case "sendMediaMessage":
                sendMediaMessage(call.arguments, result);
                break;
            case "getMessages":
                getMessages(call.arguments, result);
                break;
            case "deleteMessagesByClientMsgNoList":
                deleteMessagesByClientMsgNoList(call.arguments, result);
                break;
            case "deleteMessagesByMessageIdList":
                deleteMessagesByMessageIdList(call.arguments, result);
                break;
            case "recallMessage":
                recallMessage(call.arguments, result);
                break;
            case "clearMessages":
                clearMessages(call.arguments, result);
                break;
            case "getMessagesByMessageIdList":
                getMessagesByMessageIdList(call.arguments, result);
                break;
            case "getMessagesByClientMsgNoList":
                getMessagesByClientMsgNoList(call.arguments, result);
                break;
            case "sendReadReceipt":
                sendReadReceipt(call.arguments, result);
                break;
            case "getGroupMessageReadDetail":
                getGroupMessageReadDetail(call.arguments, result);
                break;
            case "getMergedMessageList":
                getMergedMessageList(call.arguments, result);
                break;
            case "getMentionMessages":
                getMentionMessages(call.arguments, result);
                break;
            case "addMessageReaction":
                addMessageReaction(call.arguments, result);
                break;
            case "removeMessageReaction":
                removeMessageReaction(call.arguments, result);
                break;
            case "getMessagesReaction":
                getMessagesReaction(call.arguments, result);
                break;
            case "updateMessage":
                updateMessage(call.arguments, result);
                break;
            case "setMessageLocalAttribute":
                setMessageLocalAttribute(call.arguments, result);
                break;
            case "getUserInfo":
                getUserInfo(call.arguments, result);
                break;
            case "getGroupInfo":
                getGroupInfo(call.arguments, result);
                break;
            case "getGroupMember":
                getGroupMember(call.arguments, result);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private void init(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String key = (String) map.get("appKey");
            Map<?, ?> config = (Map<?, ?>) map.get("config");
            JIM.InitConfig initConfig = null;
            if (config != null) {
                Map<?, ?> logConfig = (Map<?, ?>) config.get("logConfig");
                if (logConfig != null) {
                    Integer consoleLevel = (Integer) logConfig.get("consoleLevel");
                    if (consoleLevel != null) {
                        initConfig = new JIM.InitConfig.Builder().setJLogConfig(new JLogConfig.Builder(mContext).setLogConsoleLevel(JLogLevel.setValue(consoleLevel)).build()).build();
                    }
                }
            }
            if (initConfig != null) {
                JIM.getInstance().init(mContext, key, initConfig);
            } else {
                JIM.getInstance().init(mContext, key);
            }
        }
        JIM.getInstance().getConnectionManager().addConnectionStatusListener("Flutter", this);
        JIM.getInstance().getConversationManager().addListener("Flutter", this);
        JIM.getInstance().getMessageManager().addListener("Flutter", this);
        JIM.getInstance().getMessageManager().addReadReceiptListener("Flutter", this);
        result.success(null);
    }

    private void setServers(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            List<String> list = (List<String>) map.get("list");
            JIM.getInstance().setServerUrls(list);
        }
        result.success(null);
    }

    private void connect(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String token = (String) map.get("token");
            JIM.getInstance().getConnectionManager().connect(token);
        }
        result.success(null);
    }

    private void disconnect(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            boolean receivePush = (boolean) map.get("receivePush");
            JIM.getInstance().getConnectionManager().disconnect(receivePush);
        }
        result.success(null);
    }

    private void getConnectionStatus(MethodChannel.Result result) {
        int status = JIM.getInstance().getConnectionManager().getConnectionStatus().getStatus();
        result.success(status);
    }

    private void getConversationInfoList(MethodChannel.Result result) {
        List<ConversationInfo> list = JIM.getInstance().getConversationManager().getConversationInfoList();
        List<Map<String, Object>> resultList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> m = ModelFactory.conversationInfoToMap(info);
            ModelExtension.extendMapForConversationInfo(m, info);
            resultList.add(m);
        }
        result.success(resultList);
    }

    private void getConversationInfoListByOption(Object arg, MethodChannel.Result result) {
        List<Map<String, Object>> resultList = new ArrayList<>();
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            GetConversationOptions options = ModelFactory.getConversationOptionsFromMap(map);

            List<ConversationInfo> list = JIM.getInstance().getConversationManager().getConversationInfoList(options);
            if (list != null) {
                for (ConversationInfo info : list) {
                    Map<String, Object> infoMap = ModelFactory.conversationInfoToMap(info);
                    ModelExtension.extendMapForConversationInfo(infoMap, info);
                    resultList.add(infoMap);
                }
            }
        }
        result.success(resultList);
    }

    private void getConversationInfo(Object arg, MethodChannel.Result result) {
        Map<String, Object> resultMap = new HashMap<>();
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            ConversationInfo info = JIM.getInstance().getConversationManager().getConversationInfo(conversation);
            resultMap = ModelFactory.conversationInfoToMap(info);
            ModelExtension.extendMapForConversationInfo(resultMap, info);
        }
        result.success(resultMap);
    }

    private void deleteConversationInfo(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            JIM.getInstance().getConversationManager().deleteConversationInfo(conversation, new IConversationManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int code) {
                    result.success(code);
                }
            });
        } else {
            result.success(JErrorCode.INVALID_PARAM);
        }
    }

    private void setDraft(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            String draft = (String) map.get("draft");
            JIM.getInstance().getConversationManager().setDraft(conversation, draft);
        }
        result.success(null);
    }

    private void createConversationInfo(Object arg, MethodChannel.Result result) {
        Map<String, Object> resultMap = new HashMap<>();
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            JIM.getInstance().getConversationManager().createConversationInfo(conversation, new IConversationManager.ICreateConversationInfoCallback() {
                @Override
                public void onSuccess(ConversationInfo conversationInfo) {
                    Map<String, Object> conversationInfoMap = ModelFactory.conversationInfoToMap(conversationInfo);
                    ModelExtension.extendMapForConversationInfo(conversationInfoMap, conversationInfo);
                    resultMap.put("conversationInfo", conversationInfoMap);
                    result.success(resultMap);
                }

                @Override
                public void onError(int code) {
                    resultMap.put("errorCode", code);
                    result.success(resultMap);
                }
            });
        } else {
            resultMap.put("errorCode", JErrorCode.INVALID_PARAM);
            result.success(resultMap);
        }
    }

    private int getTotalUnreadCount(Object arg) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            List<Integer> conversationTypeList = (List<Integer>) map.get("conversationTypes");
            if (conversationTypeList != null) {
                int[] conversationTypes = new int[conversationTypeList.size()];
                for (int i = 0; i < conversationTypeList.size(); i++) {
                    conversationTypes[i] = conversationTypeList.get(i);
                }
                return JIM.getInstance().getConversationManager().getUnreadCountWithTypes(conversationTypes);
            }
        }
        return JIM.getInstance().getConversationManager().getTotalUnreadCount();
    }

    private void clearUnreadCount(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            JIM.getInstance().getConversationManager().clearUnreadCount(conversation, new IConversationManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int i) {
                    result.success(i);
                }
            });
        } else {
            result.success(JErrorCode.INVALID_PARAM);
        }
    }

    private void setMute(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            boolean isMute = (boolean) map.get("isMute");
            JIM.getInstance().getConversationManager().setMute(conversation, isMute, new IConversationManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int i) {
                    result.success(i);
                }
            });
        } else {
            result.success(JErrorCode.INVALID_PARAM);
        }
    }

    private void setTop(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            boolean isTop = (boolean) map.get("isTop");
            JIM.getInstance().getConversationManager().setTop(conversation, isTop, new IConversationManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int i) {
                    result.success(i);
                }
            });
        } else {
            result.success(JErrorCode.INVALID_PARAM);
        }
    }

    private void clearTotalUnreadCount(MethodChannel.Result result) {
        JIM.getInstance().getConversationManager().clearTotalUnreadCount(new IConversationManager.ISimpleCallback() {
            @Override
            public void onSuccess() {
                result.success(JErrorCode.NONE);
            }

            @Override
            public void onError(int i) {
                result.success(i);
            }
        });
    }

    private void setUnread(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            JIM.getInstance().getConversationManager().setUnread(conversation, new IConversationManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int i) {
                    result.success(i);
                }
            });
        } else {
            result.success(JErrorCode.INVALID_PARAM);
        }
    }

    private void sendMessage(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String contentString = (String) map.get("content");
            String contentType = (String) map.get("contentType");
            MessageContent content = ModelFactory.messageContentFromString(contentString, contentType);
            Conversation conversation = ModelFactory.conversationFromMap((Map<?,?>) Objects.requireNonNull(map.get("conversation")));
            MessageOptions options = null;
            Map<?, ?> optionsMap = (Map<?, ?>) map.get("option");
            if (optionsMap != null) {
                options = ModelFactory.sendMessageOptionFromMap(optionsMap);
            }
            if (content != null) {
                Message message = JIM.getInstance().getMessageManager().sendMessage(content, conversation, options, new IMessageManager.ISendMessageCallback() {
                    @Override
                    public void onSuccess(Message message) {
                        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("message", messageMap);
                        mChannel.invokeMethod("onMessageSendSuccess", resultMap);
                    }

                    @Override
                    public void onError(Message message, int i) {
                        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("message", messageMap);
                        resultMap.put("errorCode", i);
                        mChannel.invokeMethod("onMessageSendError", resultMap);
                    }
                });
                Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                result.success(messageMap);
            }
        } else {
            result.success(new HashMap<>());
        }
    }

    private void sendMediaMessage(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String contentString = (String) map.get("content");
            String contentType = (String) map.get("contentType");
            MediaMessageContent content = ModelFactory.mediaMessageContentFromString(contentString, contentType);
            Conversation conversation = ModelFactory.conversationFromMap((Map<?,?>) Objects.requireNonNull(map.get("conversation")));
            MessageOptions options = null;
            Map<?, ?> optionsMap = (Map<?, ?>) map.get("option");
            if (optionsMap != null) {
                options = ModelFactory.sendMessageOptionFromMap(optionsMap);
            }
            if (content != null) {
                Message message = JIM.getInstance().getMessageManager().sendMediaMessage(content, conversation, options, new IMessageManager.ISendMediaMessageCallback() {
                    @Override
                    public void onProgress(int i, Message message) {
                        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("message", messageMap);
                        resultMap.put("progress", i);
                        mChannel.invokeMethod("onMessageProgress", resultMap);
                    }

                    @Override
                    public void onSuccess(Message message) {
                        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("message", messageMap);
                        mChannel.invokeMethod("onMessageSendSuccess", resultMap);
                    }

                    @Override
                    public void onError(Message message, int i) {
                        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("message", messageMap);
                        resultMap.put("errorCode", i);
                        mChannel.invokeMethod("onMessageSendError", resultMap);
                    }

                    @Override
                    public void onCancel(Message message) {
                    }
                });
                Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                result.success(messageMap);
            }
        } else {
            result.success(new HashMap<>());
        }
    }

    private void getMessages(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            int directionValue = (int) map.get("direction");
            JIMConst.PullDirection direction = JIMConst.PullDirection.OLDER;
            if (directionValue == 0) {
                direction = JIMConst.PullDirection.NEWER;
            }
            GetMessageOptions option = ModelFactory.getMessageOptionFromMap((Map<?, ?>) map.get("option"));
            JIM.getInstance().getMessageManager().getMessages(conversation, direction, option, new IMessageManager.IGetMessagesCallbackV3() {
                @Override
                public void onGetMessages(List<Message> list, long timestamp, boolean hasMore, int errorCode) {
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("timestamp", timestamp);
                    resultMap.put("hasMore", hasMore);
                    resultMap.put("errorCode", errorCode);
                    if (list != null && !list.isEmpty()) {
                        List<Map<String, Object>> mapList = new ArrayList<>();
                        for (Message m : list) {
                            Map<String, Object> messageMap = ModelFactory.messageToMap(m);
                            ModelExtension.extendMapForMessage(messageMap, m);
                            mapList.add(messageMap);
                        }
                        resultMap.put("messages", mapList);
                    }
                    result.success(resultMap);
                }
            });
        }
    }

    private void deleteMessagesByClientMsgNoList(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            List<Long> clientMsgNoList = (List<Long>) map.get("clientMsgNoList");
            boolean forAllUsers = false;
            if (map.containsKey("forAllUsers")) {
                forAllUsers = (boolean) map.get("forAllUsers");
            }
            JIM.getInstance().getMessageManager().deleteMessagesByClientMsgNoList(conversation, clientMsgNoList, forAllUsers, new IMessageManager.ISimpleCallback() {
                @Override
                public void onSuccess() {
                    result.success(JErrorCode.NONE);
                }

                @Override
                public void onError(int i) {
                    result.success(i);
                }
            });
        }
    }

     private void deleteMessagesByMessageIdList(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             List<String> messageIdList = (List<String>) map.get("messageIdList");
             boolean forAllUsers = false;
             if (map.containsKey("forAllUsers")) {
                 forAllUsers = (boolean) map.get("forAllUsers");
             }
             JIM.getInstance().getMessageManager().deleteMessagesByMessageIdList(conversation, messageIdList, forAllUsers, new IMessageManager.ISimpleCallback() {
                 @Override
                 public void onSuccess() {
                     result.success(JErrorCode.NONE);
                 }

                 @Override
                 public void onError(int i) {
                     result.success(i);
                 }
             });
         }
     }

     private void recallMessage(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             String messageId = (String) map.get("messageId");
             Map<String, String> extra = (Map) map.get("extra");
             JIM.getInstance().getMessageManager().recallMessage(messageId, extra, new IMessageManager.IRecallMessageCallback() {
                 @Override
                 public void onSuccess(Message message) {
                     Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("message", messageMap);
                     resultMap.put("errorCode", JErrorCode.NONE);
                     result.success(resultMap);
                 }

                 @Override
                 public void onError(int i) {
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("errorCode", i);
                    result.success(resultMap);
                 }
             });
         }
     }

     private void clearMessages(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             Integer startTimeInteger = (Integer) map.get("startTime");
             long startTime = 0;
             if (startTimeInteger != null) {
                 startTime = startTimeInteger.longValue();
             }
             boolean forAllUsers = false;
             if (map.containsKey("forAllUsers")) {
                 forAllUsers = (boolean) map.get("forAllUsers");
             }
             JIM.getInstance().getMessageManager().clearMessages(conversation, startTime, forAllUsers, new IMessageManager.ISimpleCallback() {
                 @Override
                 public void onSuccess() {
                     result.success(JErrorCode.NONE);
                 }

                 @Override
                 public void onError(int i) {
                    result.success(i);
                 }
             });
         }
     }

     private void getMessagesByMessageIdList(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             List<String> messageIdList = (List<String>) map.get("messageIdList");
             List<Message> messageList = JIM.getInstance().getMessageManager().getMessagesByMessageIds(messageIdList);
             List<Map<String, Object>> resultList = new ArrayList<>();
             if (messageList != null && !messageList.isEmpty()) {
                 for (Message message : messageList) {
                     Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                     ModelExtension.extendMapForMessage(messageMap, message);
                     resultList.add(messageMap);
                 }
             }
             result.success(resultList);
         }
    }

     private void getMessagesByClientMsgNoList(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             List<Integer> clientMsgNoList = (List<Integer>) map.get("clientMsgNoList");
             long[] clientMsgNos = new long[10000];
             if (clientMsgNoList != null && !clientMsgNoList.isEmpty()) {
                 for (int i = 0; i < clientMsgNoList.size(); i++) {
                     clientMsgNos[i] = clientMsgNoList.get(i).longValue();
                 }
             }
             List<Message> messageList = JIM.getInstance().getMessageManager().getMessagesByClientMsgNos(clientMsgNos);
             List<Map<String, Object>> resultList = new ArrayList<>();
             if (messageList != null && !messageList.isEmpty()) {
                 for (Message message : messageList) {
                     Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                     ModelExtension.extendMapForMessage(messageMap, message);
                     resultList.add(messageMap);
                 }
             }
             result.success(resultList);
         }
     }

     private void sendReadReceipt(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             List<String> messageIdList = (List<String>) map.get("messageIdList");
             JIM.getInstance().getMessageManager().sendReadReceipt(conversation, messageIdList, new IMessageManager.ISendReadReceiptCallback() {
                 @Override
                 public void onSuccess() {
                     result.success(JErrorCode.NONE);
                 }

                 @Override
                 public void onError(int i) {
                    result.success(i);
                 }
             });
         }
     }

     private void getGroupMessageReadDetail(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             String messageId = (String) map.get("messageId");
             JIM.getInstance().getMessageManager().getGroupMessageReadDetail(conversation, messageId, new IMessageManager.IGetGroupMessageReadDetailCallback() {
                 @Override
                 public void onSuccess(List<UserInfo> readMembers, List<UserInfo> unreadMembers) {
                     Map<String, Object> resultMap = new HashMap<>();
                     List<Map<String, Object>> readMemberMapList = new ArrayList<>();
                     List<Map<String, Object>> unreadMemberMapList = new ArrayList<>();
                     for (UserInfo userInfo : readMembers) {
                         Map<String, Object> readMemberMap = ModelFactory.userInfoToMap(userInfo);
                         readMemberMapList.add(readMemberMap);
                     }
                     for (UserInfo userInfo : unreadMembers) {
                         Map<String, Object> unreadMemberMap = ModelFactory.userInfoToMap(userInfo);
                         unreadMemberMapList.add(unreadMemberMap);
                     }
                     resultMap.put("errorCode", JErrorCode.NONE);
                     resultMap.put("readMembers", readMemberMapList);
                     resultMap.put("unreadMembers", unreadMemberMapList);
                     result.success(resultMap);
                 }

                 @Override
                 public void onError(int i) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", i);
                    result.success(resultMap);
                 }
             });
         }
     }

     private void getMergedMessageList(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             String messageId = (String) map.get("messageId");
             JIM.getInstance().getMessageManager().getMergedMessageList(messageId, new IMessageManager.IGetMessagesCallback() {
                 @Override
                 public void onSuccess(List<Message> mergedMessages) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", JErrorCode.NONE);
                     List<Map<String, Object>> messageMapList = new ArrayList<>();
                     for (Message message : mergedMessages) {
                         Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                         ModelExtension.extendMapForMessage(messageMap, message);
                         messageMapList.add(messageMap);
                     }
                     resultMap.put("messages", messageMapList);
                     result.success(resultMap);
                 }

                 @Override
                 public void onError(int i) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", i);
                     result.success(resultMap);
                 }
             });
         }
     }

     private void getMentionMessages(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             int count = (int) map.get("count");
             long timestamp = 0;
             Integer timestampInteger = (Integer) map.get("timestamp");
             if (timestampInteger != null) {
                 timestamp = timestampInteger.longValue();
             }
             int directionValue = (int) map.get("direction");
             JIMConst.PullDirection direction = JIMConst.PullDirection.OLDER;
             if (directionValue == 0) {
                 direction = JIMConst.PullDirection.NEWER;
             }
             JIM.getInstance().getMessageManager().getMentionMessageList(conversation, count, timestamp, direction, new IMessageManager.IGetMessagesWithFinishCallback() {
                 @Override
                 public void onSuccess(List<Message> messages, boolean isFinished) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", JErrorCode.NONE);
                     List<Map<String, Object>> messageMapList = new ArrayList<>();
                     for (Message message : messages) {
                         Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                         ModelExtension.extendMapForMessage(messageMap, message);
                         messageMapList.add(messageMap);
                     }
                     resultMap.put("messages", messageMapList);
                     resultMap.put("isFinished", isFinished);
                     result.success(resultMap);
                 }

                 @Override
                 public void onError(int i) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", i);
                     result.success(resultMap);
                 }
             });
         }
     }

     private void addMessageReaction(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             String messageId = (String) map.get("messageId");
             String reactionId = (String) map.get("reactionId");
             JIM.getInstance().getMessageManager().addMessageReaction(messageId, conversation, reactionId, new IMessageManager.ISimpleCallback() {
                 @Override
                 public void onSuccess() {
                     result.success(JErrorCode.NONE);
                 }

                 @Override
                 public void onError(int i) {
                     result.success(i);
                 }
             });
         }
     }

     private void removeMessageReaction(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             String messageId = (String) map.get("messageId");
             String reactionId = (String) map.get("reactionId");
             JIM.getInstance().getMessageManager().removeMessageReaction(messageId, conversation, reactionId, new IMessageManager.ISimpleCallback() {
                 @Override
                 public void onSuccess() {
                     result.success(JErrorCode.NONE);
                 }

                 @Override
                 public void onError(int i) {
                     result.success(i);
                 }
             });
         }
     }

     private void getMessagesReaction(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
             List<String> messageIdList = (List<String>) map.get("messageIdList");
             JIM.getInstance().getMessageManager().getMessagesReaction(messageIdList, conversation, new IMessageManager.IMessageReactionListCallback() {
                 @Override
                 public void onSuccess(List<MessageReaction> reactionList) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", JErrorCode.NONE);
                     List<Map<String, Object>> reactionMapList = new ArrayList<>();
                     for (MessageReaction reaction : reactionList) {
                         Map<String, Object> reactionMap = ModelFactory.messageReactionToMap(reaction);
                         reactionMapList.add(reactionMap);
                     }
                     resultMap.put("reactionList", reactionMapList);
                     result.success(resultMap);
                 }

                 @Override
                 public void onError(int i) {
                     Map<String, Object> resultMap = new HashMap<>();
                     resultMap.put("errorCode", i);
                     result.success(resultMap);
                 }
             });
         }
     }

    private void updateMessage(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            String contentString = (String) map.get("content");
            String contentType = (String) map.get("contentType");
            MessageContent content = ModelFactory.messageContentFromString(contentString, contentType);
            String messageId = (String) map.get("messageId");
            JIM.getInstance().getMessageManager().updateMessage(messageId, content, conversation, new IMessageManager.IMessageCallback() {
                @Override
                public void onSuccess(Message message) {
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("errorCode", JErrorCode.NONE);
                    Map<String, Object> messageMap = ModelFactory.messageToMap(message);
                    resultMap.put("message", messageMap);
                    result.success(resultMap);
                }

                @Override
                public void onError(int i) {
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("errorCode", i);
                    result.success(resultMap);
                }
            });
        }
    }

    private void setMessageLocalAttribute(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Integer clientMsgNo = (Integer) map.get("clientMsgNo");
            String attribute = (String) map.get("attribute");
            assert clientMsgNo != null;
            JIM.getInstance().getMessageManager().setLocalAttribute(clientMsgNo.longValue(), attribute);
            result.success(null);
        }
    }

    private void getUserInfo(Object arg, MethodChannel.Result result) {
        String userId = (String) arg;
        UserInfo userInfo = JIM.getInstance().getUserInfoManager().getUserInfo(userId);
        Map<String, Object> map = ModelFactory.userInfoToMap(userInfo);
        result.success(map);
    }

    private void getGroupInfo(Object arg, MethodChannel.Result result) {
        String groupId = (String) arg;
        GroupInfo groupInfo = JIM.getInstance().getUserInfoManager().getGroupInfo(groupId);
        Map<String, Object> map = ModelFactory.groupInfoToMap(groupInfo);
        result.success(map);
    }

    private void getGroupMember(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String groupId = (String) map.get("groupId");
            String userId = (String) map.get("userId");
            GroupMember member = JIM.getInstance().getUserInfoManager().getGroupMember(groupId, userId);
            Map<String, Object> resultMap = ModelFactory.groupMemberToMap(member);
            result.success(resultMap);
        }
    }

    @Override
    public void onStatusChange(JIMConst.ConnectionStatus connectionStatus, int code, String extra) {
        Map<String, Object> map = new HashMap<>();
        map.put("status", connectionStatus.getStatus());
        map.put("code", code);
        if (!TextUtils.isEmpty(extra)) {
            map.put("extra", extra);
        }
        mChannel.invokeMethod("onConnectionStatusChange", map);
    }

    @Override
    public void onDbOpen() {
        mChannel.invokeMethod("onDbOpen", null);
    }

    @Override
    public void onDbClose() {
        mChannel.invokeMethod("onDbClose", null);
    }

    @Override
    public void onConversationInfoAdd(List<ConversationInfo> list) {
        List<Map<String, Object>> mapList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> infoMap = ModelFactory.conversationInfoToMap(info);
            ModelExtension.extendMapForConversationInfo(infoMap, info);
            mapList.add(infoMap);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("conversationInfoList", mapList);
        mChannel.invokeMethod("onConversationInfoAdd", map);
    }

    @Override
    public void onConversationInfoUpdate(List<ConversationInfo> list) {
        List<Map<String, Object>> mapList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> infoMap = ModelFactory.conversationInfoToMap(info);
            ModelExtension.extendMapForConversationInfo(infoMap, info);
            mapList.add(infoMap);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("conversationInfoList", mapList);
        mChannel.invokeMethod("onConversationInfoUpdate", map);
    }

    @Override
    public void onConversationInfoDelete(List<ConversationInfo> list) {
        List<Map<String, Object>> mapList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> infoMap = ModelFactory.conversationInfoToMap(info);
            ModelExtension.extendMapForConversationInfo(infoMap, info);
            mapList.add(infoMap);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("conversationInfoList", mapList);
        mChannel.invokeMethod("onConversationInfoDelete", map);
    }

    @Override
    public void onTotalUnreadMessageCountUpdate(int i) {
        Map<String, Object> map = new HashMap<>();
        map.put("count", i);
        mChannel.invokeMethod("onTotalUnreadMessageCountUpdate", map);
    }

    @Override
    public void onMessageReceive(Message message) {
        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
        ModelExtension.extendMapForMessage(messageMap, message);
        mChannel.invokeMethod("onMessageReceive", messageMap);
    }

    @Override
    public void onMessageRecall(Message message) {
        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
        ModelExtension.extendMapForMessage(messageMap, message);
        mChannel.invokeMethod("onMessageRecall", messageMap);
    }

    @Override
    public void onMessageDelete(Conversation conversation, List<Long> list) {
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationMap);
        map.put("clientMsgNoList", list);
        mChannel.invokeMethod("onMessageDelete", map);
    }

    @Override
    public void onMessageClear(Conversation conversation, long timestamp, String senderId) {
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationMap);
        map.put("timestamp", timestamp);
        if (!TextUtils.isEmpty(senderId)) {
            map.put("senderId", senderId);
        }
        mChannel.invokeMethod("onMessageClear", map);
    }

    @Override
    public void onMessageUpdate(Message message) {
        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
        ModelExtension.extendMapForMessage(messageMap, message);
        mChannel.invokeMethod("onMessageUpdate", messageMap);
    }

    @Override
    public void onMessageReactionAdd(Conversation conversation, MessageReaction messageReaction) {
        Map<String, Object> reactionMap = ModelFactory.messageReactionToMap(messageReaction);
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> map = new HashMap<>();
        map.put("reaction", reactionMap);
        map.put("conversation", conversationMap);
        mChannel.invokeMethod("onMessageReactionAdd", map);
    }

    @Override
    public void onMessageReactionRemove(Conversation conversation, MessageReaction messageReaction) {
        Map<String, Object> reactionMap = ModelFactory.messageReactionToMap(messageReaction);
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> map = new HashMap<>();
        map.put("reaction", reactionMap);
        map.put("conversation", conversationMap);
        mChannel.invokeMethod("onMessageReactionRemove", map);
    }

    @Override
    public void onMessagesRead(Conversation conversation, List<String> list) {
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationMap);
        map.put("messageIdList", list);
        mChannel.invokeMethod("onMessagesRead", map);
    }

    @Override
    public void onGroupMessagesRead(Conversation conversation, Map<String, GroupMessageReadInfo> msgs) {
        Map<String, Object> conversationMap = ModelFactory.conversationToMap(conversation);
        Map<String, Object> msgMap = new HashMap<>();
        for (Map.Entry<String, GroupMessageReadInfo> entry : msgs.entrySet()) {
            String messageId = entry.getKey();
            GroupMessageReadInfo info = entry.getValue();
            Map<String, Object> infoMap = ModelFactory.groupMessageReadInfoToMap(info);
            msgMap.put(messageId, infoMap);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("conversation", conversationMap);
        map.put("messages", msgMap);
        mChannel.invokeMethod("onGroupMessagesRead", map);
    }

    private static class SingletonHolder {
        static final JuggleIMFlutterWrapper sInstance = new JuggleIMFlutterWrapper();
    }
}
