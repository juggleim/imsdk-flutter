//
//  JModelExtension.h
//  juggle_im
//
//  Created by Fei Li on 2025/5/30.
//

#import <Foundation/Foundation.h>
#import <JuggleIM/JuggleIM.h>

NS_ASSUME_NONNULL_BEGIN

@interface JModelExtension : NSObject

+ (NSDictionary *)extendDic:(NSDictionary *)dic
        forConversationInfo:(JConversationInfo *)info;

+ (NSDictionary *)extendDic:(NSDictionary *)dic
                 forMessage:(JMessage *)info;

@end

NS_ASSUME_NONNULL_END
