//
//  JuggleIMFlutterWrapper.m
//  juggle_im
//
//  Created by Fei Li on 2025/5/20.
//

#import "JuggleIMFlutterWrapper.h"
#import <JuggleIM/JuggleIM.h>
#import <JuggleIM/JCallProtocol.h>
#import "JModelFactory.h"
#import "JCallSessionDelegateImpl.h"
#import "JVideoPlatformView.h"

@interface JuggleIMFlutterWrapper () <JConnectionDelegate, JConversationDelegate, JMessageDelegate, JMessageReadReceiptDelegate, JCallReceiveDelegate, JCallSessionDelegateDestruct>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, copy) NSMutableDictionary <NSString *, JCallSessionDelegateImpl *> *callSessionDelegateDic;
@property (nonatomic, strong) JVideoPlatformViewFactory *factory;
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

- (void)setVideoPlatformViewFactory:(JVideoPlatformViewFactory *)factory {
    self.factory = factory;
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
    } else if ([@"sendMessage" isEqualToString:call.method]) {
        [self sendMessage:call.arguments result:result];
    } else if ([@"sendMediaMessage" isEqualToString:call.method]) {
        [self sendMediaMessage:call.arguments result:result];
    } else if ([@"resendMessage" isEqualToString:call.method]) {
        [self resendMessage:call.arguments result:result];
    } else if ([@"resendMediaMessage" isEqualToString:call.method]) {
        [self resendMediaMessage:call.arguments result:result];
    } else if ([@"getMessages" isEqualToString:call.method]) {
        [self getMessages:call.arguments result:result];
    } else if ([@"deleteMessagesByClientMsgNoList" isEqualToString:call.method]) {
        [self deleteMessagesByClientMsgNoList:call.arguments result:result];
    } else if ([@"deleteMessagesByMessageIdList" isEqualToString:call.method]) {
        [self deleteMessagesByMessageIdList:call.arguments result:result];
    } else if ([@"recallMessage" isEqualToString:call.method]) {
        [self recallMessage:call.arguments result:result];
    } else if ([@"clearMessages" isEqualToString:call.method]) {
        [self clearMessages:call.arguments result:result];
    } else if ([@"getMessagesByMessageIdList" isEqualToString:call.method]) {
        [self getMessagesByMessageIdList:call.arguments result:result];
    } else if ([@"getMessagesByClientMsgNoList" isEqualToString:call.method]) {
        [self getMessagesByClientMsgNoList:call.arguments result:result];
    } else if ([@"sendReadReceipt" isEqualToString:call.method]) {
        [self sendReadReceipt:call.arguments result:result];
    } else if ([@"getGroupMessageReadDetail" isEqualToString:call.method]) {
        [self getGroupMessageReadDetail:call.arguments result:result];
    } else if ([@"getMergedMessageList" isEqualToString:call.method]) {
        [self getMergedMessageList:call.arguments result:result];
    } else if ([@"getMentionMessages" isEqualToString:call.method]) {
        [self getMentionMessages:call.arguments result:result];
    } else if ([@"addMessageReaction" isEqualToString:call.method]) {
        [self addMessageReaction:call.arguments result:result];
    } else if ([@"removeMessageReaction" isEqualToString:call.method]) {
        [self removeMessageReaction:call.arguments result:result];
    } else if ([@"getMessagesReaction" isEqualToString:call.method]) {
        [self getMessagesReaction:call.arguments result:result];
    } else if ([@"updateMessage" isEqualToString:call.method]) {
        [self updateMessage:call.arguments result:result];
    } else if ([@"setMessageLocalAttribute" isEqualToString:call.method]) {
        [self setMessageLocalAttribute:call.arguments result:result];
    } else if ([@"getUserInfo" isEqualToString:call.method]) {
        [self getUserInfo:call.arguments result:result];
    } else if ([@"getGroupInfo" isEqualToString:call.method]) {
        [self getGroupInfo:call.arguments result:result];
    } else if ([@"getGroupMember" isEqualToString:call.method]) {
        [self getGroupMember:call.arguments result:result];
    } else if ([@"initZegoEngine" isEqualToString:call.method]) {
        [self initZegoEngine:call.arguments result:result];
    } else if ([@"startSingleCall" isEqualToString:call.method]) {
        [self startSingleCall:call.arguments result:result];
    } else if ([@"startMultiCall" isEqualToString:call.method]) {
        [self startMultiCall:call.arguments result:result];
    } else if ([@"getCallSession" isEqualToString:call.method]) {
        [self getCallSession:call.arguments result:result];
    } else if ([@"callAccept" isEqualToString:call.method]) {
        [self callAccept:call.arguments result:result];
    } else if ([@"callHangup" isEqualToString:call.method]) {
        [self callHangup:call.arguments result:result];
    } else if ([@"callEnableCamera" isEqualToString:call.method]) {
        [self callEnableCamera:call.arguments result:result];
    } else if ([@"callMuteMicrophone" isEqualToString:call.method]) {
        [self callMuteMicrophone:call.arguments result:result];
    } else if ([@"callMuteSpeaker" isEqualToString:call.method]) {
        [self callMuteSpeaker:call.arguments result:result];
    } else if ([@"callSetSpeakerEnable" isEqualToString:call.method]) {
        [self callSetSpeakerEnable:call.arguments result:result];
    } else if ([@"callUseFrontCamera" isEqualToString:call.method]) {
        [self callUseFrontCamera:call.arguments result:result];
    } else if ([@"callInviteUsers" isEqualToString:call.method]) {
        [self callInviteUsers:call.arguments result:result];
    } else if ([@"callSetVideoView" isEqualToString:call.method]) {
        [self callSetVideoView:call.arguments result:result];
    } else if ([@"callStartPreview" isEqualToString:call.method]) {
        [self callStartPreview:call.arguments result:result];
    } else if ([@"setMessageTop" isEqualToString:call.method]) {
        [self setMessageTop:call.arguments result:result];
    } else if ([@"getTopMessage" isEqualToString:call.method]) {
        [self getTopMessage:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)setServers:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray *list = d[@"list"];
        [JIM.shared setServerUrls:list];
    }
}

