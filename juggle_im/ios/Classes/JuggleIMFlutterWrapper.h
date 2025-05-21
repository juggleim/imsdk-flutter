//
//  JuggleIMFlutterWrapper.h
//  juggle_im
//
//  Created by Fei Li on 2025/5/20.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuggleIMFlutterWrapper : NSObject

+ (instancetype)shared;

- (void)setFlutterChannel:(FlutterMethodChannel *_Nullable)channel;
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
