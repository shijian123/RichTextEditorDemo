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
    NSString *headerStr = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
    [self.myWebView loadHTMLString:[NSString stringWithFormat:@"%@%@", headerStr, self.htmlStr] baseURL:nil];
}

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