- (void)initWithAppKey:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *key = d[@"appKey"];
        NSDictionary *config = d[@"config"];
        if (config) {
            NSDictionary *logConfig = config[@"logConfig"];
            if (logConfig) {
                NSNumber *consoleLevel = logConfig[@"consoleLevel"];
                if (consoleLevel) {
                    [JIM.shared setConsoleLogLevel:[consoleLevel intValue]];
                }
            }
        }
        [JIM.shared initWithAppKey:key];
        
        [JIM.shared.connectionManager addDelegate:self];
        [JIM.shared.conversationManager addDelegate:self];
        [JIM.shared.messageManager addDelegate:self];
        [JIM.shared.messageManager addReadReceiptDelegate:self];
        [JIM.shared.callManager addReceiveDelegate:self];
    }
}

#pragma mark - connection
- (void)connectWithToken:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *token = d[@"token"];
        [JIM.shared.connectionManager connectWithToken:token];
    }
}

- (void)disconnect:(id)arg {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        BOOL receivePush = [d[@"receivePush"] boolValue];
        [JIM.shared.connectionManager disconnect:receivePush];
    }
}

- (int)getConnectionStatus {
    return (int)[JIM.shared.connectionManager getConnectionStatus];
}


#pragma mark - conversation
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

#pragma mark - message
- (void)sendMessage:(id)arg
             result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *contentString = d[@"content"];
        NSString *contentType = d[@"contentType"];
        JMessageContent *content = [JModelFactory messageContentFromString:contentString type:contentType];
        if (content) {
            JMessage *message = [JIM.shared.messageManager sendMessage:content
                                                        messageOption:[JModelFactory sendMessageOptionFromDic:d[@"option"]]
                                                       inConversation:[JModelFactory conversationFromDic:d[@"conversation"]]
                                                              success:^(JMessage *message) {
                NSDictionary *messageDic = [JModelFactory messageToDic:message];
                NSDictionary *dic = @{@"message": messageDic};
                [self.channel invokeMethod:@"onMessageSendSuccess" arguments:dic];
            } error:^(JErrorCode errorCode, JMessage *message) {
                NSDictionary *messageDic = [JModelFactory messageToDic:message];
                NSDictionary *dic = @{@"message": messageDic, @"errorCode": @(errorCode)};
                [self.channel invokeMethod:@"onMessageSendError" arguments:dic];
            }];
            NSDictionary *messageDic = [JModelFactory messageToDic:message];
            result(messageDic);
        }
    } else {
        result(@{});
    }
}

