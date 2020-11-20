//
//  YXHtmlEditHeaderView.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXHtmlEditHeaderView : UIView
@property (nonatomic) void(^selectTagsBlock)(void);
@property (nonatomic, strong) UITextField *titleTF;

@end

NS_ASSUME_NONNULL_END
