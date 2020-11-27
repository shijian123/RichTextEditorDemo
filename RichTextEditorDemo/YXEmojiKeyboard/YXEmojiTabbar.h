//
//  YXEmojiTabbar.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiTabbar : UIView
@property (nonatomic) void(^clickEmojiPackageBlock)(NSInteger index);
@property (nonatomic) void(^clickDeleteEmojiBlock)(void);

@end

NS_ASSUME_NONNULL_END
