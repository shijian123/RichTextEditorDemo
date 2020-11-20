//
//  YXWKWebViewPool.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YXWKWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXWKWebViewPool : NSObject
@property(nonatomic, strong) YXWKWebView *webView;
/// webView预加载
@property(nonatomic, strong) NSMutableArray *preWebArray;

+ (instancetype)sharedInstance;
/// 渲染
- (void)preLoadWebView;

@end

NS_ASSUME_NONNULL_END
