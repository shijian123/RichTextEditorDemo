//
//  YXWKWebViewPool.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "YXWKWebViewPool.h"

@implementation YXWKWebViewPool

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static YXWKWebViewPool *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[super allocWithZone:NULL] init];
  });
  return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
  return [self sharedInstance];
}

- (NSMutableArray *)preWebArray {
  if (!_preWebArray) {
    _preWebArray = @[].mutableCopy;
  }
  return _preWebArray;
}

- (void)preLoadWebView {
    _webView = [[YXWKWebView alloc] init];
}

- (YXWKWebView *)webView {
  if (!_webView) {
    _webView = [[YXWKWebView alloc] init];
    _webView.scrollView.bounces = NO;
  }
  return _webView;
}

@end
