//
//  YXHtmlEditTool.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/27.
//

#import <Foundation/Foundation.h>
#import "YXEmojiDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHtmlEditTool : NSObject

/// 获取IMG标签
+ (NSArray *)getImgTags:(NSString *)htmlText;

/// 正则匹配
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
/**
 * 正则替换
 */
+ (NSString *)matchReplaceHtmlString:(NSString *)string
                         RegexString:(NSString *)regexStr
                          withString:(NSString *)replaceStr;
/// 将表情desc匹配到本地地址，匹配不到返回空
/// @param desc 表情
+ (NSString *)emojiPathWithDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
