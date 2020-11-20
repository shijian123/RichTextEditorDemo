//
//  YXHtmlEditorBar.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//底部编辑栏高度
#define YXEditorBar_Height 44

@class YXHtmlEditorBar;
@protocol YXHtmlEditorBarDelegate<NSObject>
- (void)editorBar:(YXHtmlEditorBar *)editorBar didClickIndex:(NSInteger)buttonIndex;
@end

@interface YXHtmlEditorBar : UIView
@property (nonatomic,weak) id<YXHtmlEditorBarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *fontBtn;
@property (weak, nonatomic) IBOutlet UIButton *undoBtn;
@property (weak, nonatomic) IBOutlet UIButton *redoBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyboardBtn;

+ (instancetype)editorBar;

@end

NS_ASSUME_NONNULL_END
