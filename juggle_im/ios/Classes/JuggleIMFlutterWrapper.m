//
//  JuggleIMFlutterWrapper.m
//  juggle_im
//
//  Created by Fei Li on 2025/5/20.
//

#import "JuggleIMFlutterWrapper.h"
#import <JuggleIM/JuggleIM.h>
#import "JModelFactory.h"

@interface JuggleIMFlutterWrapper () <JConnectionDelegate, JConversationDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@end

@implementation JuggleIMFlutterWrapper

+ (instancetype)shared {
    static JuggleIMFlutterWrapper *wrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wrapper = [[self alloc] init];
    });
    return wrapper;
}

- (void)setFlutterChannel:(FlutterMethodChannel *)channel {
    self.channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"init" isEqualToString:call.method]) {
        [self initWithAppKey:call.arguments];
        result(nil);
    } else if ([@"connect" isEqualToString:call.method]) {
        [self connectWithToken:call.arguments];
        result(nil);
    } else if ([@"setServers" isEqualToString:call.method]) {
        [self setServers:call.arguments];
        result(nil);
    } else if ([@"disconnect" isEqualToString:call.method]) {
        [self disconnect:call.arguments];
    } else if ([@"getConnectionStatus" isEqualToString:call.method]) {
        result(@([self getConnectionStatus]));
    } else if ([@"getConversationInfoList" isEqualToString:call.method]) {
        result([self getConversationInfoList]);
    } else if ([@"getConversationInfoListByOption" isEqualToString:call.method]) {
        result([self getConversationInfoListByOption:call.arguments]);
    } else if ([@"getConversationInfo" isEqualToString:call.method]) {
        result([self getConversationInfo:call.arguments]);
    } else if ([@"deleteConversationInfo" isEqualToString:call.method]) {
        [self deleteConversationInfo:call.arguments result:result];
    } else if ([@"setDraft" isEqualToString:call.method]) {
        [self setDraft:call.arguments];
        result(nil);
    } else if ([@"createConversationInfo" isEqualToString:call.method]) {
        [self createConversationInfo:call.arguments result:result];
    } else if ([@"getTotalUnreadCount" isEqualToString:call.method]) {
        result(@([self getTotalUnreadCount:call.arguments]));
    } else if ([@"clearUnreadCount" isEqualToString:call.method]) {
        [self clearUnreadCount:call.arguments result:result];
    } else if ([@"setMute" isEqualToString:call.method]) {
        [self setMute:call.arguments result:result];
    } else if ([@"setTop" isEqualToString:call.method]) {
        [self setTop:call.arguments result:result];
    } else if ([@"clearTotalUnreadCount" isEqualToString:call.method]) {
        [self clearTotalUnreadCount:result];
    } else if ([@"setUnread" isEqualToString:call.method]) {
        [self setUnread:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)initWithAppKey:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *key = d[@"appKey"];
        [JIM.shared setConsoleLogLevel:JLogLevelVerbose];
        [JIM.shared initWithAppKey:key];
        
        [JIM.shared.connectionManager addDelegate:self];
        [JIM.shared.conversationManager addDelegate:self];
    }
}

- (void)connectWithToken:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *token = d[@"token"];
        [JIM.shared.connectionManager connectWithToken:token];
    }
}

- (void)setServers:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray *list = d[@"list"];
        [JIM.shared setServerUrls:list];
    }
}

- (void)disconnect:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        BOOL receivePush = d[@"receivePush"];
        [JIM.shared.connectionManager disconnect:receivePush];
    }
}

- (int)getConnectionStatus {
    return (int)[JIM.shared.connectionManager getConnectionStatus];
}

- (NSArray *)getConversationInfoList {
    NSArray<JConversationInfo *> *list = [JIM.shared.conversationManager getConversationInfoList];
    NSMutableArray *result = [NSMutableArray array];
    for (JConversationInfo *info in list) {
        NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
        [result addObject:infoDic];
    }
    return [result copy];
}

- (NSArray *)getConversationInfoListByOption:(id)arg {
    NSMutableArray *result = [NSMutableArray array];
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JGetConversationOptions *option = [[JGetConversationOptions alloc] init];

        option.conversationTypes = d[@"conversationTypes"];
        option.count = [d[@"count"] intValue];
        option.timestamp = [d[@"timestamp"] longLongValue];
        int direction = [d[@"direction"] intValue];
        if (direction == 0) {
            option.direction = JPullDirectionNewer;
        } else if (direction == 1) {
            option.direction = JPullDirectionOlder;
        }
        option.tagId = d[@"tagId"];
        NSArray<JConversationInfo *> *list = [JIM.shared.conversationManager getConversationInfoListWith:option];
        for (JConversationInfo *info in list) {
            NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
            [result addObject:infoDic];
        }
    }
    return [result copy];
}

- (NSDictionary *)getConversationInfo:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d];
        JConversationInfo *info = [JIM.shared.conversationManager getConversationInfo:conversation];
        NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
        return infoDic;
    }
    return [NSDictionary dictionary];
}

