package com.juggle.im.juggle_im;

import android.content.Context;

import androidx.annotation.NonNull;

import com.juggle.im.JIM;
import com.juggle.im.JIMConst;
import com.juggle.im.interfaces.IConnectionManager;
import com.juggle.im.interfaces.IConversationManager;
import com.juggle.im.interfaces.IMessageManager;
import com.juggle.im.internal.logger.JLogConfig;
import com.juggle.im.internal.logger.JLogLevel;
import com.juggle.im.model.Conversation;
import com.juggle.im.model.ConversationInfo;
import com.juggle.im.model.GroupMessageReadInfo;
import com.juggle.im.model.Message;
import com.juggle.im.model.MessageReaction;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
                getConnectionStatus(call.arguments, result);
                break;
            case "getConversationInfoList":
                getConversationInfoList(call.arguments, result);
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

    private void getConnectionStatus(Object arg, MethodChannel.Result result) {
        int status = JIM.getInstance().getConnectionManager().getConnectionStatus().getStatus();
        result.success(status);
    }

    private void getConversationInfoList(Object arg, MethodChannel.Result result) {
        List<ConversationInfo> list = JIM.getInstance().getConversationManager().getConversationInfoList();
        List<Map<String, Object>> resultList = new ArrayList<>();
        for (ConversationInfo info : list) {
            Map<String, Object> m = ModelFactory.conversationInfoToMap(info);
            resultList.add(m);
        }
        result.success(resultList);
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
