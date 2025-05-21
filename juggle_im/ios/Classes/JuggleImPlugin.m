#import "JuggleImPlugin.h"
#import "JuggleIMFlutterWrapper.h"

@interface JuggleImPlugin ()

@end

@implementation JuggleImPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"juggle_im"
                                     binaryMessenger:[registrar messenger]];
    JuggleImPlugin* instance = [[JuggleImPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [[JuggleIMFlutterWrapper shared] setFlutterChannel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  [[JuggleIMFlutterWrapper shared] handleMethodCall:call result:result];
}

@end
