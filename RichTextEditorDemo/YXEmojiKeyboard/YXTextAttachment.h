//
//  YXTextAttachment.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "YXEmojiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXTextAttachment : NSTextAttachment
+ (YXTextAttachment *)attachmentWith:(YXEmojiItemModel *)emoji font:(UIFont *)font;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
