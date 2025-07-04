package com.juggle.im.juggle_im;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class VideoPlatformViewFactory extends PlatformViewFactory {
    private final BinaryMessenger mMessenger;
    private final Map<String, WeakReference<VideoPlatformView>> mViewMap = new HashMap<>();

    public VideoPlatformViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        mMessenger = messenger;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        VideoPlatformView view = new VideoPlatformView(context, mMessenger, viewId);
        String viewIdString = (String) args;
        mViewMap.put(viewIdString, new WeakReference<>(view));
        return view;
    }

    public VideoPlatformView getView(String viewId) {
        WeakReference<VideoPlatformView> weakView = mViewMap.get(viewId);
        return weakView != null ? weakView.get() : null;
    }
}
