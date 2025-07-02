//
//  JVideoPlatformViewFactory.m
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import "JVideoPlatformViewFactory.h"
#import "JVideoPlatformView.h"

@interface JVideoPlatformViewFactory ()
@property (nonatomic, copy) NSMutableDictionary *viewDic;
@end

@implementation JVideoPlatformViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    NSObject<FlutterPlatformView> *view = [[JVideoPlatformView alloc] initWithFrame:frame
                                                                     viewIdentifier:viewId
                                                                          arguments:args
                                                                    binaryMessenger:_messenger];
    NSString *viewIdString = args;
    [self.viewDic setObject:view forKey:viewIdString];
    return view;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)getViewById:(NSString *)viewId {
    return [self.viewDic objectForKey:viewId];
}

- (NSMutableDictionary *)viewDic {
    if (!_viewDic) {
        _viewDic = [NSMutableDictionary dictionary];
    }
    return _viewDic;
}

@end
