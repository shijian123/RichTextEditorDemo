//
//  YXHtmlEditBaseController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "YXHtmlEditBaseController.h"
#import "YXHtmlCommon.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WKWebView+YXHideAccessoryView.h"
#import "YXHtmlEditHeaderView.h"
#import "TZImagePickerController.h"
#import "YXShowHTMLController.h"
#import <IQKeyboardManager.h>

#define YXHtmlEditorURL @"richText_editor"
#define YXEditHeaderViewH 100
@interface YXHtmlEditBaseController ()<UITextViewDelegate, WKNavigationDelegate,WKUIDelegate,
YXHtmlEditorBarDelegate, YXHtmlFontStyleBarDelegate,
UIAlertViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YXWKWebView *myWebView;
@property (nonatomic, strong) YXHtmlEditHeaderView *headerView;
@property (nonatomic, copy) NSString *tempArticleID;
@property (nonatomic, copy) NSString *tempTitle;
@property (nonatomic, copy) NSString *tempContent;
@property (nonatomic, assign) BOOL isExitView;

@property (nonatomic, assign) BOOL isLoadFinsh;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) YXHtmlEditorBar *toolBarView;
@property (nonatomic, strong) YXHtmlFontStyleBar *fontBar;

@property (nonatomic,strong) TZImagePickerController *imagePickerVc;

@property (nonatomic, assign) BOOL showHtml;
/// 键盘高度
//@property (nonatomic, assign) CGFloat keyboardHeight;
/// 存放所有正在上传及失败的图片model
@property (nonatomic, strong) NSMutableArray *uploadPics;
@property (nonatomic, strong) YXEmojiInputView *emojiKeyboard;

@end

@implementation YXHtmlEditBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文章编辑";
    self.view.backgroundColor = [UIColor whiteColor];
    /// config
    [self.view addSubview:self.myWebView];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [self.view addSubview:self.toolBarView];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardWillShowFrame:)
     name:UIKeyboardWillShowNotification
     object:nil];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(keyBoardWillChangeFrame:)
//     name:UIKeyboardWillChangeFrameNotification
//     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyBoardWillHideFrame:)
     name:UIKeyboardWillHideNotification
     object:nil];
        
