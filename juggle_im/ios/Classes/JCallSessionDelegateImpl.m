//
//  JCallSessionDelegateImpl.m
//  juggle_im
//
//  Created by Fei Li on 2025/7/1.
//

#import "JCallSessionDelegateImpl.h"

@interface JCallSessionDelegateImpl ()
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSString *callId;
@end

@implementation JCallSessionDelegateImpl

+ (instancetype)delegateWithChannel:(FlutterMethodChannel *)channel callId:(NSString *)callId {
    JCallSessionDelegateImpl *impl = [JCallSessionDelegateImpl new];
    impl.channel = channel;
    impl.callId = callId;
    return impl;
}

- (void)callDidConnect {
    [self.channel invokeMethod:@"onCallConnect" arguments:self.callId];
}

- (void)callDidFinish:(JCallFinishReason)finishReason {
    NSDictionary *dic = @{@"callId": self.callId, @"finishReason": @(finishReason)};
    [self.channel invokeMethod:@"onCallFinish" arguments:dic];
    [self.destruct destructCallSessionDelegate:self.callId];
}

- (void)usersDidInvite:(NSArray<NSString *> *)userIdList
             inviterId:(NSString *)inviterId {
    NSDictionary *dic = @{@"callId": self.callId, @"userIdList": userIdList, @"inviterId": inviterId};
    [self.channel invokeMethod:@"onUsersInvite" arguments:dic];
}

- (void)usersDidConnect:(NSArray<NSString *> *)userIdList {
    NSDictionary *dic = @{@"callId": self.callId, @"userIdList": userIdList};
    [self.channel invokeMethod:@"onUsersConnect" arguments:dic];
}

- (void)usersDidLeave:(NSArray<NSString *> *)userIdList {
    NSDictionary *dic = @{@"callId": self.callId, @"userIdList": userIdList};
    [self.channel invokeMethod:@"onUsersLeave" arguments:dic];
}

- (void)userCamaraDidChange:(BOOL)enable userId:(NSString *)userId {
    NSDictionary *dic = @{@"callId": self.callId, @"userId": userId, @"enable": @(enable)};
    [self.channel invokeMethod:@"onUserCameraChange" arguments:dic];
}

- (void)userMicrophoneDidChange:(BOOL)enable userId:(NSString *)userId {
    NSDictionary *dic = @{@"callId": self.callId, @"userId": userId, @"enable": @(enable)};
    [self.channel invokeMethod:@"onUserMicrophoneChange" arguments:dic];
}

- (void)soundLevelDidUpdate:(NSDictionary<NSString *,NSNumber *> *)soundLevels {
    [self.channel invokeMethod:@"onSoundLevelUpdate" arguments:soundLevels];
}

- (void)errorDidOccur:(JCallErrorCode)errorCode {
    NSDictionary *dic = @{@"callId": self.callId, @"errorCode": @(errorCode)};
    [self.channel invokeMethod:@"onErrorOccur" arguments:dic];
}

- (void)dealloc {
    NSLog(@"Nathan, JCallSessionDelegateImpl dealloc");
}

@end
