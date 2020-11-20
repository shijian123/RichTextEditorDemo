//
//  MBProgressHUD+YX.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "MBProgressHUD+YX.h"

@implementation MBProgressHUD (YX)

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    if (delay == 0) {
        [hud hideAnimated:YES afterDelay:1];
    }else{
        [hud hideAnimated:YES afterDelay:delay];
    }
}

+ (void)showText:(NSString *)text toView:(UIView *)view{
    [self show:text icon:nil view:view afterDelay:2];
}

+ (void)showText:(NSString *)text toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:text icon:nil view:view afterDelay:delay];
}

+ (void)showText:(NSString *)text {
    [self showText:text toView:nil];
}

@end