//    [self.toolBarView
//     addObserver:self
//     forKeyPath:@"transform"
//     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//     context:nil];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(exportHTMLTextMethod)];
    
    [self makeHeaderView];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.myWebView.frame = CGRectMake(0, SCREEN_Nav_H, SCREEN_WIDTH,
                                    SCREEN_HEIGHT - SCREEN_Nav_H - SCREEN_B_0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    WS(weakSelf)
    [self.myWebView contentTextHandler:^(id _Nonnull htmlStr){
        if (weakSelf.onChangeContentBlock) {
            weakSelf.onChangeContentBlock(htmlStr);
        }
    }];
    
    //退出时保存
//    NSString *htmlStr = [self.myWebView contentHtmlText];
//    WS(weakSelf)
//    if (weakSelf.onChangeContentBlock) {
//        weakSelf.onChangeContentBlock(htmlStr);
//    }
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        [YSUserDefaultsModel saveObject:htmlStr
    //        Key:CreateOrEditArticleContent];
    //    });
}

#pragma mark - Method

/// 添加自定义headerView
- (void)makeHeaderView {
    self.headerView = [[YXHtmlEditHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, YXEditHeaderViewH)];
    self.headerView.selectTagsBlock = ^{
        [MBProgressHUD showText:@"选择标签"];
    };
    self.myWebView.headerView = self.headerView;
}

/// 导出html
- (void)exportHTMLTextMethod {
    
    WS(weakSelf)
    [self.myWebView contentHtmlTextHandler:^(id _Nonnull textStr) {
        __block NSString *htmlStr = [NSString stringWithString:textStr];
        //过滤掉无效视图
        NSString *divReg = @"<div[^>]*>.*?</div>";
        NSArray *divArray = [YXHtmlEditTool matchString:htmlStr toRegexString:divReg];
        if (divArray.count > 0) {
            [divArray enumerateObjectsUsingBlock:^(
                                                   NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.length > 0 && [obj containsString:@"class=\"real-img-f-div\""]) {
                    NSString *imgReg = @"<img[^>]*>";
                    NSArray *imgArray = [YXHtmlEditTool matchString:obj toRegexString:imgReg];
                    [imgArray
                     enumerateObjectsUsingBlock:^(NSString *_Nonnull obj2,
                                                  NSUInteger idx, BOOL *_Nonnull stop) {
                         if (obj2.length > 0 &&
                             (![obj2 containsString:@"class=\"real-img-delete\""])) {
                             //删除id
                             NSString *imgIDReg = @"id=\".*?\"";
                             NSString *imgStr = [YXHtmlEditTool matchReplaceHtmlString:obj2
                                                                 RegexString:imgIDReg
                                                                  withString:@""];
                             htmlStr = [htmlStr stringByReplacingOccurrencesOfString:obj
                                                                          withString:imgStr];
                         }
                     }];
                }else if(obj.length > 0 && [obj containsString:@"class=\"real-video-f-div\""]){
                    NSString *imgReg = @"<img[^>]*>";
                    NSArray *imgArray = [YXHtmlEditTool matchString:obj toRegexString:imgReg];
                    [imgArray
                     enumerateObjectsUsingBlock:^(NSString *_Nonnull obj2,
                                                  NSUInteger idx, BOOL *_Nonnull stop) {
                        htmlStr = [htmlStr stringByReplacingOccurrencesOfString:obj2
                                                                     withString:@""];
                     }];
                }
            }];
        }
//        NSString *localImgReg = @"<img[^>]*>";
//        NSArray *imgArr = [YXHtmlEditTool matchString:htmlStr toRegexString:localImgReg];
//        [imgArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj containsString:@"localEmojiImage"]) {
//                NSArray *arr = [obj componentsSeparatedByString:@"alt="];
//                if (arr.count > 1) {
//                    NSArray *arr1 = [arr[1] componentsSeparatedByString:@"\""];
//                    NSString *altStr = arr1[1];
//                    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:obj
//                                                                 withString:altStr];
//                }
//            }
            /**
             <img id="localImage" height="30" width="30" alt="[/酷]" src="file:///Users/zhangchaoyang/Library/Developer/CoreSimulator/Devices/9120F1F7-247D-4C30-86D4-3CC6038BDF0C/data/Containers/Bundle/Application/F8C4510C-4D96-4D99-9632-30B8C8142B09/RichTextEditorDemo.app/EmojiPackage.bundle/Item01/013.png" style="-webkit-text-size-adjust: 100%;">
             */
//        }];
        //导出结果
        NSLog(@"%@", htmlStr);
        YXShowHTMLController *vc = [[YXShowHTMLController alloc] init];
        vc.title = @"贴子详情";
        vc.htmlStr = [NSString stringWithFormat:@"<h1 align='center'>%@</h1>%@",self.headerView.titleTF.text, htmlStr];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

/// 随机图片
- (NSString *)imgUrlarc4random {
    NSArray *urlArr = @[
        @"http://pic.netbian.com/uploads/allimg/201022/223306-16033771862a23.jpg",
        @"http://pic.netbian.com/uploads/allimg/201005/233421-16019120612203.jpg",
        @"http://pic.netbian.com/uploads/allimg/200928/232118-1601306478450d.jpg",
        @"http://pic.netbian.com/uploads/allimg/200207/202346-158107822608d3.jpg",
        @"http://pic.netbian.com/uploads/allimg/190403/205325-1554296005906a.jpg"];
    
    return urlArr[arc4random()%5];
}

/// 添加适配
- (void)addVideoMethod {
#warning 添加默认视频
    [self.myWebView insertSuccessVideoKey:[NSString uuid] videoUrl:@"https://player.bilibili.com/player.html?aid=585228306&bvid=BV1cz4y1y7a6"];
}

- (NSDictionary *)makeDictionaryWithResultURL:(NSString *)urlString preStr:(NSString *)preStr {
    NSString *result =
    [urlString stringByReplacingOccurrencesOfString:preStr withString:@" "];
//    NSString *jsonString = [result
//                            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonString = [result stringByRemovingPercentEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                    options:NSJSONReadingMutableContainers
                                      error:&err];
    return dict;
}

#pragma mark 键盘监听

- (void)keyBoardWillShowFrame:(NSNotification *)notification {
    [YXUserDefaults setBool:YES forKey:@"YXKeyboardIsVisible"];
}

- (void)keyBoardWillHideFrame:(NSNotification *)notification {
    self.myWebView.accessoryView.fontBtn.selected = NO;
    self.fontBar.hidden = YES;
    
    [YXUserDefaults setBool:NO forKey:@"YXKeyboardIsVisible"];
}

//- (void)keyBoardWillChangeFrame:(NSNotification *)notification {
//    CGRect frame =
//    [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (self.keyboardHeight < 10) {
//        self.keyboardHeight = frame.size.height;
//    }
//
//    CGFloat duration =
//    [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]
//     doubleValue];
//    if (frame.origin.y == SCREEN_HEIGHT) {
//        [UIView animateWithDuration:duration
//                         animations:^{
//                             self.toolBarView.transform = CGAffineTransformIdentity;
//                             self.toolBarView.keyboardBtn.selected = NO;
//                         }];
//    } else {
//        [UIView
//         animateWithDuration:duration
//         animations:^{
//             self.toolBarView.transform =
//             CGAffineTransformMakeTranslation(0, -frame.size.height);
//             self.toolBarView.keyboardBtn.selected = YES;
//
//         }];
//    }
//}

///// 添加KVO 设置fontbar的位置
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSString *, id> *)change
//                       context:(void *)context {
//    if ([keyPath isEqualToString:@"transform"]) {
//        CGRect fontBarFrame = self.fontBar.frame;
//        fontBarFrame.origin.y = CGRectGetMaxY(self.toolBarView.frame) -
//        YXFontBar_Height - YXEditorBar_Height;
//        self.fontBar.frame = fontBarFrame;
//    } else {
//        [super observeValueForKeyPath:keyPath
//                             ofObject:object
//                               change:change
//                              context:context];
//    }
//}

#pragma mark webView监听处理事件

//- (void)handleEvent:(NSString *)urlString {
//    if ([urlString hasPrefix:@"re-state-content://"]) {
////        WS(weakSelf)
////        [self.myWebView contentTextHandler:^(NSString *textStr) {
////            if (textStr.length <= 0) {
////                [weakSelf.myWebView.scrollView setContentOffset:CGPointMake(0, YXEditHeaderViewH) animated:YES];
////            }
////        }];
//    }
//
//    if ([urlString hasPrefix:@"re-state-title://"]) {
//        self.fontBar.hidden = YES;
//        self.toolBarView.hidden = YES;
//    }
//}

/**
 *  删除视频拦截
 */
- (void)handleVideoWithString:(NSString *)urlString {
    //点击的视频删除标记URL（自定义）
    NSString *preStr = @"protocol://iOS?code=uploadVideoResult&data=";
    if ([urlString hasPrefix:preStr]) {
        [self.view endEditing:YES];
        NSDictionary *dict = [self makeDictionaryWithResultURL:urlString preStr:preStr];;
        NSString *meg = [NSString stringWithFormat:@"视频的ID为%@", dict[@"videoId"]];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:meg message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.myWebView deleteVideoKey:dict[@"videoId"]];
        }];
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCon addAction:leftAction];
        [alertCon addAction:rightAction];
        [self presentViewController:alertCon animated:YES completion:nil];

    }
}

