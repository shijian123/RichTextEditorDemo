//
//  YXEmojiViewCell.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "SDAnimatedImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SDAnimatedImageView *itemImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTop;

@end

NS_ASSUME_NONNULL_END