- (void)deleteConversationInfo:(id)arg
                       result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d];
        [JIM.shared.conversationManager deleteConversationInfoBy:conversation
                                                         success:^{
            result(@(0));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    } else {
        result(@(JErrorCodeInvalidParam));
    }
}

- (void)setDraft:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSString *draft = d[@"draft"] ?: @"";
        [JIM.shared.conversationManager setDraft:draft inConversation:conversation];
    }
}

- (void)createConversationInfo:(id)arg
                        result:(FlutterResult)result {
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d];
        [JIM.shared.conversationManager createConversationInfo:conversation
                                                       success:^(JConversationInfo *info) {
            NSDictionary *conversationInfoDic = [JModelFactory conversationInfoToDic:info];
            [resultDic setObject:conversationInfoDic forKey:@"conversationInfo"];
            result(resultDic);
        } error:^(JErrorCode code) {
            [resultDic setObject:@(code) forKey:@"errorCode"];
            result(resultDic);
        }];
    } else {
        [resultDic setObject:@(JErrorCodeInvalidParam) forKey:@"errorCode"];
        result(resultDic);
    }
}

- (int)getTotalUnreadCount:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray *conversationTypes = d[@"conversationTypes"];
        if (conversationTypes) {
            return [JIM.shared.conversationManager getUnreadCountWithTypes:conversationTypes];
        }
    }
    return [JIM.shared.conversationManager getTotalUnreadCount];
}

- (void)clearUnreadCount:(id)arg
                  result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d];
        [JIM.shared.conversationManager clearUnreadCountByConversation:conversation
                                                               success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    } else {
        result(@(JErrorCodeInvalidParam));
    }
}

- (void)setMute:(id)arg
         result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        BOOL isMute = [d[@"isMute"] boolValue];
        [JIM.shared.conversationManager setMute:isMute
                                   conversation:conversation
                                        success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    } else {
        result(@(JErrorCodeInvalidParam));
    }
}

- (void)setTop:(id)arg
        result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        BOOL isTop = [d[@"isTop"] boolValue];
        [JIM.shared.conversationManager setTop:isTop
                                  conversation:conversation
                                       success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    } else {
        result(@(JErrorCodeInvalidParam));
    }
}

- (void)clearTotalUnreadCount:(FlutterResult)result {
    [JIM.shared.conversationManager clearTotalUnreadCount:^{
        result(@(JErrorCodeNone));
    } error:^(JErrorCode code) {
        result(@(code));
    }];
}

- (void)setUnread:(id)arg
           result:(FlutterResult)result {
   if ([arg isKindOfClass:[NSDictionary class]]) {
       NSDictionary *d = (NSDictionary *)arg;
       JConversation *conversation = [JModelFactory conversationFromDic:d];
       [JIM.shared.conversationManager setUnread:conversation
                                         success:^{
           result(@(JErrorCodeNone));
       } error:^(JErrorCode code) {
           result(@(code));
       }];
   } else {
       result(@(JErrorCodeInvalidParam));
   }
}

#pragma mark - JConnectionDelegate
- (void)connectionStatusDidChange:(JConnectionStatus)status errorCode:(JErrorCode)code extra:(NSString *)extra {
    NSDictionary *dic = @{@"status":@(status), @"code":@(code), @"extra":extra};
    [self.channel invokeMethod:@"onConnectionStatusChange" arguments:dic];
}

- (void)dbDidOpen {
    [self.channel invokeMethod:@"onDbOpen" arguments:nil];
}

- (void)dbDidClose {
    [self.channel invokeMethod:@"onDbClose" arguments:nil];
}

#pragma mark - JConversationDelegate
- (void)conversationInfoDidAdd:(NSArray<JConversationInfo *> *)conversationInfoList {
    NSMutableArray *arr = [NSMutableArray array];
    for (JConversationInfo *info in conversationInfoList) {
        NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
        [arr addObject:infoDic];
    }
    NSDictionary *dic = @{@"conversationInfoList": arr};
    [self.channel invokeMethod:@"onConversationInfoAdd" arguments:dic];
}

- (void)conversationInfoDidUpdate:(NSArray<JConversationInfo *> *)conversationInfoList {
    NSMutableArray *arr = [NSMutableArray array];
    for (JConversationInfo *info in conversationInfoList) {
        NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
        [arr addObject:infoDic];
    }
    NSDictionary *dic = @{@"conversationInfoList": arr};
    [self.channel invokeMethod:@"onConversationInfoUpdate" arguments:dic];
}

- (void)conversationInfoDidDelete:(NSArray<JConversationInfo *> *)conversationInfoList {
    NSMutableArray *arr = [NSMutableArray array];
    for (JConversationInfo *info in conversationInfoList) {
        NSDictionary *infoDic = [JModelFactory conversationInfoToDic:info];
        [arr addObject:infoDic];
    }
    NSDictionary *dic = @{@"conversationInfoList": arr};
    [self.channel invokeMethod:@"onConversationInfoDelete" arguments:dic];
}

- (void)totalUnreadMessageCountDidUpdate:(int)count {
    NSDictionary *dic = @{@"count": @(count)};
    [self.channel invokeMethod:@"onTotalUnreadMessageCountUpdate" arguments:dic];
}

@end
