//
//  YXHtmlEditHeaderView.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "YXHtmlEditHeaderView.h"

#define YXMAXWOEDNUM 30

@interface YXHtmlEditHeaderView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *numLab;

@end

@implementation YXHtmlEditHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Method

- (void)setupViews {
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, tagView.height)];
    titleLab.text = @"发布到：";
    titleLab.textColor = DefaultTextBlackColor;
    [tagView addSubview:titleLab];
    
    UIImageView *lineV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, tagView.width, 0.5)];
    lineV.backgroundColor = DefaultLineGrayColor;
    [tagView addSubview:lineV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = tagView.bounds;
    [btn addTarget:self action:@selector(selectTagsMethod) forControlEvents:UIControlEventTouchUpInside];
    [tagView addSubview:btn];
    [self addSubview:tagView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tagView.frame), self.width, 50)];
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, titleView.width-100, titleView.height)];
    _titleTF.delegate = self;
    _titleTF.placeholder = @"标题（必填）";
    [titleView addSubview:_titleTF];
    
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake(titleView.width-70, 0, 50, titleView.height)];
    _numLab.font = [UIFont systemFontOfSize:14];
    _numLab.textAlignment = NSTextAlignmentRight;
    _numLab.text = [NSString stringWithFormat:@"0/%d", YXMAXWOEDNUM];
    _numLab.textColor = DefaultTextGrayColor;
    [titleView addSubview:_numLab];
    
    UIImageView *lineV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, titleView.width, 0.5)];
    lineV1.backgroundColor = DefaultLineGrayColor;
    [titleView addSubview:lineV1];
    
    [self addSubview:titleView];
    
}

- (void)selectTagsMethod {
    if (self.selectTagsBlock) {
        self.selectTagsBlock();
    }
}

#pragma mark - delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldBeginEditing");
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldEndEditing");
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length + string.length > YXMAXWOEDNUM) {
        return NO;
    }else{
        return YES;
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    _numLab.text = [NSString stringWithFormat:@"%02lu/%d", (unsigned long)textField.text.length,YXMAXWOEDNUM];
}

@end