- (void)sendMediaMessage:(id)arg
                  result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *contentString = d[@"content"];
        NSString *contentType = d[@"contentType"];
        JMediaMessageContent *content = [JModelFactory mediaMessageContentFromString:contentString type:contentType];
        if (content) {
            JMessage *message = [JIM.shared.messageManager sendMediaMessage:content
                                                              messageOption:[JModelFactory sendMessageOptionFromDic:d[@"option"]]
                                                             inConversation:[JModelFactory conversationFromDic:d[@"conversation"]]
                                                                   progress:^(int progress, JMessage *message) {
                NSDictionary *messageDic = [[JModelFactory messageToDic:message] mutableCopy];
                NSDictionary *dic = @{@"message": messageDic, @"progress": @(progress)};
                [self.channel invokeMethod:@"onMessageProgress" arguments:dic];
            } success:^(JMessage *message) {
                NSDictionary *messageDic = [[JModelFactory messageToDic:message] mutableCopy];
                NSDictionary *dic = @{@"message": messageDic};
                [self.channel invokeMethod:@"onMessageSendSuccess" arguments:dic];
            } error:^(JErrorCode errorCode, JMessage *message) {
                NSDictionary *messageDic = [[JModelFactory messageToDic:message] mutableCopy];
                NSDictionary *dic = @{@"message": messageDic, @"errorCode": @(errorCode)};
                [self.channel invokeMethod:@"onMessageSendError" arguments:dic];
            } cancel:nil];
            NSDictionary *messageDic = [[JModelFactory messageToDic:message] mutableCopy];
            result(messageDic);
        }
    } else {
        result(@{});
    }
}

- (void)resendMessage:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JMessage *message = [JModelFactory messageFromDic:d[@"message"]];
        JMessage *returnMessage = [JIM.shared.messageManager resend:message
                                                            success:^(JMessage *successMessage) {
            NSDictionary *messageDic = [JModelFactory messageToDic:successMessage];
            NSDictionary *dic = @{@"message": messageDic};
            [self.channel invokeMethod:@"onMessageSendSuccess" arguments:dic];
        } error:^(JErrorCode errorCode, JMessage *errorMessage) {
            NSDictionary *messageDic = [JModelFactory messageToDic:errorMessage];
            NSDictionary *dic = @{@"message": messageDic, @"errorCode": @(errorCode)};
            [self.channel invokeMethod:@"onMessageSendError" arguments:dic];
        }];
        NSDictionary *messageDic = [JModelFactory messageToDic:returnMessage];
        result(messageDic);
    }
}

- (void)resendMediaMessage:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSDictionary *messageDictionary = d[@"message"];
        JMessage *message = [JModelFactory messageFromDic:messageDictionary];
        JMessage *returnMessage = [JIM.shared.messageManager resendMediaMessage:message
                                                                       progress:^(int progress, JMessage *progressMessage) {
            NSDictionary *messageDic = [[JModelFactory messageToDic:progressMessage] mutableCopy];
            NSDictionary *dic = @{@"message": messageDic, @"progress": @(progress)};
            [self.channel invokeMethod:@"onMessageProgress" arguments:dic];
        } success:^(JMessage *successMessage) {
            NSDictionary *messageDic = [[JModelFactory messageToDic:successMessage] mutableCopy];
            NSDictionary *dic = @{@"message": messageDic};
            [self.channel invokeMethod:@"onMessageSendSuccess" arguments:dic];
        } error:^(JErrorCode errorCode, JMessage *errorMessage) {
            NSDictionary *messageDic = [[JModelFactory messageToDic:errorMessage] mutableCopy];
            NSDictionary *dic = @{@"message": messageDic, @"errorCode": @(errorCode)};
            [self.channel invokeMethod:@"onMessageSendError" arguments:dic];
        } cancel:nil];
        NSDictionary *messageDic = [[JModelFactory messageToDic:returnMessage] mutableCopy];
        result(messageDic);
    }
}

