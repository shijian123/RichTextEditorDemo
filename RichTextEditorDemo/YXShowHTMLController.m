//
//  YXShowHTMLController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/23.
//

#import "YXShowHTMLController.h"
#import <WebKit/WebKit.h>
@interface YXShowHTMLController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation YXShowHTMLController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myWebView];
    [self.myWebView loadHTMLString:self.htmlStr baseURL:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *injectionJSString = @"document.getElementsByName(\"viewport\")[0].content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

- (WKWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _myWebView.navigationDelegate = self;
    }
    return _myWebView;
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
