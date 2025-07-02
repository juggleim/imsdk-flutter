//
//  JVideoPlatformView.m
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import "JVideoPlatformView.h"


@implementation JVideoPlatformView

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        // 创建你的音视频视图
        _view = [[UIView alloc] initWithFrame:frame];
        
//        
//        // 处理从Flutter传递的参数
//        if ([args isKindOfClass:[NSDictionary class]]) {
//            NSDictionary* params = (NSDictionary*)args;
//            NSString* someParam = params[@"someParam"];
//            NSLog(@"Received param from Flutter: %@", someParam);
//        }
        
    }
    return self;
}


- (UIView*)view {
    return _view;
}

@end
