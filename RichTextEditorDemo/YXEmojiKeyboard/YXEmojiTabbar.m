//
//  YXEmojiTabbar.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXEmojiTabbar.h"
#import "YXEmojiDataManager.h"
#import "YXEmojiViewCell.h"

@interface YXEmojiTabbar ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myTabbarCollV;

@end

@implementation YXEmojiTabbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _myTabbarCollV.delegate = self;
    _myTabbarCollV.dataSource = self;
    [_myTabbarCollV registerNib:[UINib nibWithNibName:@"YXEmojiViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXEmojiViewCellID"];
}
- (IBAction)deleteEmojiAction:(id)sender {
    if (self.clickDeleteEmojiBlock) {
        self.clickDeleteEmojiBlock();
    }
}

/// 获取表情包封面图片
- (NSString *)groupCoverImg:(YXEmojiGroupModel *)groupModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmojiPackage" ofType:@"bundle"];
    NSString *folderPath = [[NSBundle bundleWithPath:path] pathForResource:groupModel.folderName ofType:nil];
    NSString *coverPath = [folderPath stringByAppendingPathComponent:groupModel.cover_pic];
    return coverPath;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXEmojiViewCellID" forIndexPath:indexPath];
    YXEmojiGroupModel *model = [YXEmojiDataManager manager].emojiPackages[indexPath.row];
    cell.itemLeading.constant = model.isLargeEmoji?0:5;
    cell.itemTop.constant = model.isLargeEmoji?0:5;

    cell.itemImgV.image = [UIImage imageNamed:[self groupCoverImg:model]];
    if (indexPath.row == [YXEmojiDataManager manager].currentPackage) {
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [YXEmojiDataManager manager].emojiPackages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, self.height-5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击展示表情包内容
    if (self.clickEmojiPackageBlock) {
        [YXEmojiDataManager manager].currentPackage = indexPath.row;
        self.clickEmojiPackageBlock(indexPath.row);
        [collectionView reloadData];
    }
}

@end
