//
//  ViewController.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/18.
//

#import "ViewController.h"
#import "YXHtmlEditBaseController.h"
#import "YXImageEditController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发布贴子";
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"编辑贴子" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 120, 100, 40);
    btn1.tag = 100;
    [btn1 addTarget:self action:@selector(clickBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"编辑图文" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 200, 100, 40);
    btn2.tag = 101;
    [btn2 addTarget:self action:@selector(clickBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //提前渲染webview
    [[YXWKWebViewPool sharedInstance] preLoadWebView];
}

- (void)clickBtnMethod:(UIButton *)sender {
    if (sender.tag == 100) {
        YXHtmlEditBaseController *vc = [[YXHtmlEditBaseController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        YXImageEditController *vc = [[YXImageEditController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
