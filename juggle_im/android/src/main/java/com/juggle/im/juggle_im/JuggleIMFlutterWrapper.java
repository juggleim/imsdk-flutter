package com.juggle.im.juggle_im;

import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.juggle.im.JErrorCode;
import com.juggle.im.JIM;
import com.juggle.im.JIMConst;
import com.juggle.im.call.CallConst;
import com.juggle.im.call.ICallManager;
import com.juggle.im.call.ICallSession;
import com.juggle.im.call.model.CallInfo;
import com.juggle.im.model.FavoriteMessage;
import com.juggle.im.model.FriendInfo;
import com.juggle.im.model.GetFavoriteMessageOption;
import com.juggle.im.model.GetMomentCommentOption;
import com.juggle.im.model.GetMomentOption;
import com.juggle.im.model.GroupMember;
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
import com.juggle.im.model.GroupMessageMemberReadDetail;
import com.juggle.im.model.GroupMessageReadInfo;
import com.juggle.im.model.GroupMessageReadInfoDetail;
import com.juggle.im.model.MediaMessageContent;
import com.juggle.im.model.Message;
import com.juggle.im.model.MessageContent;
import com.juggle.im.model.MessageOptions;
import com.juggle.im.model.MessageQueryOptions;
import com.juggle.im.model.MessageReaction;
import com.juggle.im.model.Moment;
import com.juggle.im.model.MomentComment;
import com.juggle.im.model.MomentMedia;
import com.juggle.im.model.MomentReaction;
import com.juggle.im.model.SearchConversationsResult;
import com.juggle.im.model.UserInfo;
import com.juggle.im.model.messages.UnknownMessage;
import com.juggle.im.push.PushConfig;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

 class JuggleIMFlutterWrapper implements IConnectionManager.IConnectionStatusListener, IConversationManager.IConversationListener, IMessageManager.IMessageListener, IMessageManager.IMessageReadReceiptListener, IMessageManager.IMessageDestroyListener, ICallManager.ICallReceiveListener, CallSessionListenerImpl.ICallSessionListenerDestruct, ICallManager.IConversationCallListener {
    public static JuggleIMFlutterWrapper getInstance() {
        return SingletonHolder.sInstance;
    }

    public void setChannel(MethodChannel channel) {
        mChannel = channel;
    }

    public void setContext(Context context) {
        mContext = context;
    }

    public void setVideoPlatformViewFactory(VideoPlatformViewFactory factory) {
        mFactory = factory;
    }

    private MethodChannel mChannel;
    private Context mContext;
    private VideoPlatformViewFactory mFactory;
    private final Map<String, CallSessionListenerImpl> mCallSessionListenerMap = new HashMap<>();

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
            case "resendMessage":
                resendMessage(call.arguments, result);
                break;
            case "resendMediaMessage":
                resendMediaMessage(call.arguments, result);
                break;
            case "getMessages":
                getMessages(call.arguments, result);
                break;
            case "searchMessagesInConversation":
                searchMessagesInConversation(call.arguments, result);
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
            case "getCachedMessagesReaction":
                getCachedMessagesReaction(call.arguments, result);
                break;
            case "updateMessage":
                updateMessage(call.arguments, result);
                break;
            case "downloadMediaMessage":
                downloadMediaMessage(call.arguments, result);
                break;
            case "setMessageLocalAttribute":
                setMessageLocalAttribute(call.arguments, result);
                break;
            case "setMessageTop":
                setMessageTop(call.arguments, result);
                break;
            case "getTopMessage":
                getTopMessage(call.arguments, result);
                break;
            case "addFavoriteMessages":
                addFavoriteMessages(call.arguments, result);
                break;
            case "removeFavoriteMessages":
                removeFavoriteMessages(call.arguments, result);
                break;
            case "getFavoriteMessages":
                getFavoriteMessages(call.arguments, result);
                break;
            case "getTimeDifference":
                getTimeDifference(call.arguments, result);
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
            case "getFriendInfo":
                getFriendInfo(call.arguments, result);
                break;
            case "fetchUserInfo":
                fetchUserInfo(call.arguments, result);
                break;
            case "fetchGroupInfo":
                fetchGroupInfo(call.arguments, result);
                break;
            case "fetchFriendInfo":
                fetchFriendInfo(call.arguments, result);
                break;
            case "initZegoEngine":
                initZegoEngine(call.arguments, result);
                break;
            case "initAgoraEngine":
                initAgoraEngine(call.arguments, result);
                break;
            case "startSingleCall":
                startSingleCall(call.arguments, result);
                break;
            case "startMultiCall":
                startMultiCall(call.arguments, result);
                break;
            case "joinCall":
                joinCall(call.arguments, result);
                break;
            case "getConversationCallInfo":
                getConversationCallInfo(call.arguments, result);
                break;
            case "getCallSession":
                getCallSession(call.arguments, result);
                break;
            case "callAccept":
                callAccept(call.arguments, result);
                break;
            case "callHangup":
                callHangup(call.arguments, result);
                break;
            case "callEnableCamera":
                callEnableCamera(call.arguments, result);
                break;
            case "callMuteMicrophone":
                callMuteMicrophone(call.arguments, result);
                break;
            case "callMuteSpeaker":
                callMuteSpeaker(call.arguments, result);
                break;
            case "callSetSpeakerEnable":
                callSetSpeakerEnable(call.arguments, result);
                break;
            case "callUseFrontCamera":
                callUseFrontCamera(call.arguments, result);
                break;
            case "callInviteUsers":
                callInviteUsers(call.arguments, result);
                break;
            case "callSetVideoView":
                callSetVideoView(call.arguments, result);
                break;
            case "callStartPreview":
                callStartPreview(call.arguments, result);
                break;
            case "searchConversationsWithMessageContent":
                searchConversationsWithMessageContent(call.arguments, result);
                break;
            case "addMoment":
                addMoment(call.arguments, result);
                break;
            case "removeMoment":
                removeMoment(call.arguments, result);
                break;
            case "getCachedMomentList":
                getCachedMomentList(call.arguments, result);
                break;
            case "getMomentList":
                getMomentList(call.arguments, result);
                break;
            case "getMoment":
                getMoment(call.arguments, result);
                break;
            case "addComment":
                addComment(call.arguments, result);
                break;
            case "removeComment":
                removeComment(call.arguments, result);
                break;
            case "getCommentList":
                getCommentList(call.arguments, result);
                break;
            case "addMomentReaction":
                addMomentReaction(call.arguments, result);
                break;
            case "removeMomentReaction":
                removeMomentReaction(call.arguments, result);
                break;
            case "getReactionList":
                getReactionList(call.arguments, result);
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
                JIM.InitConfig.Builder initConfigBuilder = new JIM.InitConfig.Builder();
                Map<?, ?> logConfigMap = (Map<?, ?>) config.get("logConfig");
                if (logConfigMap != null) {
                    Integer consoleLevel = (Integer) logConfigMap.get("consoleLevel");
                    if (consoleLevel != null) {
                        JLogConfig logConfig = new JLogConfig.Builder(mContext).setLogConsoleLevel(JLogLevel.setValue(consoleLevel)).build();
                        initConfigBuilder.setJLogConfig(logConfig);
                    }
                }
                Map<?, ?> pushConfigMap = (Map<?, ?>) config.get("pushConfig");
                if (pushConfigMap != null) {
                    PushConfig.Builder pushConfigBuilder = new PushConfig.Builder();
                    Map<?, ?> xmConfigMap = (Map<?, ?>) pushConfigMap.get("xmConfig");
                    if (xmConfigMap != null) {
                        String appId = (String) xmConfigMap.get("appId");
                        String appKey = (String) xmConfigMap.get("appKey");
                        pushConfigBuilder.setXmConfig(appId, appKey);
                    }
                    Map<?, ?> hwConfigMap = (Map<?, ?>) pushConfigMap.get("hwConfig");
                    if (hwConfigMap != null) {
                        String appId = (String) hwConfigMap.get("appId");
                        pushConfigBuilder.setHwConfig(appId);
                    }
                    String vivoConfigString = (String) pushConfigMap.get("vivoConfig");
                    if (vivoConfigString != null) {
                        pushConfigBuilder.setVivoConfig();
                    }
                    Map<?, ?> oppoConfigMap = (Map<?, ?>) pushConfigMap.get("oppoConfig");
                    if (oppoConfigMap != null) {
                        String appKey = (String) oppoConfigMap.get("appKey");
                        String appSecret = (String) oppoConfigMap.get("appSecret");
                        pushConfigBuilder.setOppoConfig(appKey, appSecret);
                    }
                    String jgConfigString = (String) pushConfigMap.get("jgConfig");
                    if (jgConfigString != null) {
                        pushConfigBuilder.setJgConfig();
                    }
                    PushConfig pushConfig = pushConfigBuilder.build();
                    initConfigBuilder.setPushConfig(pushConfig);
                }
                initConfig = initConfigBuilder.build();
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
        JIM.getInstance().getMessageManager().addDestroyListener("Flutter", this);
        JIM.getInstance().getCallManager().addReceiveListener("Flutter", this);
        JIM.getInstance().getCallManager().addConversationCallListener("Flutter", this);
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

    private void getTimeDifference(Object arg, MethodChannel.Result result) {
        long diff = JIM.getInstance().getTimeDifference();
        result.success(diff);
    }

    private void getConversationInfoList(MethodChannel.Result result) {
        List<ConversationInfo> list = JIM.getInstance().getConversationManager().getConversationInfoList();
        List<Map<String, Object>> resultList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> m = ModelFactory.conversationInfoToMap(info);
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
            int flags = (int) map.get("flag");
            MessageContent content = ModelFactory.messageContentFromString(contentString, contentType);
            if (content instanceof UnknownMessage) {
                UnknownMessage unknownMessage = (UnknownMessage) content;
                unknownMessage.setFlags(flags);
            }

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

    private void resendMessage(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Message message = ModelFactory.messageFromMap((Map<?, ?>) map.get("message"));
            Message returnMessage = JIM.getInstance().getMessageManager().resendMessage(message, new IMessageManager.ISendMessageCallback() {
                @Override
                public void onSuccess(Message successMessage) {
                    Map<String, Object> messageMap = ModelFactory.messageToMap(successMessage);
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("message", messageMap);
                    mChannel.invokeMethod("onMessageSendSuccess", resultMap);
                }

                @Override
                public void onError(Message errorMessage, int i) {
                    Map<String, Object> messageMap = ModelFactory.messageToMap(errorMessage);
                    Map<String, Object> resultMap = new HashMap<>();
                    resultMap.put("message", messageMap);
                    resultMap.put("errorCode", i);
                    mChannel.invokeMethod("onMessageSendError", resultMap);
                }
            });
            Map<String, Object> messageMap = ModelFactory.messageToMap(returnMessage);
            result.success(messageMap);
        } else {
            result.success(new HashMap<>());
        }
    }

    private void resendMediaMessage(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Map<?, ?> messageMap = (Map<?, ?>) map.get("message");
            Message message = ModelFactory.messageFromMap(messageMap);
            Message returnMessage = JIM.getInstance().getMessageManager().resendMediaMessage(message, new IMessageManager.ISendMediaMessageCallback() {
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
            Map<String, Object> returnMessageMap = ModelFactory.messageToMap(returnMessage);
            result.success(returnMessageMap);
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
                            mapList.add(messageMap);
                        }
                        resultMap.put("messages", mapList);
                    }
                    result.success(resultMap);
                }
            });
        }
    }

    private void searchMessagesInConversation(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String searchContent = (String) map.get("searchContent");
        Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
        int directionValue = (int) map.get("direction");
        JIMConst.PullDirection direction = JIMConst.PullDirection.OLDER;
        if (directionValue == 0) {
            direction = JIMConst.PullDirection.NEWER;
        }
        GetMessageOptions option = ModelFactory.getMessageOptionFromMap((Map<?, ?>) map.get("option"));
        if (option == null) {
            result.success(new ArrayList<>());
            return;
        }
        List<Message> messages = JIM.getInstance().getMessageManager().searchMessageInConversation(conversation, searchContent, option.getCount(), option.getStartTime(), direction, option.getContentTypes());
        List<Map<String, Object>> mapList = new ArrayList<>();
        if (messages != null && !messages.isEmpty()) {
            for (Message m : messages) {
                Map<String, Object> messageMap = ModelFactory.messageToMap(m);
                mapList.add(messageMap);
            }
        }
        result.success(mapList);
    }

    private void deleteMessagesByClientMsgNoList(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
            List<Number> clientMsgNoIntList = (List<Number>) map.get("clientMsgNoList");
            List<Long> clientMsgNoList = new ArrayList<>();
            if (clientMsgNoIntList != null) {
                for (Number i : clientMsgNoIntList) {
                    clientMsgNoList.add(i.longValue());
                }
            }
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
                     resultList.add(messageMap);
                 }
             }
             result.success(resultList);
         }
    }

     private void getMessagesByClientMsgNoList(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             List<Number> clientMsgNoList = (List<Number>) map.get("clientMsgNoList");
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
             JIM.getInstance().getMessageManager().getGroupMessageReadInfoDetail(conversation, messageId, new JIMConst.IResultCallback<GroupMessageReadInfoDetail>() {
                 @Override
                 public void onSuccess(GroupMessageReadInfoDetail groupMessageReadInfoDetail) {
                     Map<String, Object> resultMap = new HashMap<>();
                     List<Map<String, Object>> readMemberMapList = new ArrayList<>();
                     List<Map<String, Object>> unreadMemberMapList = new ArrayList<>();
                     for (GroupMessageMemberReadDetail detail : groupMessageReadInfoDetail.getReadMembers()) {
                         Map<String, Object> readMemberMap = ModelFactory.groupMessageMemberReadDetailToMap(detail);
                         readMemberMapList.add(readMemberMap);
                     }
                     for (GroupMessageMemberReadDetail detail : groupMessageReadInfoDetail.getUnreadMembers()) {
                         Map<String, Object> unreadMemberMap = ModelFactory.groupMessageMemberReadDetailToMap(detail);
                         unreadMemberMapList.add(unreadMemberMap);
                     }
                     resultMap.put("readCount", groupMessageReadInfoDetail.getReadCount());
                     resultMap.put("memberCount", groupMessageReadInfoDetail.getMemberCount());
                     resultMap.put("readMembers", readMemberMapList);
                     resultMap.put("unreadMembers", unreadMemberMapList);
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
             Number timestampNumber = (Number) map.get("timestamp");
             if (timestampNumber != null) {
                 timestamp = timestampNumber.longValue();
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

     private void getCachedMessagesReaction(Object arg, MethodChannel.Result result) {
         if (arg instanceof Map<?, ?>) {
             Map<?, ?> map = (Map<?, ?>) arg;
             List<String> messageIdList = (List<String>) map.get("messageIdList");
             List<MessageReaction> reactionList = JIM.getInstance().getMessageManager().getCachedMessagesReaction(messageIdList);
             Map<String, Object> resultMap = new HashMap<>();
             List<Map<String, Object>> reactionMapList = new ArrayList<>();
             for (MessageReaction reaction : reactionList) {
                 Map<String, Object> reactionMap = ModelFactory.messageReactionToMap(reaction);
                 reactionMapList.add(reactionMap);
             }
             resultMap.put("reactionList", reactionMapList);
             result.success(resultMap);
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

    private void downloadMediaMessage(Object arg, MethodChannel.Result result) {
        String messageId = (String) arg;
        JIM.getInstance().getMessageManager().downloadMediaMessage(messageId, new IMessageManager.IDownloadMediaMessageCallback() {
            @Override
            public void onProgress(int i, Message message) {

            }

            @Override
            public void onSuccess(Message message) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                resultMap.put("message", ModelFactory.messageToMap(message));
                result.success(resultMap);
            }

            @Override
            public void onError(int i) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", i);
                result.success(resultMap);
            }

            @Override
            public void onCancel(Message message) {

            }
        });
    }

    private void setMessageLocalAttribute(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Number clientMsgNo = (Number) map.get("clientMsgNo");
            String attribute = (String) map.get("attribute");
            assert clientMsgNo != null;
            JIM.getInstance().getMessageManager().setLocalAttribute(clientMsgNo.longValue(), attribute);
            result.success(null);
        }
    }

    private void setMessageTop(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String messageId = (String) map.get("messageId");
        Conversation conversation = ModelFactory.conversationFromMap((Map<?, ?>) Objects.requireNonNull(map.get("conversation")));
        boolean isTop = (boolean) map.get("isTop");
        JIM.getInstance().getMessageManager().setTop(messageId, conversation, isTop, new IMessageManager.ISimpleCallback() {
            @Override
            public void onSuccess() {
                result.success(0);
            }

            @Override
            public void onError(int i) {
                result.success(i);
            }
        });
    }

    private void getTopMessage(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        Conversation conversation = ModelFactory.conversationFromMap(map);
        JIM.getInstance().getMessageManager().getTopMessage(conversation, new IMessageManager.IGetTopMessageCallback() {
            @Override
            public void onSuccess(Message message, UserInfo userInfo, long l) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("message", ModelFactory.messageToMap(message));
                resultMap.put("userInfo", ModelFactory.userInfoToMap(userInfo));
                resultMap.put("timestamp", l);
                resultMap.put("errorCode", 0);
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

    private void addFavoriteMessages(Object arg, MethodChannel.Result result) {
        List<String> messageIdList = (List<String>) arg;
        JIM.getInstance().getMessageManager().addFavorite(messageIdList, new IMessageManager.ISimpleCallback() {
            @Override
            public void onSuccess() {
                result.success(0);
            }

            @Override
            public void onError(int i) {
                result.success(i);
            }
        });
    }

    private void removeFavoriteMessages(Object arg, MethodChannel.Result result) {
        List<String> messageIdList = (List<String>) arg;
        JIM.getInstance().getMessageManager().removeFavorite(messageIdList, new IMessageManager.ISimpleCallback() {
            @Override
            public void onSuccess() {
                result.success(0);
            }

            @Override
            public void onError(int i) {
                result.success(i);
            }
        });
    }

    private void getFavoriteMessages(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String offset = (String) map.get("offset");
        int count = (int) map.get("count");
        GetFavoriteMessageOption option = new GetFavoriteMessageOption();
        option.setOffset(offset);
        option.setCount(count);
        JIM.getInstance().getMessageManager().getFavorite(option, new IMessageManager.IGetFavoriteMessageCallback() {
            @Override
            public void onSuccess(List<FavoriteMessage> list, String offset) {
                List<Map<String, Object>> messageMapList = new ArrayList<>();
                for (FavoriteMessage favoriteMessage : list) {
                    Map<String, Object> messageMap = ModelFactory.favoriteMessageToMap(favoriteMessage);
                    messageMapList.add(messageMap);
                }
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("messageList", messageMapList);
                resultMap.put("offset", offset);
                resultMap.put("errorCode", 0);
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

    private void searchConversationsWithMessageContent(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        MessageQueryOptions.Builder builder = new MessageQueryOptions.Builder();
        String searchContent = (String) map.get("searchContent");
        if (!TextUtils.isEmpty(searchContent)) {
            builder.setSearchContent(searchContent);
        }
        List<String> senderUserIds = (List<String>) map.get("senderUserIds");
        if (senderUserIds != null) {
            builder.setSenderUserIds(senderUserIds);
        }
        List<String> contentTypes = (List<String>) map.get("contentTypes");
        if (contentTypes != null) {
            builder.setContentTypes(contentTypes);
        }
        List<Map<?,?>> conversationMapList = (List<Map<?,?>>) map.get("conversations");
        if (conversationMapList != null) {
            List<Conversation> conversationList = new ArrayList<>();
            for (Map<?,?> conversationMap : conversationMapList) {
                Conversation conversation = ModelFactory.conversationFromMap(conversationMap);
                conversationList.add(conversation);
            }
            builder.setConversations(conversationList);
        }
        List<Number> stateNumberList = (List<Number>) map.get("messageStates");
        if (stateNumberList != null) {
            List<Message.MessageState> states = new ArrayList<>();
            for (Number stateNumber : stateNumberList) {
                Message.MessageState state = Message.MessageState.setValue(stateNumber.intValue());
                states.add(state);
            }
            builder.setStates(states);
        }
        List<Number> conversationTypeNumberList = (List<Number>) map.get("conversationTypes");
        if (conversationTypeNumberList != null) {
            List<Conversation.ConversationType> conversationTypeList = new ArrayList<>();
            for (Number conversationTypeNumber : conversationTypeNumberList) {
                Conversation.ConversationType conversationType = Conversation.ConversationType.setValue(conversationTypeNumber.intValue());
                conversationTypeList.add(conversationType);
            }
            builder.setConversationTypes(conversationTypeList);
        }
        MessageQueryOptions o = builder.build();
        JIM.getInstance().getMessageManager().searchConversationsWithMessageContent(o, new IMessageManager.ISearchConversationWithMessageContentCallback() {
            @Override
            public void onComplete(List<SearchConversationsResult> searchConversationsResults) {
                List<Map<String, Object>> resultList = new ArrayList<>();
                if (searchConversationsResults != null) {
                    for (SearchConversationsResult searchConversationsResult : searchConversationsResults) {
                        Map<String, Object> resultMap = ModelFactory.searchConversationResultToMap(searchConversationsResult);
                        resultList.add(resultMap);
                    }
                }
                result.success(resultList);
            }
        });
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

     private void getFriendInfo(Object arg, MethodChannel.Result result) {
        String userId = (String) arg;
         FriendInfo friendInfo = JIM.getInstance().getUserInfoManager().getFriendInfo(userId);
         Map<String, Object> map = ModelFactory.friendInfoToMap(friendInfo);
         result.success(map);
     }

    private void fetchUserInfo(Object arg, MethodChannel.Result result) {
        String userId = (String)arg;
        JIM.getInstance().getUserInfoManager().fetchUserInfo(userId, new JIMConst.IResultCallback<UserInfo>() {
            @Override
            public void onSuccess(UserInfo userInfo) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", 0);
                resultMap.put("userInfo", ModelFactory.userInfoToMap(userInfo));
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

    private void fetchGroupInfo(Object arg, MethodChannel.Result result) {
        String groupId = (String) arg;
        JIM.getInstance().getUserInfoManager().fetchGroupInfo(groupId, new JIMConst.IResultCallback<GroupInfo>() {
            @Override
            public void onSuccess(GroupInfo groupInfo) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", 0);
                resultMap.put("groupInfo", ModelFactory.groupInfoToMap(groupInfo));
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

    private void fetchFriendInfo(Object arg, MethodChannel.Result result) {
        String userId = (String) arg;
        JIM.getInstance().getUserInfoManager().fetchFriendInfo(userId, new JIMConst.IResultCallback<FriendInfo>() {
            @Override
            public void onSuccess(FriendInfo friendInfo) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", 0);
                resultMap.put("friendInfo", ModelFactory.friendInfoToMap(friendInfo));
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

    private void initZegoEngine(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Number appId = (Number) map.get("appId");
//            String appSign = (String) map.get("appSign");
            if (appId != null) {
                JIM.getInstance().getCallManager().initZegoEngine(appId.intValue(), mContext);
            }
            result.success(null);
        }
    }

    private void initAgoraEngine(Object arg, MethodChannel.Result result) {
        String appId = (String) arg;
        JIM.getInstance().getCallManager().initAgoraEngine(appId, mContext);
        result.success(null);
    }

    private void startSingleCall(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String userId = (String) map.get("userId");
            CallConst.CallMediaType mediaType = CallConst.CallMediaType.VOICE;
            Number mediaTypeValue = (Number) map.get("mediaType");
            if (mediaTypeValue != null) {
                mediaType = CallConst.CallMediaType.setValue(mediaTypeValue.intValue());
            }
            String extra = (String) map.get("extra");
            if (extra == null) {
                extra = "";
            }
            ICallSession callSession = JIM.getInstance().getCallManager().startSingleCall(userId, mediaType, extra, null);
            if (callSession != null) {
                Map<String, Object> resultMap = ModelFactory.callSessionToMap(callSession);
                addCallSessionListener(callSession);
                result.success(resultMap);
            } else {
                result.success(new HashMap<>());
            }
        }
    }

    private void startMultiCall(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            List<String> userIdList = (List<String>) map.get("userIdList");
            CallConst.CallMediaType mediaType = CallConst.CallMediaType.VOICE;
            Number mediaTypeValue = (Number) map.get("mediaType");
            if (mediaTypeValue != null) {
                mediaType = CallConst.CallMediaType.setValue(mediaTypeValue.intValue());
            }
            String extra = (String) map.get("extra");
            if (extra == null) {
                extra = "";
            }
            Map<?, ?> conversationMap = (Map<?, ?>) map.get("conversation");
            Conversation conversation = null;
            if (conversationMap != null) {
                conversation = ModelFactory.conversationFromMap(conversationMap);
            }
            ICallSession callSession = JIM.getInstance().getCallManager().startMultiCall(userIdList, mediaType, conversation, extra, null);
            if (callSession != null) {
                Map<String, Object> resultMap = ModelFactory.callSessionToMap(callSession);
                addCallSessionListener(callSession);
                result.success(resultMap);
            } else {
                result.success(new HashMap<>());
            }
        }
    }

    private void joinCall(Object arg, MethodChannel.Result result) {
        String callId = (String) arg;
        ICallSession callSession = JIM.getInstance().getCallManager().joinCall(callId, null);
        if (callSession != null) {
            Map<String, Object> resultMap = ModelFactory.callSessionToMap(callSession);
            addCallSessionListener(callSession);
            result.success(resultMap);
        } else {
            result.success(new HashMap<>());
        }
    }

    private void getConversationCallInfo(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            Conversation conversation = ModelFactory.conversationFromMap(map);
            JIM.getInstance().getCallManager().getConversationCallInfo(conversation, new JIMConst.IResultCallback<CallInfo>() {
                @Override
                public void onSuccess(CallInfo callInfo) {
                    if (callInfo == null) {
                        result.success(new HashMap<>());
                        return;
                    }
                    Map<String ,Object> resultMap = ModelFactory.callInfoToMap(callInfo);
                    result.success(resultMap);
                }

                @Override
                public void onError(int i) {
                    result.success(new HashMap<>());
                }
            });
        }
    }

    private void getCallSession(Object arg, MethodChannel.Result result) {
        String callId = (String) arg;
        ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
        if (callSession != null) {
            Map<String, Object> resultMap = ModelFactory.callSessionToMap(callSession);
            result.success(resultMap);
        } else {
            result.success(new HashMap<>());
        }
    }

    private void callAccept(Object arg, MethodChannel.Result result) {
        String callId = (String) arg;
        ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
        if (callSession != null) {
            callSession.accept();
        }
        result.success(null);
    }

    private void callHangup(Object arg, MethodChannel.Result result) {
        String callId = (String) arg;
        ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
        if (callSession != null) {
            callSession.hangup();
        }
        result.success(null);
    }

    private void callEnableCamera(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            boolean isEnable = (boolean) map.get("isEnable");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.enableCamera(isEnable);
            }
            result.success(null);
        }
    }

    private void callMuteMicrophone(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            boolean isMute = (boolean) map.get("isMute");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.muteMicrophone(isMute);
            }
            result.success(null);
        }
    }

    private void callMuteSpeaker(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            boolean isMute = (boolean) map.get("isMute");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.muteSpeaker(isMute);
            }
            result.success(null);
        }
    }

    private void callSetSpeakerEnable(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            boolean isEnable = (boolean) map.get("isEnable");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.setSpeakerEnable(isEnable);
            }
            result.success(null);
        }
    }

    private void callUseFrontCamera(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            boolean isEnable = (boolean) map.get("isEnable");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.useFrontCamera(isEnable);
            }
            result.success(null);
        }
    }

    private void callInviteUsers(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            List<String> userIdList = (List<String>) map.get("userIdList");
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.inviteUsers(userIdList);
            }
            result.success(null);
        }
    }

    private void callSetVideoView(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            String userId = (String) map.get("userId");
            String viewId = (String) map.get("viewId");
            VideoPlatformView view = mFactory.getView(viewId);
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null && view != null) {
                callSession.setVideoView(userId, view.getView());
            }
        }
        result.success(null);
    }

    private void callStartPreview(Object arg, MethodChannel.Result result) {
        if (arg instanceof Map<?, ?>) {
            Map<?, ?> map = (Map<?, ?>) arg;
            String callId = (String) map.get("callId");
            String viewId = (String) map.get("viewId");
            VideoPlatformView view = mFactory.getView(viewId);
            ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
            if (callSession != null) {
                callSession.startPreview(view.getView());
            }
        }
        result.success(null);
    }

    private void addMoment(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String content = (String) map.get("content");
        List<Map<String, Object>> mediaMapList = (List<Map<String, Object>>) map.get("mediaList");
        List<MomentMedia> mediaList = new ArrayList<>();
        if (mediaMapList != null) {
            for (Map<String, Object> mediaMap : mediaMapList) {
                MomentMedia media = ModelFactory.momentMediaFromMap(mediaMap);
                if (media != null) {
                    mediaList.add(media);
                }
            }
        }
        JIM.getInstance().getMomentManager().addMoment(content, mediaList, new JIMConst.IResultCallback<Moment>() {
            @Override
            public void onSuccess(Moment moment) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", 0);
                if (moment != null) {
                    Map<String, Object> momentMap = ModelFactory.momentToMap(moment);
                    resultMap.put("moment", momentMap);
                }
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

    private void removeMoment(Object arg, MethodChannel.Result result) {
        String momentId = (String) arg;
        JIM.getInstance().getMomentManager().removeMoment(momentId, new IMessageManager.ISimpleCallback() {
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

    private void getCachedMomentList(Object arg, MethodChannel.Result result) {
        Map<String, Object> map = (Map<String, Object>) arg;
        GetMomentOption o = ModelFactory.getMomentOptionFromMap(map);
        List<Moment> momentList = JIM.getInstance().getMomentManager().getCachedMomentList(o);
        List<Map<String, Object>> mapList = new ArrayList<>();
        if (momentList != null && !momentList.isEmpty()) {
            for (Moment moment : momentList) {
                Map<String, Object> momentMap = ModelFactory.momentToMap(moment);
                mapList.add(momentMap);
            }
        }
        result.success(mapList);
    }

    private void getMomentList(Object arg, MethodChannel.Result result) {
        Map<String, Object> map = (Map<String, Object>) arg;
        GetMomentOption o = ModelFactory.getMomentOptionFromMap(map);
        JIM.getInstance().getMomentManager().getMomentList(o, new JIMConst.IResultListCallback<Moment>() {
            @Override
            public void onSuccess(List<Moment> list, boolean isFinish) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                List<Map<String, Object>> momentMapList = new ArrayList<>();
                for (Moment moment : list) {
                    Map<String, Object> momentMap = ModelFactory.momentToMap(moment);
                    momentMapList.add(momentMap);
                }
                resultMap.put("momentList", momentMapList);
                resultMap.put("isFinish", isFinish);
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

    private void getMoment(Object arg, MethodChannel.Result result) {
        String momentId = (String) arg;
        JIM.getInstance().getMomentManager().getMoment(momentId, new JIMConst.IResultCallback<Moment>() {
            @Override
            public void onSuccess(Moment moment) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                Map<String, Object> momentMap = ModelFactory.momentToMap(moment);
                resultMap.put("moment", momentMap);
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

    private void addComment(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String momentId = (String) map.get("momentId");
        String content = (String) map.get("content");
        String parentCommentId = (String) map.get("parentCommentId");
        JIM.getInstance().getMomentManager().addComment(momentId, parentCommentId, content, new JIMConst.IResultCallback<MomentComment>() {
            @Override
            public void onSuccess(MomentComment momentComment) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                Map<String, Object> commentMap = ModelFactory.momentCommentToMap(momentComment);
                resultMap.put("comment", commentMap);
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

    private void removeComment(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String momentId = (String) map.get("momentId");
        String commentId = (String) map.get("commentId");
        JIM.getInstance().getMomentManager().removeComment(momentId, commentId, new IMessageManager.ISimpleCallback() {
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

    private void getCommentList(Object arg, MethodChannel.Result result) {
        Map<String, Object> map = (Map<String, Object>) arg;
        GetMomentCommentOption o = ModelFactory.getMomentCommentOptionFromMap(map);
        JIM.getInstance().getMomentManager().getCommentList(o, new JIMConst.IResultListCallback<MomentComment>() {
            @Override
            public void onSuccess(List<MomentComment> list, boolean isFinish) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                List<Map<String, Object>> commentMapList = new ArrayList<>();
                for (MomentComment comment : list) {
                    Map<String, Object> commentMap = ModelFactory.momentCommentToMap(comment);
                    commentMapList.add(commentMap);
                }
                resultMap.put("commentList", commentMapList);
                resultMap.put("isFinish", isFinish);
                result.success(resultMap);
            }

            @Override
            public void onError(int i) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", i);
                resultMap.put("isFinish", false);
                result.success(resultMap);
            }
        });
    }

    private void addMomentReaction(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String momentId = (String) map.get("momentId");
        String key = (String) map.get("key");
        JIM.getInstance().getMomentManager().addReaction(momentId, key, new IMessageManager.ISimpleCallback() {
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

    private void removeMomentReaction(Object arg, MethodChannel.Result result) {
        Map<?, ?> map = (Map<?, ?>) arg;
        String momentId = (String) map.get("momentId");
        String key = (String) map.get("key");
        JIM.getInstance().getMomentManager().removeReaction(momentId, key, new IMessageManager.ISimpleCallback() {
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

    private void getReactionList(Object arg, MethodChannel.Result result) {
        String momentId = (String) arg;
        JIM.getInstance().getMomentManager().getReactionList(momentId, new JIMConst.IResultListCallback<MomentReaction>() {
            @Override
            public void onSuccess(List<MomentReaction> list, boolean isFinish) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("errorCode", JErrorCode.NONE);
                List<Map<String, Object>> reactionMapList = new ArrayList<>();
                for (MomentReaction reaction: list) {
                    Map<String, Object> reactionMap = ModelFactory.momentReactionToMap(reaction);
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
        mChannel.invokeMethod("onMessageReceive", messageMap);
    }

    @Override
    public void onMessageRecall(Message message) {
        Map<String, Object> messageMap = ModelFactory.messageToMap(message);
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
    public void onMessageSetTop(Message message, UserInfo userInfo, boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("message", ModelFactory.messageToMap(message));
        map.put("userInfo", ModelFactory.userInfoToMap(userInfo));
        map.put("isTop", b);
        mChannel.invokeMethod("onMessageSetTop", map);
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

     @Override
     public void onCallReceive(ICallSession callSession) {
        Map<String, Object> map = ModelFactory.callSessionToMap(callSession);
        addCallSessionListener(callSession);
        mChannel.invokeMethod("onCallReceive", map);
     }

     @Override
     public void destructCallSessionListener(String callId) {
        mCallSessionListenerMap.remove(callId);
        ICallSession callSession = JIM.getInstance().getCallManager().getCallSession(callId);
        if (callSession != null) {
            callSession.removeListener("Flutter");
        }
     }

     private void addCallSessionListener(ICallSession callSession) {
         CallSessionListenerImpl impl = new CallSessionListenerImpl(mChannel, callSession.getCallId());
         callSession.addListener("Flutter", impl);
         impl.setDestruct(this);
         mCallSessionListenerMap.put(callSession.getCallId(), impl);
     }

     @Override
     public void onMessageDestroyTimeUpdate(String messageId, Conversation conversation, long destroyTime) {
         Map<String, Object> map = new HashMap<>();
         map.put("messageId", messageId);
         map.put("conversation", ModelFactory.conversationToMap(conversation));
         map.put("destroyTime", destroyTime);
         mChannel.invokeMethod("onMessageDestroyTimeUpdate", map);
     }

     @Override
     public void onCallInfoUpdate(CallInfo callInfo, Conversation conversation, boolean isFinished) {
        Map<String, Object> map = new HashMap<>();
        map.put("callInfo", ModelFactory.callInfoToMap(callInfo));
        map.put("conversation", ModelFactory.conversationToMap(conversation));
        map.put("isFinished", isFinished);
        mChannel.invokeMethod("onCallInfoUpdate", map);
     }

     private static class SingletonHolder {
        static final JuggleIMFlutterWrapper sInstance = new JuggleIMFlutterWrapper();
    }
}