/**
 *  删除图片拦截
 */
- (BOOL)handleImageWithString:(NSString *)urlString {
    //点击的图片标记URL（自定义）
    NSString *preStr = @"protocol://iOS?code=uploadResult&data=";
    
    if ([urlString hasPrefix:preStr]) {
        [self.view endEditing:YES];
        NSDictionary *dict = [self makeDictionaryWithResultURL:urlString preStr:preStr];;
        // 点击图片暂处理
        if ([dict[@"imgId"] isEqualToString:@"YXClickImgAction"]) {
            return YES;
        }
        NSString *meg = [NSString stringWithFormat:@"上传的图片ID为%@", dict[@"imgId"]];
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:meg
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        
        //上传状态 - 默认上传成功
        BOOL uploadState = YES;
        
        for (YXHtmlUploadPictureModel *upPic in self.uploadPics) {
            if (upPic.type == YXUploadImageModelTypeError) {
                //上传失败的
                uploadState = false;
            }
        }
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:uploadState ? @"删除图片" : @"重新上传"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *_Nonnull action) {
                                 //根据自身业务需要处理图片操作：如删除、重新上传图片操作等
                                 if (uploadState) {
                                     //例如删除图片执行函数imgID=key;
                                     [self.myWebView deleteImageKey:dict[@"imgId"]];
                                 } else {
                                     //见387行代码 上传片段 。。。
                                     for (YXHtmlUploadPictureModel *uploadM in self.uploadPics) {
                                         if (uploadM.type == YXUploadImageModelTypeError) {
                                             //上传失败的
                                             //                        NSMutableDictionary *dic =
                                             //                        [[NSMutableDictionary
                                             //                        alloc]init];
                                             //                        [YSJsonDataModel
                                             //                        requestSendContentImgDic:dic
                                             //                        image:uploadM.imageData
                                             //                        Complated:^(id datas, NSString
                                             //                        *error) {
                                             //                            [HUDView dismiss];
                                             //
                                             //                            if (error) {
                                             //                                //3、上传失败
                                             //                                显示失败的样式
                                             //                                [self.myWebView
                                             //                                uploadErrorKey:uploadM.key];
                                             //                                uploadM.type =
                                             //                                WGUploadImageModelTypeError;
                                             //                                [self.uploadPics
                                             //                                addObject:uploadM];
                                             //
                                             //                                [self.myWebView
                                             //                                hiddenKeyboard];
                                             //                            } else {
                                             //                                NSString *picUrl =
                                             //                                datas;
                                             NSString *picUrl = @"http://pic27.nipic.com/20130225/"
                                             @"4746571_081826094000_2.jpg";
                                             [self.myWebView insertImageKey:uploadM.key progress:1];
                                             // BOOL error = false; //上传成功样式
                                             [self.myWebView insertSuccessImageKey:uploadM.key
                                                                         imgUrl:picUrl];
                                             uploadM.type = YXUploadImageModelTypeError;
                                             if ([self.uploadPics containsObject:uploadM]) {
                                                 [self.uploadPics removeObject:uploadM];
                                             }
                                             [self.myWebView setupEditEnable:YES];  //恢复可编辑状态
                                             //                                [self.myWebView
                                             //                                showKeyboardContent];
                                             [self.myWebView hiddenKeyboard];
                                             //                            }
                                             //                        }];
                                         }
                                     }
                                 }
                             }];
        
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"取消"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self.myWebView setupEditEnable:YES];  //恢复可编辑状态
                                     [self.myWebView hiddenKeyboard];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        [self.myWebView setupEditEnable:YES];  //恢复可编辑状态
    }
    return YES;
}