- (void)getMessages:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSDictionary *conversationDic = d[@"conversation"];
        JConversation *conversation = [JModelFactory conversationFromDic:conversationDic];
        JPullDirection direction = [d[@"direction"] intValue];
        NSDictionary *optionDic = d[@"option"];
        JGetMessageOptions *option = [JModelFactory getMessageOptionFromDic:optionDic];
        [JIM.shared.messageManager getMessages:conversation
                                     direction:direction
                                        option:option
                                      complete:^(NSArray<JMessage *> *messages, long long timestamp, BOOL hasMore, JErrorCode code) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:@(timestamp) forKey:@"timestamp"];
            [resultDic setObject:@(hasMore) forKey:@"hasMore"];
            [resultDic setObject:@(code) forKey:@"errorCode"];
            if (messages.count > 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (JMessage *m in messages) {
                    NSDictionary *messageDic = [JModelFactory messageToDic:m];
                    [arr addObject:messageDic];
                }
                [resultDic setObject:arr forKey:@"messages"];
            }
            result(resultDic);
        }];
    }
}

- (void)deleteMessagesByClientMsgNoList:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSArray<NSNumber *> *clientMsgNoList = d[@"clientMsgNoList"];
        BOOL forAllUsers = [d[@"forAllUsers"] boolValue] ?: NO;
        
        [JIM.shared.messageManager deleteMessagesByClientMsgNoList:clientMsgNoList
                                                      conversation:conversation
                                                       forAllUsers:forAllUsers
                                                           success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)deleteMessagesByMessageIdList:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSArray<NSString *> *messageIdList = d[@"messageIdList"];
        BOOL forAllUsers = [d[@"forAllUsers"] boolValue] ?: NO;
        
        [JIM.shared.messageManager deleteMessagesByMessageIds:messageIdList
                                                 conversation:conversation
                                                  forAllUsers:forAllUsers
                                                      success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)recallMessage:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        [JIM.shared.messageManager recallMessage:d[@"messageId"]
                                          extras:d[@"extra"]
                                         success:^(JMessage *message) {
            NSDictionary *messageDic = [JModelFactory messageToDic:message];
            NSDictionary *resultDic = @{@"message": messageDic, @"errorCode": @(0)};
            result(resultDic);
        } error:^(JErrorCode errorCode) {
            result(@{@"errorCode": @(errorCode)});
        }];
    }
}

- (void)clearMessages:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        BOOL forAllUsers = NO;
        if (d[@"forAllUsers"]) {
            forAllUsers = [d[@"forAllUsers"] boolValue];
        }
        [JIM.shared.messageManager clearMessagesIn:conversation
                                         startTime:[d[@"startTime"] longLongValue]
                                       forAllUsers:forAllUsers
                                           success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode errorCode) {
            result(@(errorCode));
        }];
    }
}

- (void)getMessagesByMessageIdList:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray *messageIdList = d[@"messageIdList"];
        NSArray<JMessage *> *messageList = [JIM.shared.messageManager getMessagesByMessageIds:messageIdList];
        NSMutableArray *resultList = [NSMutableArray array];
        for (JMessage *message in messageList) {
            NSDictionary *messageDic = [JModelFactory messageToDic:message];
            [resultList addObject:messageDic];
        }
        result(resultList);
    }
}

- (void)getMessagesByClientMsgNoList:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray *clientMsgNoList = d[@"clientMsgNoList"];
        NSArray<JMessage *> *messageList = [JIM.shared.messageManager getMessagesByClientMsgNos:clientMsgNoList];
        NSMutableArray *resultList = [NSMutableArray array];
        for (JMessage *message in messageList) {
            NSDictionary *messageDic = [JModelFactory messageToDic:message];
            [resultList addObject:messageDic];
        }
        result(resultList);
    }
}

