//
//  YXHtmlFontStyleBar.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//当前view高度
#define YXFontBar_Height 44

@class YXHtmlFontStyleBar;

@protocol YXHtmlFontStyleBarDelegate<NSObject>

- (void)fontBar:(YXHtmlFontStyleBar *)fontBar didClickBtn:(UIButton *)button;
- (void)fontBarResetNormalFontSize;

@end

@interface YXHtmlFontStyleBar : UIView
@property (nonatomic, weak) id<YXHtmlFontStyleBarDelegate> delegate;

@property (nonatomic, strong) UIButton *boldItem;
@property (nonatomic, strong) UIButton *underlineItem;
@property (nonatomic, strong) UIButton *italicItem;
@property (nonatomic, strong) UIButton *justifyLeftItem;
@property (nonatomic, strong) UIButton *justifyCenterItem;
@property (nonatomic, strong) UIButton *justifyRightItem;
@property (nonatomic, strong) UIButton *indentItem;
@property (nonatomic, strong) UIButton *outdentItem;
@property (nonatomic, strong) UIButton *unorderlistItem;
@property (nonatomic, strong) UIButton *heading1Item;
@property (nonatomic, strong) UIButton *heading2Item;
@property (nonatomic, strong) UIButton *heading3Item;

- (void)updateFontBarWithButtonName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
