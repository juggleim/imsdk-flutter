package com.juggle.im.juggle_im;

import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class VideoPlatformView implements PlatformView {
    private final FrameLayout mView;

    VideoPlatformView(Context context, BinaryMessenger messenger, int viewId) {
        // 创建容器视图
        mView = new FrameLayout(context);
        mView.setBackgroundColor(0xFF000000); // 黑色背景

        // 创建音视频视图 (替换为你的SDK实际代码)
        // videoView = new VideoView(context);
        // view.addView(videoView);

        // 调试用 - 红色视图
        View redView = new View(context);
        redView.setBackgroundColor(0xFFFF0000); // 红色
        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(100, 100);
        layoutParams.setMargins(20, 20, 0, 0);
        mView.addView(redView, layoutParams);
    }

    @Nullable
    @Override
    public FrameLayout getView() {
        return mView;
    }

    @Override
    public void dispose() {

    }
}