- (void)sendReadReceipt:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSArray <NSString *> *messageIdList = d[@"messageIdList"];
        [JIM.shared.messageManager sendReadReceipt:messageIdList
                                    inConversation:conversation
                                           success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)getGroupMessageReadDetail:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        [JIM.shared.messageManager getGroupMessageReadDetail:d[@"messageId"]
                                              inConversation:conversation
                                                     success:^(NSArray<JUserInfo *> *readMembers, NSArray<JUserInfo *> *unreadMembers) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            NSMutableArray *readMemberDicArray = [NSMutableArray array];
            NSMutableArray *unreadMemberDicArray = [NSMutableArray array];
            for (JUserInfo *userInfo in readMembers) {
                NSDictionary *readMemberDic = [JModelFactory userInfoToDic:userInfo];
                [readMemberDicArray addObject:readMemberDic];
            }
            for (JUserInfo *userInfo in unreadMembers) {
                NSDictionary *unreadMemberDic = [JModelFactory userInfoToDic:userInfo];
                [unreadMemberDicArray addObject:unreadMemberDic];
            }
            [resultDic setObject:@(JErrorCodeNone) forKey:@"errorCode"];
            [resultDic setObject:readMemberDicArray forKey:@"readMembers"];
            [resultDic setObject:unreadMemberDicArray forKey:@"unreadMembers"];
            result(resultDic);
        } error:^(JErrorCode code) {
            result(@{@"errorCode": @(code)});
        }];
    }
}

- (void)getMergedMessageList:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *messageId = d[@"messageId"];
        [JIM.shared.messageManager getMergedMessageList:messageId
                                                success:^(NSArray<JMessage *> *mergedMessages) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:@(JErrorCodeNone) forKey:@"errorCode"];
            NSMutableArray *messageDicList = [NSMutableArray array];
            for (JMessage *message in mergedMessages) {
                NSDictionary *messageDic = [JModelFactory messageToDic:message];
                [messageDicList addObject:messageDic];
            }
            [resultDic setObject:messageDicList forKey:@"messages"];
            result(resultDic);
        } error:^(JErrorCode code) {
            result(@{@"errorCode": @(code)});
        }];
    }
}

- (void)getMentionMessages:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"convesation"]];
        int count = [d[@"count"] intValue];
        long long timestamp = [d[@"timestamp"] longLongValue];
        JPullDirection direction = [d[@"direction"] intValue];
        [JIM.shared.messageManager getMentionMessages:conversation
                                                count:count
                                                 time:timestamp
                                            direction:direction
                                              success:^(NSArray<JMessage *> *messages, BOOL isFinished) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:@(JErrorCodeNone) forKey:@"errorCode"];
            NSMutableArray *messageDicList = [NSMutableArray array];
            for (JMessage *message in messages) {
                NSDictionary *messageDic = [JModelFactory messageToDic:message];
                [messageDicList addObject:messageDic];
            }
            [resultDic setObject:messageDicList forKey:@"messages"];
            [resultDic setObject:@(isFinished) forKey:@"isFinished"];
            result(resultDic);
        } error:^(JErrorCode code) {
            result(@{@"errorCode": @(code)});
        }];
    }
}

- (void)addMessageReaction:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *messageId = d[@"messageId"];
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSString *reactionId = d[@"reactionId"];
        [JIM.shared.messageManager addMessageReaction:messageId
                                         conversation:conversation
                                           reactionId:reactionId
                                              success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)removeMessageReaction:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *messageId = d[@"messageId"];
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        NSString *reactionId = d[@"reactionId"];
        [JIM.shared.messageManager removeMessageReaction:messageId
                                            conversation:conversation
                                              reactionId:reactionId
                                                 success:^{
            result(@(JErrorCodeNone));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)getMessagesReaction:(id)arg result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSArray<NSString *> *messageIdList = d[@"messageIdList"];
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        [JIM.shared.messageManager getMessagesReaction:messageIdList
                                          conversation:conversation
                                               success:^(NSArray<JMessageReaction *> *reactionList) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:@(JErrorCodeNone) forKey:@"errorCode"];
            NSMutableArray *reactionDicArr = [NSMutableArray array];
            for (JMessageReaction *reaction in reactionList) {
                NSDictionary *reactionDic = [JModelFactory messageReactionToDic:reaction];
                [reactionDicArr addObject:reactionDic];
            }
            [resultDic setObject:reactionDicArr forKey:@"reactionList"];
            result(resultDic);
        } error:^(JErrorCode code) {
            result(@{@"errorCode": @(code)});
        }];
    }
}

