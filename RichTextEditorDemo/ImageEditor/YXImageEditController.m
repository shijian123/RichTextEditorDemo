//
//  YXImageEditController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/24.
//

#import "YXImageEditController.h"
#import "YXHtmlEditHeaderView.h"
#import "YXImageEditCell.h"
#import "TZImagePickerController.h"
#import "UITextView+YX.h"

#define WordsLimitNum 500
#define MAXIMAGENUM 21

@interface YXImageEditController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollV;
@property (weak, nonatomic) IBOutlet YXHtmlEditHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (weak, nonatomic) IBOutlet UILabel *editNumLab;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *assetsArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollViewH;
/// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic) NSInteger imgItemH;

@end

@implementation YXImageEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图片贴子";
    [self.imageCollView registerNib:[UINib nibWithNibName:@"YXImageEditCell" bundle:nil] forCellWithReuseIdentifier:@"YXImageEditCellID"];
    self.imgItemH = (MainScreenWidth-40)/3.0;
    self.imageCollViewH.constant = self.imgItemH+20;
    
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.imageCollView addGestureRecognizer:self.longPress];
    
}

- (void)selectImageMethod {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:MAXIMAGENUM delegate:nil];

    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.selectedAssets = _assetsArr;
    imagePickerVC.showSelectedIndex = YES;

    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.imgArr = [NSMutableArray arrayWithArray:photos];
        self.assetsArr = [NSMutableArray arrayWithArray:assets];
        [self.imageCollView reloadData];
        if (self.imgArr.count >= MAXIMAGENUM) {
            self.imageCollViewH.constant = ceil(MAXIMAGENUM/3.0)*(self.imgItemH+10)+10;
        }else {
            self.imageCollViewH.constant = ceil((self.imgArr.count+1)/3.0)*(self.imgItemH+10)+10;
        }
    }];
    
    imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)lookImageAtIndexPath:(NSIndexPath *)indexPath {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithSelectedAssets:_assetsArr selectedPhotos:_imgArr index:indexPath.item];
    imagePickerVC.maxImagesCount = MAXIMAGENUM;
    imagePickerVC.showSelectedIndex = YES;
    imagePickerVC.allowPickingVideo = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.imgArr = [NSMutableArray arrayWithArray:photos];
        self.assetsArr = [NSMutableArray arrayWithArray:assets];
        [self.imageCollView reloadData];

    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark longPressGesture

