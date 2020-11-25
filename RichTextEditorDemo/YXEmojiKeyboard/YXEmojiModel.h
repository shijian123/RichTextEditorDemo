//
//  YXEmojiModel.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import "YXEmojiGifImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiItemModel : NSObject
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) YXEmojiGifImage *gifImage;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

@interface YXEmojiGroupModel : NSObject

@property (nonatomic, copy) NSString *cover_pic;

@property (nonatomic, copy) NSString *folderName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isLargeEmoji;

@property (nonatomic, strong) NSArray<YXEmojiItemModel *> *emojis;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
