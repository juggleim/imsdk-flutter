//
//  JVideoPlatformViewFactory.h
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface JVideoPlatformViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (NSObject<FlutterPlatformView> *)getViewById:(NSString *)viewId;
@end

NS_ASSUME_NONNULL_END
