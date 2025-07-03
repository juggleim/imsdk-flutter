package com.juggle.im.juggle_im;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** JuggleImPlugin */
public class JuggleImPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "juggle_im");
    channel.setMethodCallHandler(this);
    JuggleIMFlutterWrapper.getInstance().setChannel(channel);
    JuggleIMFlutterWrapper.getInstance().setContext(flutterPluginBinding.getApplicationContext());
    VideoPlatformViewFactory factory = new VideoPlatformViewFactory(flutterPluginBinding.getBinaryMessenger());
    JuggleIMFlutterWrapper.getInstance().setVideoPlatformViewFactory(factory);
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("videoview", factory);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    JuggleIMFlutterWrapper.getInstance().onMethodCall(call, result);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
