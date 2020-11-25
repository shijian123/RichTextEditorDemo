//
//  YXEmojiContentView.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXEmojiContentView.h"
#import "YXEmojiViewCell.h"

@interface YXEmojiContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *emojiCollView;
@property (weak, nonatomic) IBOutlet UIPageControl *emojiPageCont;
@property (nonatomic, strong) NSArray<YXEmojiItemModel *> *emojis;

@end

@implementation YXEmojiContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _emojiCollView.delegate = self;
    _emojiCollView.dataSource = self;
    [_emojiCollView registerNib:[UINib nibWithNibName:@"YXEmojiViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXEmojiViewCellID"];
    NSInteger num = [YXEmojiDataManager manager].currentPackage;
    _emojis = [NSArray arrayWithArray:[YXEmojiDataManager manager].emojiPackages[num].emojis];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXEmojiViewCellID" forIndexPath:indexPath];
    YXEmojiItemModel *model = self.emojis[indexPath.row];
    cell.itemImgV.image = model.image;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emojis.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.width/5.0, self.width/5.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YXEmojiItemModel *model = self.emojis[indexPath.row];
    // 点击展示表情包内容
    if (self.clickEmojiItemBlock) {
        self.clickEmojiItemBlock(model);
    }
}

@end
