//
//  ViewController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/18.
//

#import "ViewController.h"
#import "YXHtmlEditBaseController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *text = [[UILabel alloc] initWithFrame:self.view.bounds];
    text.textAlignment = 1;
    text.text = @"开始编辑文章";
    [self.view addSubview:text];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //提前渲染webview
    [[YXWKWebViewPool sharedInstance] preLoadWebView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    YXHtmlEditBaseController *vc = [[YXHtmlEditBaseController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}


@end
