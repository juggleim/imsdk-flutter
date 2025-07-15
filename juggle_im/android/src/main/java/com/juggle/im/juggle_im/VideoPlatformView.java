package com.juggle.im.juggle_im;

import android.content.Context;
import android.view.SurfaceView;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class VideoPlatformView implements PlatformView {
    private final SurfaceView mView;

    VideoPlatformView(Context context, BinaryMessenger messenger, int viewId) {
        // 创建容器视图
        mView = new SurfaceView(context);
    }

    @Nullable
    @Override
    public SurfaceView getView() {
        return mView;
    }

    @Override
    public void dispose() {

    }
}
