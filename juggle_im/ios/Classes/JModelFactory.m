//
//  JModelFactory.m
//  juggle_im
//
//  Created by Fei Li on 2025/5/22.
//

#import "JModelFactory.h"

@implementation JModelFactory

#pragma mark - model2Dic
+ (NSDictionary *)conversationToDic:(JConversation *)conversation {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(conversation.conversationType) forKey:@"conversationType"];
    [dic setObject:conversation.conversationId forKey:@"conversationId"];
    return [dic copy];
}

+ (NSDictionary *)conversationMentionMessageToDic:(JConversationMentionMessage *)message {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (message.senderId) {
        [dic setObject:message.senderId forKey:@"senderId"];
    }
    if (message.msgId) {
        [dic setObject:message.msgId forKey:@"msgId"];
    }
    [dic setObject:@(message.msgTime) forKey:@"msgTime"];
    [dic setObject:@(message.type) forKey:@"type"];
    return [dic copy];
}

+ (NSDictionary *)conversationMentionInfoToDic:(JConversationMentionInfo *)info {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *list = [NSMutableArray array];
    for (JConversationMentionMessage *message in info.mentionMsgList) {
        [list addObject:[self conversationMentionMessageToDic:message]];
    }
    [dic setObject:list forKey:@"mentionMsgList"];
    
    return [dic copy];
}

+ (NSDictionary *)conversationInfoToDic:(JConversationInfo *)conversationInfo {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self conversationToDic:conversationInfo.conversation] forKey:@"conversation"];
    [dic setObject:@(conversationInfo.unreadCount) forKey:@"unreadCount"];
    [dic setObject:@(conversationInfo.hasUnread) forKey:@"hasUnread"];
    [dic setObject:@(conversationInfo.sortTime) forKey:@"sortTime"];
    if (conversationInfo.lastMessage) {
        [dic setObject:[self messageToDic:conversationInfo.lastMessage] forKey:@"lastMessage"];
    }
    [dic setObject:@(conversationInfo.isTop) forKey:@"isTop"];
    [dic setObject:@(conversationInfo.topTime) forKey:@"topTime"];
    [dic setObject:@(conversationInfo.mute) forKey:@"mute"];
    if (conversationInfo.draft) {
        [dic setObject:conversationInfo.draft forKey:@"draft"];
    }
    [dic setObject:[self conversationMentionInfoToDic:conversationInfo.mentionInfo] forKey:@"mentionInfo"];
    return [dic copy];
}

+ (NSDictionary *)messageContentToDic:(JMessageContent *)content {
    NSData *data = [content encode];
    if (!data) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSDictionary *)groupMessageReadInfoToDic:(JGroupMessageReadInfo *)info {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(info.readCount) forKey:@"readCount"];
    [dic setObject:@(info.memberCount) forKey:@"memberCount"];
    return [dic copy];
}

+ (NSDictionary *)userInfoToDic:(JUserInfo *)info {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (info.userId) {
        [dic setObject:info.userId forKey:@"userId"];
    }
    if (info.userName) {
        [dic setObject:info.userName forKey:@"userName"];
    }
    if (info.portrait) {
        [dic setObject:info.portrait forKey:@"portrait"];
    }
    if (info.extraDic) {
        [dic setObject:info.extraDic forKey:@"extraDic"];
    }
    [dic setObject:@(info.type) forKey:@"type"];
    return [dic copy];
}

+ (NSDictionary *)messageMentionInfoToDic:(JMessageMentionInfo *)info {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(info.type) forKey:@"type"];
    if (info.targetUsers) {
        NSMutableArray *a = [NSMutableArray array];
        for (JUserInfo *userInfo in info.targetUsers) {
            NSDictionary *userDic = [self userInfoToDic:userInfo];
            [a addObject:userDic];
        }
        [dic setObject:a forKey:@"targetUsers"];
    }
    return [dic copy];
}

+ (NSDictionary *)messageToDic:(JMessage *)message {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self conversationToDic:message.conversation] forKey:@"conversation"];
    if (message.contentType) {
        [dic setObject:message.contentType forKey:@"contentType"];
    }
    [dic setObject:@(message.clientMsgNo) forKey:@"clientMsgNo"];
    if (message.messageId) {
        [dic setObject:message.messageId forKey:@"messageId"];
    }
    [dic setObject:@(message.direction) forKey:@"direction"];
    [dic setObject:@(message.messageState) forKey:@"messageState"];
    [dic setObject:@(message.hasRead) forKey:@"hasRead"];
    [dic setObject:@(message.timestamp) forKey:@"timestamp"];
    if (message.senderUserId) {
        [dic setObject:message.senderUserId forKey:@"senderUserId"];
    }
    NSDictionary *contentDic = [self messageContentToDic:message.content];
    if (contentDic) {
        [dic setObject:contentDic forKey:@"content"];
    }
    if (message.groupReadInfo) {
        [dic setObject:[self groupMessageReadInfoToDic:message.groupReadInfo] forKey:@"groupReadInfo"];
    }
    if (message.mentionInfo) {
        [dic setObject:[self messageMentionInfoToDic:message.mentionInfo] forKey:@"mentionInfo"];
    }
    if (message.referredMsg) {
        [dic setObject:[self messageToDic:message.referredMsg] forKey:@"referredMsg"];
    }
    if (message.localAttribute) {
        [dic setObject:message.localAttribute forKey:@"localAttribute"];
    }
    [dic setObject:@(message.isEdit) forKey:@"isEdit"];
    return [dic copy];
}

#pragma mark - dic2Model
+ (JConversation *)conversationFromDic:(NSDictionary *)dic {
    JConversation *c = [JConversation new];
    c.conversationType = [dic[@"conversationType"] intValue];
    c.conversationId = dic[@"conversationId"];
    return c;
}

+ (JTextMessage *)textMessageFromDic:(NSDictionary *)dic {
    JTextMessage *text = [JTextMessage new];
    text.content = dic[@"content"];
    text.extra = dic[@"extra"];
    return text;
}

+ (JMessageOptions *)sendMessageOptionFromDic:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    JMessageOptions *option = [JMessageOptions new];
    if (dic[@"mentionInfo"]) {
        option.mentionInfo = [self messageMentionInfoFromDic:dic[@"mentionInfo"]];
    }
    option.referredMsgId = dic[@"referredMsgId"];
    if (dic[@"pushData"]) {
        option.pushData = [self pushDataFromDic:dic[@"pushData"]];
    }
    return option;
}

+ (JMessageMentionInfo *)messageMentionInfoFromDic:(NSDictionary *)dic {
    JMessageMentionInfo *info = [JMessageMentionInfo new];
    info.type = [dic[@"type"] intValue];
    NSArray *targetUsersDic = dic[@"targetUsers"];
    if (targetUsersDic) {
        NSMutableArray *userList = [NSMutableArray array];
        for (NSDictionary *userDic in targetUsersDic) {
            JUserInfo *userInfo = [self userInfoFromDic:userDic];
            [userList addObject:userInfo];
        }
        info.targetUsers = userList;
    }
    return info;
}

+ (JUserInfo *)userInfoFromDic:(NSDictionary *)dic {
    JUserInfo *info = [JUserInfo new];
    info.userId = dic[@"userId"];
    info.userName = dic[@"userName"];
    info.portrait = dic[@"portrait"];
    info.extraDic = dic[@"extraDic"];
    info.type = [dic[@"type"] intValue];
    return info;
}

+ (JPushData *)pushDataFromDic:(NSDictionary *)dic {
    JPushData *data = [JPushData new];
    data.content = dic[@"content"];
    data.extra = dic[@"extra"];
    return data;
}


@end
