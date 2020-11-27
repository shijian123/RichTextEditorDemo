//
//  YXEmojiInputView.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "YXEmojiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiInputView : UIView
@property (nonatomic) void(^clickEmojiItemBlock)(YXEmojiItemModel *model);
@property (nonatomic) void(^clickDeleteEmojiBlock)(void);

@end

NS_ASSUME_NONNULL_END
