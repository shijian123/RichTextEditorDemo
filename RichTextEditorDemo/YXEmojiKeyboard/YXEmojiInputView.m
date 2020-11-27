//
//  YXEmojiInputView.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXEmojiInputView.h"
#import "YXEmojiContentView.h"
#import "YXEmojiTabbar.h"

@interface YXEmojiInputView ()
@property (nonatomic, strong) YXEmojiContentView *contentView;
@property (nonatomic, strong) YXEmojiTabbar *tabbarView;

@end

@implementation YXEmojiInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self addSubview:self.tabbarView];
}

- (YXEmojiContentView *)contentView {
    if (_contentView == nil) {
        _contentView = [[YXEmojiContentView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-40-SCREEN_B_0)];
        _contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        YXWeakSelf
        _contentView.clickEmojiItemBlock = ^(YXEmojiItemModel * _Nonnull model) {
            if (weakSelf.clickEmojiItemBlock) {
                weakSelf.clickEmojiItemBlock(model);
            }
        };
    }
    return _contentView;
}

- (YXEmojiTabbar *)tabbarView {
    if (_tabbarView == nil) {
        _tabbarView = [[NSBundle mainBundle] loadNibNamed:@"YXEmojiTabbar" owner:self options:nil].firstObject;
        _tabbarView.frame = CGRectMake(0, self.height-40-SCREEN_B_0, self.width, 40);
        YXWeakSelf
        _tabbarView.clickEmojiPackageBlock = ^(NSInteger index) {
            [weakSelf.contentView reloadContentView];
        };
        
        _tabbarView.clickDeleteEmojiBlock = ^{
            if (weakSelf.clickDeleteEmojiBlock) {
                weakSelf.clickDeleteEmojiBlock();
            }
        };
    }
    return _tabbarView;
}

@end
