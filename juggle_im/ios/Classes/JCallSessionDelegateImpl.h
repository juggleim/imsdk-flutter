//
//  JCallSessionDelegateImpl.h
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <JuggleIM/JuggleIM.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JCallSessionDelegateDestruct <NSObject>
- (void)destructCallSessionDelegate:(NSString *)callId;
@end

@interface JCallSessionDelegateImpl : NSObject <JCallSessionDelegate>
@property (nonatomic, weak) id<JCallSessionDelegateDestruct> destruct;
+ (instancetype)delegateWithChannel:(FlutterMethodChannel *)channel
                             callId:(NSString *)callId;
@end

NS_ASSUME_NONNULL_END
