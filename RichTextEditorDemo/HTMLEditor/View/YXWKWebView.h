//
//  YXWKWebView.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <WebKit/WebKit.h>
#import "YXHtmlEditorBar.h"
#import "YXEmojiInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWKWebView : WKWebView
@property (nonatomic, strong) YXHtmlEditorBar *accessoryView;
@property (nonatomic) BOOL showEmojiKeyboard;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

/// 在代理方法 (webView: didStartProvisionalNavigation:) 优先中调用
-(void)setupHeaderViewForWebView:(YXWKWebView *)webView;
/// 在代理方法 (webView: didFinishNavigation:) 优先中调用
-(void)setupFooterViewForWebView:(YXWKWebView *)webView;


@end

NS_ASSUME_NONNULL_END
