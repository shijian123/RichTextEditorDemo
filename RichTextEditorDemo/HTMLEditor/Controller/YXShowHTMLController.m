//
//  YXShowHTMLController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/23.
//

#import "YXShowHTMLController.h"
#import <WebKit/WebKit.h>

@interface YXShowHTMLController ()
@property (nonatomic, strong) WKWebView *myWebView;

@end

@implementation YXShowHTMLController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.myWebView];

    NSLog(@"self.htmlStr:%@", self.htmlStr);
    
    [self insertHtmlSting:self.htmlStr];
}

#pragma mark - Method

/// 使用本地css加载html
- (void)insertHtmlSting:(NSString *)html{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"showRichText" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[htmlCont componentsSeparatedByString:@"<body>"]];
    if (arr.count > 1) {
        [arr insertObject:[NSString stringWithFormat:@"<div id='article_content'>%@</div>", self.htmlStr] atIndex:1];
    }
    htmlCont = [arr componentsJoinedByString:@""];
    [_myWebView loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark - setter&&getter

- (WKWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
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
