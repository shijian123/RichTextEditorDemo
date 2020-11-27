//
//  YXEmojiContentView.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "YXEmojiDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiContentView : UIView
@property (nonatomic) void(^clickEmojiItemBlock)(YXEmojiItemModel *model);

- (void)reloadContentView;

@end

NS_ASSUME_NONNULL_END