- (void)updateMessage:(id)arg
               result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *contentString = d[@"content"];
        NSString *contentType = d[@"contentType"];
        JMessageContent *content = [JModelFactory messageContentFromString:contentString type:contentType];
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        [JIM.shared.messageManager updateMessage:content
                                       messageId:d[@"messageId"]
                                  inConversation:conversation
                                         success:^(JMessage *message) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
            [resultDic setObject:@(JErrorCodeNone) forKey:@"errorCode"];
            NSDictionary *messageDic = [JModelFactory messageToDic:message];
            [resultDic setObject:messageDic forKey:@"message"];
            result(resultDic);
        } error:^(JErrorCode code) {
            result(@{@"errorCode": @(code)});
        }];
    }
}

- (void)setMessageLocalAttribute:(id)arg
                          result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        int clientMsgNo = [d[@"clientMsgNo"] intValue];
        NSString *attribute = d[@"attribute"];
        [JIM.shared.messageManager setLocalAttribute:attribute forClientMsgNo:clientMsgNo];
        result(nil);
    }
}

- (void)setMessageTop:(id)arg
               result:(FlutterResult)result {
    if ([arg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *d = (NSDictionary *)arg;
        NSString *messageId = d[@"messageId"];
        JConversation *conversation = [JModelFactory conversationFromDic:d[@"conversation"]];
        BOOL isTop = [d[@"isTop"] boolValue];
        [JIM.shared.messageManager setTop:isTop
                                messageId:messageId
                             conversation:conversation
                                  success:^{
            result(@(0));
        } error:^(JErrorCode code) {
            result(@(code));
        }];
    }
}

- (void)getTopMessage:(id)arg
               result:(FlutterResult)result {
    NSDictionary *d = (NSDictionary *)arg;
    JConversation *conversation = [JModelFactory conversationFromDic:d];
    [JIM.shared.messageManager getTopMessage:conversation
                                     success:^(JMessage *message, JUserInfo *userInfo, long long timestamp) {
        NSDictionary *messageDic = [JModelFactory messageToDic:message];
        NSDictionary *userDic = [JModelFactory userInfoToDic:userInfo];
        NSDictionary *resultDic = @{@"message": message, @"userInfo": userInfo, @"timestamp": @(timestamp), @"errorCode": @(0)};
        result(resultDic);
    } error:^(JErrorCode code) {
        result(@{@"errorCode": @(code)});
    }];
}

#pragma mark - user
- (void)getUserInfo:(id)arg
             result:(FlutterResult)result {
    NSString *userId = arg;
    JUserInfo *userInfo = [JIM.shared.userInfoManager getUserInfo:userId];
    NSDictionary *dic = [JModelFactory userInfoToDic:userInfo];
    result(dic);
}

- (void)getGroupInfo:(id)arg
              result:(FlutterResult)result {
    NSString *groupId = arg;
    JGroupInfo *groupInfo = [JIM.shared.userInfoManager getGroupInfo:groupId];
    NSDictionary *dic = [JModelFactory groupInfoToDic:groupInfo];
    result(dic);
}

- (void)getGroupMember:(id)arg
                result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *groupId = dic[@"groupId"];
    NSString *userId = dic[@"userId"];
    JGroupMember *member = [JIM.shared.userInfoManager getGroupMember:groupId userId:userId];
    NSDictionary *resultDic = [JModelFactory groupMemberToDic:member];
    result(resultDic);
}

#pragma mark - call
- (void)initZegoEngine:(id)arg
                result:(FlutterResult)result {
    NSDictionary *dic = arg;
    int appId = [dic[@"appId"] intValue];
    NSString *appSign = dic[@"appSign"];
    [JIM.shared.callManager initZegoEngineWith:appId appSign:appSign];
    result(nil);
}

- (void)startSingleCall:(id)arg
                 result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *userId = dic[@"userId"];
    JCallMediaType mediaType = [dic[@"mediaType"] intValue];
    NSString *extra = dic[@"extra"];
    id<JCallSession> callSession = [JIM.shared.callManager startSingleCall:userId mediaType:mediaType extra:extra delegate:nil];
    if (callSession) {
        NSDictionary *resultDic = [JModelFactory callSessionToDic:callSession];
        [self addCallSessionDelegate:callSession];
        result(resultDic);
    } else {
        result([NSDictionary dictionary]);
    }
}

