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
#define MAXIMAGENUM 20

@interface YXImageEditController ()<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet YXHtmlEditHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;
@property (weak, nonatomic) IBOutlet UILabel *editNumLab;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *assetsArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageCollViewH;

@property (nonatomic,strong) TZImagePickerController *imagePickerVC;
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
}

- (void)selectImageMethod {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAXIMAGENUM columnNumber:MAXIMAGENUM delegate:self pushPhotoPickerVc:YES];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.imgArr = [NSMutableArray arrayWithArray:photos];
        self.assetsArr = [NSMutableArray arrayWithArray:assets];
        [self.imageCollView reloadData];
        if (self.imgArr.count >= MAXIMAGENUM) {
            self.imageCollViewH.constant = ceil(MAXIMAGENUM/3.0)*(self.imgItemH+10)+10;
        }else {
            self.imageCollViewH.constant = ceil((self.imgArr.count+1)/3.0)*(self.imgItemH+10)+10;
        }
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)lookImageAtIndexPath:(NSIndexPath *)indexPath {
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithSelectedAssets:_assetsArr selectedPhotos:_imgArr index:indexPath.item];
    imagePickerVC.maxImagesCount = MAXIMAGENUM;
    imagePickerVC.showSelectedIndex = YES;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.imgArr = [NSMutableArray arrayWithArray:photos];
        self.assetsArr = [NSMutableArray arrayWithArray:assets];
        [self.imageCollView reloadData];

    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLab.hidden = YES;
    }else {
        self.placeholderLab.hidden = NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeholderLab.hidden = YES;
    }else {
        self.placeholderLab.hidden = NO;
    }
    return YES;
}

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
        cell.deleBtn.hidden = YES;
    }else {
        cell.imgView.image = self.imgArr[indexPath.row];
        cell.deleBtn.hidden = NO;
    }
    
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

- (TZImagePickerController *)imagePickerVC{
    if (_imagePickerVC == nil) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:MAXIMAGENUM delegate:nil];
        _imagePickerVC.showSelectBtn = NO;
        _imagePickerVC.allowPickingVideo = NO;
    }
    return _imagePickerVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