- (void)longPressGestureRecognized:(id)sender{
    
    UILongPressGestureRecognizer *longGesture = (UILongPressGestureRecognizer *)sender;
    
    CGPoint location;
    CGPoint locatitonInView;
    NSIndexPath *indexPath;
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    YXImageEditCell *cell = nil;

    location = [longGesture locationInView:self.imageCollView];
    indexPath = [self.imageCollView indexPathForItemAtPoint:location];
    cell= (YXImageEditCell*)[self.imageCollView cellForItemAtIndexPath:indexPath];
        
    locatitonInView = [longGesture locationInView:self.mainScrollV];
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {
                if (indexPath.item == self.imgArr.count && self.imgArr.count != MAXIMAGENUM) {
                    break;
                }else {
                    snapshot = [self customSnapshoFromView:cell.imgView];
                    // 保存之前的indexpath
                    sourceIndexPath = indexPath;

                    snapshot.center = locatitonInView;
                    [self.mainScrollV addSubview:snapshot];
                    [self.mainScrollV bringSubviewToFront:snapshot];
                    [UIView animateWithDuration:0.3 animations:^{
                        snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    }];
                    cell.hidden = YES;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{

            if (snapshot) {
                snapshot.center = locatitonInView;
                NSIndexPath *targetIndexPath = [self getIndexPathWithPoint:location];
                if (targetIndexPath && ![sourceIndexPath isEqual:targetIndexPath]) {
                    //如果没有移动到一个cell上，并且有新的targetIndexpath则执行换位置的动作
                    
                    if (targetIndexPath.item == self.imgArr.count && self.imgArr.count != MAXIMAGENUM) {
                        break;
                    }else {
                        [self moveCellFromIndex:sourceIndexPath toIndex:targetIndexPath];
                        sourceIndexPath = targetIndexPath;
                        NSLog(@"sourceIndexPath %ld, targetIndexPath %ld", (long)sourceIndexPath.item, (long)targetIndexPath.item);
                    }
                } else {
                    //起始位置与终止位置相同则还原
                    [UIView animateWithDuration:0.25 animations:^{
                        snapshot.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    } completion:nil];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (snapshot) {
                if (snapshot && sourceIndexPath) {
                    YXImageEditCell *celll= (YXImageEditCell*)
                    [self.imageCollView cellForItemAtIndexPath:sourceIndexPath];
                    snapshot.center = [self.view convertPoint: celll.center
                                                        fromView: self.imageCollView];
                    [UIView animateWithDuration:0.3 animations:^{
                        snapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        celll.hidden = NO;
                        NSLog(@"显示的是%ld cell", (long)sourceIndexPath.item);
                        [snapshot removeFromSuperview];
                    }completion:^(BOOL finished) {
                        sourceIndexPath = nil;
                        snapshot = nil;
                    }];
                } else{
                    NSLog(@"bugggg");
                }
            }
            [snapshot removeFromSuperview];
            [self.imageCollView reloadData];

            break;
        }
        default:
            break;
    }
    
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:NO];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowOpacity = 0.1;
    
    return snapshot;
}

- (NSIndexPath *)getIndexPathWithPoint:(CGPoint)point{
    CGPoint targetPoint;
    CGFloat rightbianjie ;
    CGFloat pianyiliang ;
    rightbianjie = MainScreenWidth-20;
    pianyiliang = 29;
    if (point.x < rightbianjie){
        targetPoint = CGPointMake(point.x + pianyiliang, point.y);
    }else{
        targetPoint = CGPointMake(point.x - pianyiliang, point.y);
    }
        //  计算此点相邻的indexPath
    NSIndexPath *targetIndexpath = [self.imageCollView
                                    indexPathForItemAtPoint:targetPoint];
    return targetIndexpath;
}

- (void)moveCellFromIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex{

    //对数据源进行操作
    [self insertCellForIndex:fromIndex toIndex:toIndex];
    //对视图进行操作
    [self.imageCollView moveItemAtIndexPath:fromIndex toIndexPath:toIndex];
}

- (void)insertCellForIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath*)toIndex{
        
    id objectToMove = self.imgArr[fromIndex.item];
    if (objectToMove&&toIndex.item < self.imgArr.count) {
        [self.imgArr removeObjectAtIndex:fromIndex.item];
        [self.imgArr insertObject:objectToMove atIndex:toIndex.item];
    }
    
    id objectToMove2 = self.assetsArr[fromIndex.item];
    if (objectToMove2&&toIndex.item < self.assetsArr.count) {
        [self.assetsArr removeObjectAtIndex:fromIndex.item];
        [self.assetsArr insertObject:objectToMove2 atIndex:toIndex.item];
    }
}

#pragma mark - Delegate

- (void)textViewDidChange:(UITextView *)textView {
    //设置全局字符数
    NSInteger textLength = textView.text.length;
    //显示字符数字
    NSString *str = @"";
    //限制输入字数500
    if (textView.text.length > WordsLimitNum) {
        str = [NSString stringWithFormat:@"%d/%d",WordsLimitNum,WordsLimitNum];
        
        if ([textView limitTVWithLength:WordsLimitNum]==NO) {
            textLength = WordsLimitNum;
            NSString *str2 = [textView.text substringWithRange:NSMakeRange(0, WordsLimitNum)];
            textView.text = str2;
        }
    }else {
        str = [NSString stringWithFormat:@"%02ld/%d", textLength,WordsLimitNum];
    }
    if (textLength > 0) {
        self.placeholderLab.hidden = YES;
        self.editNumLab.text = str;
    }else {
        self.placeholderLab.hidden = NO;
        self.editNumLab.text = [NSString stringWithFormat:@"0/%d",WordsLimitNum];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXImageEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXImageEditCellID" forIndexPath:indexPath];
    if (indexPath.item == self.imgArr.count && self.imgArr.count != MAXIMAGENUM) {
        cell.imgView.image = [UIImage imageNamed:@"tiezi_add_pic"];
        cell.coverView.hidden = YES;
        cell.deleBtn.hidden = YES;
    }else {
        if (indexPath.item == 0) {
            cell.coverView.hidden = NO;
        }else {
            cell.coverView.hidden = YES;
        }
        cell.imgView.image = self.imgArr[indexPath.item];
        cell.deleBtn.hidden = NO;
    }
    cell.imgView.tag = 100+indexPath.item;
#warning 长按后刷新异常
    cell.coverView.hidden = YES;

    cell.deleteImgBlock = ^(NSInteger indexRow) {
        [self.imgArr removeObjectAtIndex:indexRow];
        [self.assetsArr removeObjectAtIndex:indexRow];
        [self.imageCollView reloadData];
    };
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imgArr.count >= MAXIMAGENUM) {
        return MAXIMAGENUM;
    }else {
        return self.imgArr.count+1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size =CGSizeMake(self.imgItemH, self.imgItemH);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imgArr.count && self.imgArr.count != MAXIMAGENUM) {
        [self selectImageMethod];
    }else {
        [self lookImageAtIndexPath:indexPath];
    }
}

#pragma mark - setter&&getter

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