/// MARK:上传图片
- (void)showPhotoPicker{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePicker.showSelectBtn = NO;
    imagePicker.allowPickingVideo = NO;
    WS(weakSelf)
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [self.view endEditing:YES];
        
        [self.myWebView insertHTML:@"<br>"];
        for (UIImage *selImg in photos) {
            YXHtmlUploadPictureModel *fileM = [YXHtmlUploadPictureModel new];
            fileM.imageData = UIImageJPEGRepresentation(selImg,0.8f);
            fileM.key = [NSString uuid];
            [weakSelf.uploadPics addObject:fileM];
            
            // 加载本地图片
            [weakSelf.myWebView insertLocalImage:fileM.imageData key:fileM.key];
            
            // 1、网络请求本地占位图
//            [weakSelf.myWebView insertImage:fileM.imageData key:fileM.key];
            // 2、模拟网络请求上传图片 更新进度
//            [weakSelf.myWebView insertImageKey:fileM.key progress:0.5];
            //开始请求上传
            //                NSMutableDictionary *dic = [[NSMutableDictionary
            //                alloc]init];
            //                [YSJsonDataModel requestSendContentImgDic:dic
            //                image:uploadM.imageData Complated:^(id datas, NSString
            //                *error) {
            //                    [HUDView dismiss];
            //
            //                    if (error) {
            //                        //3、上传失败 显示失败的样式
            //                        [self.myWebView uploadErrorKey:uploadM.key];
            //                        uploadM.type = WGUploadImageModelTypeError;
            //                        [self.uploadPics addObject:uploadM];
            //                        [self.myWebView hiddenKeyboard];
            //                        //[self.myWebView
            //                        setupEditEnable:NO];//不可编辑状态
            //                    } else {
            //                         //上传成功
            //                        NSString *picUrl = datas;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSString *picUrl = [self imgUrlarc4random];
//                [weakSelf.myWebView insertImageKey:fileM.key progress:1];
                // BOOL error = false; //上传成功样式
//                [weakSelf.myWebView insertSuccessImageKey:fileM.key imgUrl:picUrl];
                fileM.type = YXUploadImageModelTypeError;
                if ([weakSelf.uploadPics containsObject:fileM]) {
                    [weakSelf.uploadPics removeObject:fileM];
                }
                [weakSelf.myWebView setupEditEnable:YES];  //恢复可编辑状态
            });
            
        }
        
        // 添加图片后滑动到底部
        WS(weakSelf)
        [self.myWebView getCaretYPositionHandler:^(NSString *numStr) {
            CGFloat num = [numStr floatValue];
            [weakSelf.myWebView autoScrollTop:num];
        }];
    }];
         
    [self presentViewController:imagePicker animated:YES completion:nil];
}



