//
//  YXHtmlEditBaseController.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <UIKit/UIKit.h>
#import "YXWKWebViewPool.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//距离顶部导航高度
#define SCREEN_Y (IS_IPhoneX ? 88 : 64)
//距离顶部高度0
#define SCREEN_Top_Y (IS_IPhoneX ? 24 : 0)
//状态栏高度
#define SCREEN_Bar_H (IS_IPhoneX ? 44 : 20)
//导航高度
#define SCREEN_Nav_H (IS_IPhoneX ? 88 : 64)
//约束距离底部高度值
#define SCREEN_B_Y (IS_IPhoneX ? -83 : -49)
//底部高度
#define SCREEN_B_H (IS_IPhoneX ? 83 : 49)

//距离顶部导航高度
#define DISCOVER_TOPBAR (IS_IPhoneX ? 114 : 86)
//键盘高度
#define SCREEN_keyboard_H (IS_IPhoneX ? 334 : 300)
#define PlusSizeX SCREEN_WIDTH/375/2
//颜色RGB
#define COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define WST(strongWSelf)  __strong __typeof(&*self)strongWSelf = weakSelf;


NS_ASSUME_NONNULL_BEGIN

@interface YXHtmlEditBaseController : UIViewController
//回调
@property(nonatomic,strong)void (^onChangeContentBlock)(NSString *);

@end

NS_ASSUME_NONNULL_END
