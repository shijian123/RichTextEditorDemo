//
//  YXTextAttachment.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXTextAttachment.h"

@implementation YXTextAttachment
+ (YXTextAttachment *)attachmentWith:(YXEmojiItemModel *)emoji font:(UIFont *)font {
    YXTextAttachment *attachment = [[YXTextAttachment alloc] init];
    attachment.desc = emoji.desc;
    attachment.imageName = emoji.imageName;
    attachment.bounds = CGRectMake(0, font.descender, font.lineHeight, font.lineHeight);
    attachment.image = emoji.image;
    return attachment;
}

@end
