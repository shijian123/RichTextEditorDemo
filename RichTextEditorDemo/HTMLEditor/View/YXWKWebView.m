//
//  YXWKWebView.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "YXWKWebView.h"

@interface YXWKWebView ()<WKNavigationDelegate>{
    BOOL alreadyShowHeader;
}
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) YXEmojiInputView *emojiInputView;

@end

@implementation YXWKWebView

#pragma mark - 设置UI

- (void)setupHeaderViewForWebView:(WKWebView *)webView {
    if (_headerView) {
        if (alreadyShowHeader) {
            return;
        }else {
            alreadyShowHeader = YES;
        }
        UIEdgeInsets insets = UIEdgeInsetsZero;
        insets.top = _headerView.bounds.size.height;
        webView.scrollView.contentInset = insets;
        
        CGRect frame = _headerView.frame;
        frame.origin.y = -_headerView.bounds.size.height;
        _headerView.frame = frame;
        
        webView.scrollView.contentOffset = CGPointMake(0, -_headerView.bounds.size.height);
    }
}

- (void)setupFooterViewForWebView:(WKWebView *)webView {
    if (_headerView) [webView.scrollView addSubview:_headerView];
    if (_footerView) {
        __weak typeof(self) weakSelf = self;
        //延时1s操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf)  return;
            
            CGFloat footerViewHeight = strongSelf.footerView.bounds.size.height;
            NSString *js = [NSString stringWithFormat:@"\
                            var appendDiv = document.getElementById(\"AppAppendDIV\");\
                            if (appendDiv) {\
                            appendDiv.style.height = %@+\"px\";\
                            } else {\
                            var appendDiv = document.createElement(\"div\");\
                            appendDiv.setAttribute(\"id\",\"AppAppendDIV\");\
                            appendDiv.style.width=%@+\"px\";\
                            appendDiv.style.height=%@+\"px\";\
                            document.body.appendChild(appendDiv);\
                            }\
                            ", @(footerViewHeight),
                            @(webView.scrollView.contentSize.width),
                            @(footerViewHeight)];
            
            //调用js代码多留一块footerView高度的空白
            [webView evaluateJavaScript:js completionHandler:^(id _Nullable result,
                                                               NSError * _Nullable error) {
                //获取页面高度，并添加footerView
                [webView evaluateJavaScript:@"document.body.offsetHeight"
                          completionHandler:^(id _Nullable result,
                                              NSError * _Nullable error) {
                              
                              CGFloat webViewHeight = [result floatValue];
                              CGRect rect = strongSelf.footerView.frame;
                              rect.origin.y = webViewHeight - footerViewHeight;
                              strongSelf.footerView.frame = rect;
                              
                              [webView.scrollView addSubview:strongSelf.footerView];
                }];
            }];
        });
    }
}

- (__kindof UIView *)inputAccessoryView {
    return self.accessoryView;
}

- (__kindof UIView *)inputView{
    if (self.showEmojiKeyboard) {
        return self.emojiInputView;
    }else {
        return nil;
    }
}

- (YXHtmlEditorBar *)accessoryView {
    if (_accessoryView == nil) {
        _accessoryView = [[NSBundle mainBundle] loadNibNamed:@"YXHtmlEditorBar" owner:self options:nil].firstObject;
    }
    return _accessoryView;
}

- (YXEmojiInputView *)emojiInputView {
    if (_emojiInputView == nil) {
        _emojiInputView = [[YXEmojiInputView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 230)];
    }
    return _emojiInputView;
}

@end
