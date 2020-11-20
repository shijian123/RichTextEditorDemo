//
//  YXWKWebView.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWKWebView : WKWebView
@property (nonatomic) UIView *_Null_unspecified headerView;
@property (nonatomic) UIView *_Null_unspecified footerView;

/// 在代理方法 (webView: didStartProvisionalNavigation:) 优先中调用
-(void)setupHeaderViewForWebView:(YXWKWebView *)webView;
/// 在代理方法 (webView: didFinishNavigation:) 优先中调用
-(void)setupFooterViewForWebView:(YXWKWebView *)webView;


@end

NS_ASSUME_NONNULL_END
