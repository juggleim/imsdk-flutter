import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VideoView extends StatefulWidget {
  final double? width;
  final double? height;
  final String? viewId;
  final void Function()? onViewCreated;

  const VideoView({
    super.key,
    this.width,
    this.height,
    this.viewId,
    this.onViewCreated,
  });

  @override
  State<StatefulWidget> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildPlatformView(widget.viewId),
    );
  }

  Widget _buildPlatformView(String? viewId) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'videoview',
        creationParams: {viewId ?? ''},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'videoview',
        creationParams: {viewId ?? ''},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return Center(
        child: Text('Unsupported platform: $defaultTargetPlatform'),
      );
    }
  }

  void _onPlatformViewCreated(int id) {    
    // 回调给外部
    if (widget.onViewCreated != null) {
      widget.onViewCreated!();
    }
  }
}