- (void)dealloc {
    NSLog(@"dealloc");
    @try {
        [self.toolBarView removeObserver:self forKeyPath:@"transform"];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        // Added to show finally works as well
    }
    self.timer = nil;
}

#pragma mark - Delegate

#pragma mark webView代理

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSLog(@"loadURL = %@", urlString);
    
//    [self handleEvent:urlString];
    
    if ([urlString rangeOfString:@"re-state-content://"].location != NSNotFound) {
        NSString *className =
        [urlString stringByReplacingOccurrencesOfString:@"re-state-content://"
                                             withString:@""];
        
        [self.fontBar updateFontBarWithButtonName:className];
        
        WS(weakSelf)
        [self.myWebView contentTextHandler:^(NSString *str) {
            if (str.length <= 0) {
                [weakSelf.myWebView showContentPlaceholder];
                [self.myWebView contentHtmlTextHandler:^(NSString *htmlStr) {
                    if ([YXHtmlEditTool getImgTags:htmlStr].count > 0) {
                        [weakSelf.myWebView clearContentPlaceholder];
                    }
                }];
            } else {
                [weakSelf.myWebView clearContentPlaceholder];
            }
        }];
                
        if ([[className componentsSeparatedByString:@","]
             containsObject:@"unorderedList"]) {
            [self.myWebView clearContentPlaceholder];
        }
        [self.myWebView setupEditEnable:YES];  //恢复可编辑状态

        decisionHandler(WKNavigationActionPolicyCancel);

    }else if ([urlString rangeOfString:@"protocol://iOS?code=uploadResult"].location != NSNotFound){
        [self handleImageWithString:urlString];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if([urlString rangeOfString:@"protocol://iOS?code=uploadVideoResult"].location != NSNotFound){// 删除视频
        [self handleVideoWithString:urlString];
        decisionHandler(WKNavigationActionPolicyCancel);

    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.myWebView setupHeaderViewForWebView:(YXWKWebView *)webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
    // 设置WKWebview的header和footer
    [self.myWebView setupFooterViewForWebView:(YXWKWebView *)webView];

    //修改占位符
    [self.myWebView changePlaceholder:@"请输入内容"];
    
    WS(weakSelf)
    [webView evaluateJavaScript:@"contentUpdateCallback" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//        [weakSelf.myWebView getCaretYPositionHandler:^(NSString *numStr) {
//            CGFloat num = [numStr floatValue];
//            [weakSelf.myWebView autoScrollTop:num - [weakSelf editKeyboardHeight]];
//        }];
    }];
    [webView evaluateJavaScript:@"document.getElementById('article_content')."
     @"addEventListener('input', contentUpdateCallback, "
     @"false);" completionHandler:nil];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"******************* NSError = %@", error);
    
    if ([error code] == NSURLErrorCancelled) {
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= -YXEditHeaderViewH) {
        scrollView.contentOffset = CGPointMake(0, -YXEditHeaderViewH);
    }
}

#pragma mark - 编辑bar的Delegate

- (void)editorBar:(YXHtmlEditorBar *)editorBar
    didClickIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            // 隐藏键盘
            [self.view endEditing:YES];
        } break;
        case 1: {// 添加视频
            [self addVideoMethod];

        } break;
        case 2: {// 添加emoji
#warning 添加表情
            if (self.myWebView.showEmojiKeyboard) {
                self.myWebView.showEmojiKeyboard = NO;
                [editorBar.emojiBtn setImage:[UIImage imageNamed:@"btn_chat_input_emoji"] forState:UIControlStateNormal];

            }else {
                self.myWebView.showEmojiKeyboard = YES;
                [editorBar.emojiBtn setImage:[UIImage imageNamed:@"btn_chat_input_keyborad"] forState:UIControlStateNormal];
            }
//            UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//            UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//            [firstResponder reloadInputViews];
            // WKContentView
            [self.myWebView.subviews[0].subviews[0] reloadInputViews];

        } break;
        case 3: {
            //显示更多区域
            editorBar.fontBtn.selected = !editorBar.fontBtn.selected;
            if (editorBar.fontBtn.selected) {
                CGRect barframe = [editorBar convertRect:editorBar.frame toView:self.view];
                self.fontBar.frame = CGRectMake(barframe.origin.x, barframe.origin.y-self.fontBar.height, barframe.size.width, self.fontBar.height);
                self.fontBar.hidden = NO;
            } else {
                self.fontBar.hidden = YES;
            }
        } break;
        case 4: {//超链接
            [self hyperLink];            

        } break;
        case 5: {
            
            //插入图片
            if (!self.toolBarView.keyboardBtn.selected) {
                [self.myWebView showKeyboardContent];
                dispatch_after(
                               dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                    [self showPhotoPicker];

                               });
            } else {
                [self showPhotoPicker];
            }
        } break;
        default:
            break;
    }
}

