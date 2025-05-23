//
//  JuggleIMFlutterWrapper.m
//  juggle_im
//
//  Created by Fei Li on 2025/5/20.
//

#import "JuggleIMFlutterWrapper.h"
#import <JuggleIM/JuggleIM.h>
#import "JModelFactory.h"

@interface JuggleIMFlutterWrapper () <JConnectionDelegate>
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
        NSLog(@"sdfasdfasdfasdfasdfadf, appKey is %@", key);
        
        [JIM.shared.connectionManager addDelegate:self];
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

@end
