//
//  YXImageEditCell.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/24.
//

#import "YXImageEditCell.h"

@implementation YXImageEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteImgAction:(id)sender {
    if (self.deleteImgBlock) {
        self.deleteImgBlock(self.imgView.tag-100);
    }
}

@end
