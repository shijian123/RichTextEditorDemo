//
//  AppDelegate.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/18.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [self updateIQKeyboardSetting];
    
    return YES;
}

/**
 *  更新IQKeyboard设置
 */
- (void)updateIQKeyboardSetting{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldPlayInputClicks = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

@end
