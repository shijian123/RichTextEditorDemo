//
//  YXImageEditCell.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXImageEditCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (nonatomic) void(^deleteImgBlock)(NSInteger indexRow);

@end

NS_ASSUME_NONNULL_END
