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

@end

NS_ASSUME_NONNULL_END
