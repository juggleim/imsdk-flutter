//
//  JModelFactory.h
//  juggle_im
//
//  Created by Fei Li on 2025/5/22.
//

#import <Foundation/Foundation.h>
#import <JuggleIM/JuggleIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface JModelFactory : NSObject

+ (NSDictionary *)conversationToDic:(JConversation *)conversation;
+ (NSDictionary *)conversationMentionMessageToDic:(JConversationMentionMessage *)message;
+ (NSDictionary *)conversationMentionInfoToDic:(JConversationMentionInfo *)info;
+ (NSDictionary *)conversationInfoToDic:(JConversationInfo *)conversationInfo;
+ (NSString *)messageContentToString:(JMessageContent *)content;
+ (NSDictionary *)groupMessageReadInfoToDic:(JGroupMessageReadInfo *)info;
+ (NSDictionary *)userInfoToDic:(JUserInfo *)info;
+ (NSDictionary *)groupInfoToDic:(JGroupInfo *)info;
+ (NSDictionary *)groupMemberToDic:(JGroupMember *)member;
+ (NSDictionary *)messageMentionInfoToDic:(JMessageMentionInfo *)info;
+ (NSDictionary *)messageToDic:(JMessage *)message;
+ (NSDictionary *)messageReactionToDic:(JMessageReaction *)reaction;

+ (JConversation *)conversationFromDic:(NSDictionary *)dic;
+ (JMessage *)messageFromDic:(NSDictionary *)dic;
+ (JMessageOptions *)sendMessageOptionFromDic:(NSDictionary *)dic;
+ (JGetMessageOptions *)getMessageOptionFromDic:(NSDictionary *)dic;

+ (JMessageContent *)messageContentFromString:(NSString *)string
                                         type:(nonnull NSString *)contentType;
+ (JMediaMessageContent *)mediaMessageContentFromString:(NSString *)string
                                                type:(NSString *)contentType;

@end

NS_ASSUME_NONNULL_END
