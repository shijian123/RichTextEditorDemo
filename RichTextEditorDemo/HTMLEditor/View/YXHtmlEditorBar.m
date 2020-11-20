//
//  YXHtmlEditorBar.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "YXHtmlEditorBar.h"
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //颜色RGB

@interface YXHtmlEditorBar ()
@property (nonatomic, strong) CALayer *topline;

@end

@implementation YXHtmlEditorBar

+ (instancetype)editorBar {
    return [[NSBundle mainBundle] loadNibNamed:@"YXHtmlEditorBar" owner:self options:nil].firstObject;
}

- (CALayer *)topline {
    if (_topline) {
        CALayer *border = [CALayer layer];
        border.backgroundColor = COLOR(216,216,216,1).CGColor;
        border.frame = CGRectMake(14, 0, self.frame.size.width, 1);
    }
    return _topline;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - Action

- (IBAction)clickKeyboardAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        [self.delegate editorBar:self didClickIndex:0];
    }
}

- (IBAction)clickUndoAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        [self.delegate editorBar:self didClickIndex:1];
    }
}

- (IBAction)clickRedoAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        [self.delegate editorBar:self didClickIndex:2];
    }
}

- (IBAction)clickfontAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        
        [self.delegate editorBar:self didClickIndex:3];
    }
}

- (IBAction)clickLinkAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        [self.delegate editorBar:self didClickIndex:4];
    }
}

- (IBAction)clickImgAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editorBar:didClickIndex:)]) {
        [self.delegate editorBar:self didClickIndex:5];
    }
}

@end
