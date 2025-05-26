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
+ (NSDictionary *)messageContentToDic:(JMessageContent *)content;
+ (NSDictionary *)groupMessageReadInfoToDic:(JGroupMessageReadInfo *)info;
+ (NSDictionary *)userInfoToDic:(JUserInfo *)info;
+ (NSDictionary *)messageMentionInfoToDic:(JMessageMentionInfo *)info;
+ (NSDictionary *)messageToDic:(JMessage *)message;

+ (JConversation *)conversationFromDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