- (void)startMultiCall:(id)arg
                result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSArray<NSString *> *userIdList = dic[@"userIdList"];
    JCallMediaType mediaType = [dic[@"mediaType"] intValue];
    id<JCallSession> callSession = nil;
    callSession = [JIM.shared.callManager startMultiCall:userIdList mediaType:mediaType delegate:nil];
    if (callSession) {
        NSDictionary *resultDic = [JModelFactory callSessionToDic:callSession];
        [self addCallSessionDelegate:callSession];
        result(resultDic);
    } else {
        result([NSDictionary dictionary]);
    }
}

- (void)getCallSession:(id)arg
                result:(FlutterResult)result {
    NSString *callId = arg;
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    if (callSession) {
        NSDictionary *resultDic = [JModelFactory callSessionToDic:callSession];
        result(resultDic);
    } else {
        result([NSDictionary dictionary]);
    }
}

- (void)callAccept:(id)arg
            result:(FlutterResult)result {
    NSString *callId = arg;
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession accept];
    result(nil);
}

- (void)callHangup:(id)arg
            result:(FlutterResult)result {
    NSString *callId = arg;
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession hangup];
    result(nil);
}

- (void)callEnableCamera:(id)arg
                  result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    BOOL isEnable = [dic[@"isEnable"] boolValue];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession enableCamera:isEnable];
    result(nil);
}

- (void)callMuteMicrophone:(id)arg
                    result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    BOOL isMute = [dic[@"isMute"] boolValue];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession muteMicrophone:isMute];
    result(nil);
}

- (void)callMuteSpeaker:(id)arg
                 result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    BOOL isMute = [dic[@"isMute"] boolValue];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession muteSpeaker:isMute];
    result(nil);
}

- (void)callSetSpeakerEnable:(id)arg
                      result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    BOOL isEnable = [dic[@"isEnable"] boolValue];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession setSpeakerEnable:isEnable];
    result(nil);
}

- (void)callUseFrontCamera:(id)arg
                    result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    BOOL isEnable = [dic[@"isEnable"] boolValue];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession useFrontCamera:isEnable];
    result(nil);
}

- (void)callInviteUsers:(id)arg
                 result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    NSArray<NSString *> *userIdList = dic[@"userIdList"];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession inviteUsers:userIdList];
    result(nil);
}

- (void)callSetVideoView:(id)arg
                  result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    NSString *userId = dic[@"userId"];
    NSString *viewId = dic[@"viewId"];
    
    JVideoPlatformView *view = (JVideoPlatformView *)[self.factory getViewById:viewId];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession setVideoView:view.view forUserId:userId];
    result(nil);
}

- (void)callStartPreview:(id)arg
                  result:(FlutterResult)result {
    NSDictionary *dic = arg;
    NSString *callId = dic[@"callId"];
    NSString *viewId = dic[@"viewId"];
    
    JVideoPlatformView *view = (JVideoPlatformView *)[self.factory getViewById:viewId];
    id<JCallSession> callSession = [JIM.shared.callManager getCallSession:callId];
    [callSession startPreview:view.view];
    result(nil);
}

