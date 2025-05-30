//
//  JModelExtension.m
//  juggle_im
//
//  Created by Fei Li on 2025/5/30.
//

#import "JModelExtension.h"
#import "JModelFactory.h"

@implementation JModelExtension

+ (NSDictionary *)extendDic:(NSDictionary *)dic
        forConversationInfo:(JConversationInfo *)info {
    NSMutableDictionary *mDic = [dic mutableCopy];
    if (info.conversation.conversationType == JConversationTypePrivate) {
        JUserInfo *userInfo = [JIM.shared.userInfoManager getUserInfo:info.conversation.conversationId];
        if (userInfo.userName.length > 0) {
            [mDic setObject:userInfo.userName forKey:@"name"];
        }
        if (userInfo.portrait.length > 0) {
            [mDic setObject:userInfo.portrait forKey:@"portrait"];
        }
        if (userInfo.extraDic.count > 0) {
            [mDic setObject:userInfo.extraDic forKey:@"extra"];
        }
    } else if (info.conversation.conversationType == JConversationTypeGroup) {
        JGroupInfo *groupInfo = [JIM.shared.userInfoManager getGroupInfo:info.conversation.conversationId];
        if (groupInfo.groupName.length > 0) {
            [mDic setObject:groupInfo.groupName forKey:@"name"];
        }
        if (groupInfo.portrait.length > 0) {
            [mDic setObject:groupInfo.portrait forKey:@"portrait"];
        }
        if (groupInfo.extraDic.count > 0) {
            [mDic setObject:groupInfo.extraDic forKey:@"extra"];
        }
    }
    return [mDic copy];
}

+ (NSDictionary *)extendDic:(NSDictionary *)dic
                 forMessage:(JMessage *)message {
    NSMutableDictionary *mDic = [dic mutableCopy];
    JUserInfo *userInfo = [JIM.shared.userInfoManager getUserInfo:message.senderUserId];
    if (userInfo) {
        NSDictionary *userInfoDic = [JModelFactory userInfoToDic:userInfo];
        [mDic setObject:userInfoDic forKey:@"sender"];
    }
    return [mDic copy];
}

@end
