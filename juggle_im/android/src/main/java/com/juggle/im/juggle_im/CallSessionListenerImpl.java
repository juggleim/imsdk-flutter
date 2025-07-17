package com.juggle.im.juggle_im;

import com.juggle.im.call.CallConst;
import com.juggle.im.call.ICallSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class CallSessionListenerImpl implements ICallSession.ICallSessionListener {
    public CallSessionListenerImpl(MethodChannel channel, String callId) {
        mChannel = channel;
        mCallId = callId;
    }

    @Override
    public void onCallConnect() {
        mChannel.invokeMethod("onCallConnect", mCallId);
    }

    @Override
    public void onCallFinish(CallConst.CallFinishReason callFinishReason) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("finishReason", callFinishReason != null ? callFinishReason.getValue() : 0);
        mChannel.invokeMethod("onCallFinish", map);
        mDestruct.destructCallSessionListener(mCallId);
    }

    @Override
    public void onErrorOccur(CallConst.CallErrorCode callErrorCode) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("errorCode", callErrorCode.getValue());
        mChannel.invokeMethod("onErrorOccur", map);
    }

    @Override
    public void onUsersInvite(String s, List<String> list) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userIdList", list);
        map.put("inviterId", s);
        mChannel.invokeMethod("onUsersInvite", map);
    }

    @Override
    public void onUsersConnect(List<String> list) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userIdList", list);
        mChannel.invokeMethod("onUsersConnect", map);
    }

    @Override
    public void onUsersLeave(List<String> list) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userIdList", list);
        mChannel.invokeMethod("onUsersLeave", map);
    }

    @Override
    public void onUserCameraEnable(String s, boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userId", s);
        map.put("enable", b);
        mChannel.invokeMethod("onUserCameraChange", map);
    }

    @Override
    public void onUserMicrophoneEnable(String s, boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userId", s);
        map.put("enable", b);
        mChannel.invokeMethod("onUserMicrophoneChange", map);
    }

    @Override
    public void onSoundLevelUpdate(HashMap<String, Float> hashMap) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("soundLevels", hashMap);
        mChannel.invokeMethod("onSoundLevelUpdate", map);
    }

    @Override
    public void onVideoFirstFrameRender(String userId) {
        Map<String, Object> map = new HashMap<>();
        map.put("callId", mCallId);
        map.put("userId", userId);
        mChannel.invokeMethod("onVideoFirstFrameRender", map);
    }

    public void setDestruct(ICallSessionListenerDestruct destruct) {
        mDestruct = destruct;
    }

    public interface ICallSessionListenerDestruct {
        void destructCallSessionListener(String callId);
    }

    private ICallSessionListenerDestruct mDestruct;
    private final MethodChannel mChannel;
    private final String mCallId;
}
