//
//  YXEmojiModel.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXEmojiModel.h"
#import "YXEmojiGifImage.h"

@implementation YXEmojiItemModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.imageName = dict[@"image"];
        self.desc = dict[@"desc"];
    }
    return self;
}

@end

@implementation YXEmojiGroupModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.cover_pic = dict[@"cover_pic"];
        self.title = dict[@"title"];
        self.folderName = dict[@"folderName"];
        self.isLargeEmoji = [dict[@"isLargeEmoji"] boolValue];
        NSMutableArray *arrM = [NSMutableArray array];
        
        NSString *emojiBundlePath = [[NSBundle mainBundle] pathForResource:@"EmojiPackage" ofType:@"bundle"];
        NSString *sourcePath = [[NSBundle bundleWithPath:emojiBundlePath] pathForResource:dict[@"folderName"] ofType:nil];
        
        NSArray<NSDictionary *> *emojis = dict[@"emojis"];
        for (int i = 0; i < emojis.count; i ++) {
            NSDictionary *emojiDict = emojis[i];
            YXEmojiItemModel *emoji = [[YXEmojiItemModel alloc] init];
            NSString *imagePath = [sourcePath stringByAppendingPathComponent:emojiDict[@"image"]];
            emoji.imageName = emojiDict[@"image"];
            emoji.desc = emojiDict[@"desc"];
            emoji.image = [UIImage imageWithContentsOfFile:imagePath];
            emoji.gifImage = [YXEmojiGifImage imageWithContentsOfFile:imagePath];
            [arrM addObject:emoji];
        }
        self.emojis = arrM;
    }
    return self;
}

@end

