package com.juggle.im.juggle_im;

import android.content.Context;

import androidx.annotation.NonNull;

import com.juggle.im.JErrorCode;
import com.juggle.im.JIM;
import com.juggle.im.JIMConst;
import com.juggle.im.interfaces.IConnectionManager;
import com.juggle.im.interfaces.IConversationManager;
import com.juggle.im.interfaces.IMessageManager;
import com.juggle.im.internal.ConstInternal;
import com.juggle.im.internal.logger.JLogConfig;
import com.juggle.im.internal.logger.JLogLevel;
import com.juggle.im.model.Conversation;
import com.juggle.im.model.ConversationInfo;
import com.juggle.im.model.GetConversationOptions;
import com.juggle.im.model.GetMessageOptions;
import com.juggle.im.model.GroupMessageReadInfo;
import com.juggle.im.model.Message;
import com.juggle.im.model.MessageReaction;

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






    @Override
    public void onStatusChange(JIMConst.ConnectionStatus connectionStatus, int code, String extra) {
        Map<String, Object> map = new HashMap<>();
        map.put("status", connectionStatus.getStatus());
        map.put("code", code);
        map.put("extra", extra);
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
            
        }

    }

    @Override
    public void onConversationInfoUpdate(List<ConversationInfo> list) {

    }

    @Override
    public void onConversationInfoDelete(List<ConversationInfo> list) {

    }

    @Override
    public void onTotalUnreadMessageCountUpdate(int i) {

    }

    @Override
    public void onMessageReceive(Message message) {

    }

    @Override
    public void onMessageRecall(Message message) {

    }

    @Override
    public void onMessageDelete(Conversation conversation, List<Long> list) {

    }

    @Override
    public void onMessageClear(Conversation conversation, long l, String s) {

    }

    @Override
    public void onMessageUpdate(Message message) {

    }

    @Override
    public void onMessageReactionAdd(Conversation conversation, MessageReaction messageReaction) {

    }

    @Override
    public void onMessageReactionRemove(Conversation conversation, MessageReaction messageReaction) {

    }

    @Override
    public void onMessagesRead(Conversation conversation, List<String> list) {

    }

    @Override
    public void onGroupMessagesRead(Conversation conversation, Map<String, GroupMessageReadInfo> map) {

    }

    private static class SingletonHolder {
        static final JuggleIMFlutterWrapper sInstance = new JuggleIMFlutterWrapper();
    }
}