#pragma mark - JConnectionDelegate
- (void)connectionStatusDidChange:(JConnectionStatus)status errorCode:(JErrorCode)code extra:(NSString *)extra {
    NSMutableDictionary *dic = [@{@"status":@(status), @"code":@(code)} mutableCopy];
    if (extra.length > 0) {
        [dic setObject:extra forKey:@"extra"];
    }
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

#pragma mark - JMessageDelegate
- (void)messageDidReceive:(JMessage *)message {
    NSDictionary *messageDic = [JModelFactory messageToDic:message];
    [self.channel invokeMethod:@"onMessageReceive" arguments:messageDic];
}

- (void)messageDidRecall:(JMessage *)message {
    NSDictionary *messageDic = [JModelFactory messageToDic:message];
    [self.channel invokeMethod:@"onMessageRecall" arguments:messageDic];
}

- (void)messageDidDelete:(JConversation *)conversation clientMsgNos:(NSArray<NSNumber *> *)clientMsgNos {
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSDictionary *dic = @{@"conversation": conversationDic, @"clientMsgNoList": clientMsgNos};
    [self.channel invokeMethod:@"onMessageDelete" arguments:dic];
}

- (void)messageDidClear:(JConversation *)conversation timestamp:(long long)timestamp senderId:(NSString *)senderId {
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSMutableDictionary *dic = [@{@"conversation": conversationDic, @"timestamp": @(timestamp)} mutableCopy];
    if (senderId.length > 0) {
        [dic setObject:senderId forKey:@"senderId"];
    }
    [self.channel invokeMethod:@"onMessageClear" arguments:dic];
}

- (void)messageDidUpdate:(JMessage *)message {
    NSDictionary *messageDic = [JModelFactory messageToDic:message];
    [self.channel invokeMethod:@"onMessageUpdate" arguments:messageDic];
}

- (void)messageReactionDidAdd:(JMessageReaction *)reaction inConversation:(JConversation *)conversation {
    NSDictionary *reactionDic = [JModelFactory messageReactionToDic:reaction];
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSDictionary *dic = @{@"reaction": reactionDic, @"conversation": conversationDic};
    [self.channel invokeMethod:@"onMessageReactionAdd" arguments:dic];
}

- (void)messageReactionDidRemove:(JMessageReaction *)reaction inConversation:(JConversation *)conversation {
    NSDictionary *reactionDic = [JModelFactory messageReactionToDic:reaction];
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSDictionary *dic = @{@"reaction": reactionDic, @"conversation": conversationDic};
    [self.channel invokeMethod:@"onMessageReactionRemove" arguments:dic];
}

- (void)messageDidSetTop:(BOOL)isTop message:(JMessage *)message user:(JUserInfo *)userInfo {
    NSDictionary *messageDic = [JModelFactory messageToDic:message];
    NSDictionary *userDic = [JModelFactory userInfoToDic:userInfo];
    NSDictionary *dic = @{@"message": messageDic, @"userInfo": userDic, @"isTop": @(isTop)};
    [self.channel invokeMethod:@"onMessageSetTop" arguments:dic];
}

#pragma mark - JMessageReadReceiptDelegate
- (void)messagesDidRead:(NSArray<NSString *> *)messageIds inConversation:(JConversation *)conversation {
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSDictionary *dic = @{@"conversation": conversationDic, @"messageIdList": messageIds};
    [self.channel invokeMethod:@"onMessagesRead" arguments:dic];
}

- (void)groupMessagesDidRead:(NSDictionary<NSString *,JGroupMessageReadInfo *> *)msgs inConversation:(JConversation *)conversation {
    NSDictionary *conversationDic = [JModelFactory conversationToDic:conversation];
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
    [msgs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull messageId, JGroupMessageReadInfo * _Nonnull info, BOOL * _Nonnull stop) {
        NSDictionary *infoDic = [JModelFactory groupMessageReadInfoToDic:info];
        [msgDic setObject:infoDic forKey:messageId];
    }];
    NSDictionary *dic = @{@"conversation": conversationDic, @"messages": msgDic};
    [self.channel invokeMethod:@"onGroupMessagesRead" arguments:dic];
}

#pragma mark - JCallReceiveDelegate
- (void)callDidReceive:(id<JCallSession>)callSession {
    NSDictionary *callSessionDic = [JModelFactory callSessionToDic:callSession];
    [self addCallSessionDelegate:callSession];
    [self.channel invokeMethod:@"onCallReceive" arguments:callSessionDic];
}

#pragma mark - JCallSessionDelegateDestruct
- (void)destructCallSessionDelegate:(NSString *)callId {
    [self.callSessionDelegateDic removeObjectForKey:callId];
}

#pragma mark - private
- (void)addCallSessionDelegate:(id<JCallSession>)callSession {
    JCallSessionDelegateImpl *impl = [JCallSessionDelegateImpl delegateWithChannel:self.channel callId:callSession.callId];
    [callSession addDelegate:impl];
    
    impl.destruct = self;
    [self.callSessionDelegateDic setObject:impl forKey:callSession.callId];
}

- (NSMutableDictionary<NSString *,JCallSessionDelegateImpl *> *)callSessionDelegateDic {
    if (!_callSessionDelegateDic) {
        _callSessionDelegateDic = [NSMutableDictionary dictionary];
    }
    return _callSessionDelegateDic;
}


@end
