//
//  JVideoPlatformView.h
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JVideoPlatformView : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@property(nonatomic, strong) UIView* view;
@end

NS_ASSUME_NONNULL_END
