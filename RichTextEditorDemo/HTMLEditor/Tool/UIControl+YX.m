//
//  UIControl+YX.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "UIControl+YX.h"
#import <objc/runtime.h>

@implementation UIControl (YX)

static const char* orderTagBy ="orderTagBy";
- (void)setOrderTag:(NSString *)orderTag{
        objc_setAssociatedObject(self, orderTagBy, orderTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)orderTag{
    return objc_getAssociatedObject(self, orderTagBy);
}

@end