/**
 * 插入超链接
 */
- (void)hyperLink {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加链接" message:@"请输入链接名称和地址" preferredStyle:UIAlertControllerStyleAlert];
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入名称";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"链接地址:http";
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTextField = alertController.textFields.firstObject;
        UITextField *addrTextField = alertController.textFields.lastObject;
        if (nameTextField.text.length > 0 && addrTextField.text.length > 0) {
            [self.myWebView insertLinkUrl:addrTextField.text title:nameTextField.text content:nameTextField.text];
            [self.myWebView showKeyboardContent];
        } else {
            //输入信息不全
        }
        
    }]];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 字体bar的delegate

- (void)fontBar:(YXHtmlFontStyleBar *)fontBar didClickBtn:(UIButton *)button {
    if (self.toolBarView.transform.ty >= 0) {
        [self.myWebView showKeyboardContent];
    }
    switch (button.tag) {
        case 0: {
            //粗体
            [self.myWebView bold];
        } break;
        case 1: {  //下划线
            [self.myWebView underline];
        } break;
        case 2: {  //斜体
            [self.myWebView italic];
        } break;
        case 3: {  // 14号字体
            [self.myWebView setFontSize:@"2"];
        } break;
        case 4: {  // 16号字体
            [self.myWebView setFontSize:@"3"];
        } break;
        case 5: {  // 18号字体
            [self.myWebView setFontSize:@"4"];
        } break;
        case 6: {  //左对齐
            [self.myWebView justifyLeft];
        } break;
        case 7: {  //居中对齐
            [self.myWebView justifyCenter];
        } break;
        case 8: {  //右对齐
            [self.myWebView justifyRight];
        } break;
        case 9: {  //无序
            [self.myWebView unorderlist];
        } break;
        case 10: {
            //缩进
            button.selected = !button.selected;
            if (button.selected) {
                [self.myWebView indent];
            } else {
                [self.myWebView outdent];
            }
        } break;
        case 11: {
        } break;
        default:
            break;
    }
}

- (void)fontBarResetNormalFontSize {
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self.myWebView normalFontSize];
                   });
}

#pragma mark - setter&&getter

- (NSMutableArray *)uploadPics {
    if (!_uploadPics) {
        _uploadPics = [NSMutableArray array];
    }
    return _uploadPics;
}

- (YXHtmlEditorBar *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[NSBundle mainBundle] loadNibNamed:@"YXHtmlEditorBar" owner:self options:nil][0];
        _toolBarView.frame =
        CGRectMake(0, SCREEN_HEIGHT - YXEditorBar_Height,
                   self.view.frame.size.width, YXEditorBar_Height);
        _toolBarView.backgroundColor = COLOR(237, 237, 237, 1);
        _toolBarView.hidden = YES;
    }
    return _toolBarView;
}

- (YXHtmlFontStyleBar *)fontBar {
    if (!_fontBar) {
        _fontBar = [[YXHtmlFontStyleBar alloc]
                    initWithFrame:CGRectMake(0, 0,
                                             self.view.frame.size.width, YXFontBar_Height)];
        _fontBar.delegate = self;
        _fontBar.hidden = YES;
        [_fontBar.heading2Item setSelected:YES];
        [self.view addSubview:_fontBar];
    }
    return _fontBar;
}

- (YXWKWebView *)myWebView {
    if (!_myWebView) {
        //获取已经初始化完成的webView
        _myWebView = [YXWKWebViewPool sharedInstance].webView;
        _myWebView.UIDelegate = self;
        _myWebView.navigationDelegate = self;
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:YXHtmlEditorURL ofType:@"html"];
        NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
        _myWebView.scrollView.alwaysBounceVertical = YES;
        _myWebView.accessoryView.delegate = self;
//        [_myWebView.accessoryView
//         addObserver:self
//         forKeyPath:@"transform"
//         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//         context:nil];
        _myWebView.scrollView.delegate = self;

        
    }
    return _myWebView;
}


@end

