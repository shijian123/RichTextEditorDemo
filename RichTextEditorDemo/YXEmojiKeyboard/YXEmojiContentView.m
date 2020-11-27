//
//  YXEmojiContentView.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import "YXEmojiContentView.h"
#import "YXEmojiViewCell.h"

@interface YXEmojiContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *emojiScrollView;
@property (strong, nonatomic) UIPageControl *emojiPageCont;
@property (nonatomic, strong) NSMutableArray *pageEmojis;
@property (nonatomic, strong) YXEmojiGroupModel *groupModel;
// 小表情行数
@property (nonatomic, assign) NSInteger smallEmojiLineCount;
// 小表情列数
@property (nonatomic, assign) NSInteger smallEmojiColumnCount;
// 大表情行数
@property (nonatomic, assign) NSInteger largeEmojiLineCount;
// 大表情列数
@property (nonatomic, assign) NSInteger largeEmojiColumnCount;

@end

@implementation YXEmojiContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.emojiScrollView];
        [self addSubview:self.emojiPageCont];
        self.smallEmojiLineCount = 3;
        self.smallEmojiColumnCount = 7;
        self.largeEmojiLineCount = 2;
        self.largeEmojiColumnCount = 4;
        [self reloadContentView];
    }
    return self;
}

- (void)reloadContentView {
    
    for (UIView *view in self.emojiScrollView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger num = [YXEmojiDataManager manager].currentPackage;
     _groupModel = [YXEmojiDataManager manager].emojiPackages[num];
    
    NSInteger pageNum;
    NSInteger pageSize;
    if (_groupModel.isLargeEmoji) {// 大表情
        pageSize = (self.largeEmojiLineCount*self.largeEmojiColumnCount);
        pageNum = ceil(_groupModel.emojis.count/pageSize);
    }else {// 小表情
        pageSize = (self.smallEmojiLineCount*self.smallEmojiColumnCount);
        pageNum = ceil(_groupModel.emojis.count/pageSize);
    }
    self.emojiScrollView.contentSize = CGSizeMake(self.width*pageNum, self.emojiScrollView.height);
    _pageEmojis = [NSMutableArray array];
    for (int a = 0; a<pageNum; a++) {
        UICollectionView *view = [self creatCollectionViewFrame:CGRectMake(a*self.emojiScrollView.width, 0, self.emojiScrollView.width, self.emojiScrollView.height)];
        view.tag = 100+a;
        [self.emojiScrollView addSubview:view];
        NSArray *arr = [_groupModel.emojis subarrayWithRange:NSMakeRange(a*pageSize, pageSize)];
        [_pageEmojis addObject:arr];
    }
    
    self.emojiPageCont.numberOfPages = pageNum;
    self.emojiPageCont.currentPage = 0;
    [self.emojiScrollView setContentOffset:CGPointMake(0, 0)];
}

- (UICollectionView *)creatCollectionViewFrame:(CGRect)frame {
    NSInteger lineNum;
    NSInteger columnNum;
    if (_groupModel.isLargeEmoji) {// 大表情
        lineNum = self.largeEmojiLineCount;
        columnNum = self.largeEmojiColumnCount;
    }else {// 小表情
        lineNum = self.smallEmojiLineCount;
        columnNum = self.smallEmojiColumnCount;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(floorf((frame.size.width-(columnNum+1)*10)/columnNum), floorf((frame.size.height-(lineNum-1)*10-10)/lineNum));
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    view.scrollEnabled = NO;
    view.delegate = self;
    view.dataSource = self;
    view.backgroundColor = [UIColor clearColor];
    [view registerNib:[UINib nibWithNibName:@"YXEmojiViewCell" bundle:nil] forCellWithReuseIdentifier:@"YXEmojiViewCellID"];
    return view;
}

#pragma mark - Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/self.width;
    self.emojiPageCont.currentPage = page;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXEmojiViewCellID" forIndexPath:indexPath];
    NSArray *arr = self.pageEmojis[collectionView.tag-100];
    YXEmojiItemModel *model = arr[indexPath.row];
    if (model.gifImage) {
        cell.itemImgV.image = model.gifImage;
    }else {
        cell.itemImgV.image = model.image;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = self.pageEmojis[collectionView.tag-100];
    return arr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.pageEmojis[collectionView.tag-100];

    YXEmojiItemModel *model = arr[indexPath.row];
    // 点击展示表情包内容
    if (self.clickEmojiItemBlock) {
        self.clickEmojiItemBlock(model);
    }
}

- (UIScrollView *)emojiScrollView {
    if (_emojiScrollView == nil) {
        _emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-40)];
        _emojiScrollView.delegate = self;
        _emojiScrollView.showsHorizontalScrollIndicator = NO;
        _emojiScrollView.backgroundColor = [UIColor clearColor];
        _emojiScrollView.pagingEnabled = YES;
    }
    return _emojiScrollView;
}

- (UIPageControl *)emojiPageCont {
    if (_emojiPageCont == nil) {
        _emojiPageCont = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height-40, self.width, 35)];
    }
    return _emojiPageCont;
}

@end
