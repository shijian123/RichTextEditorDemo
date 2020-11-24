//
//  UITextView+YX.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/24.
//

#import "UITextView+YX.h"

@implementation UITextView (YX)

- (BOOL)limitTVWithLength:(NSInteger)lenght{
    
    UITextRange *selectedRange = [self markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [self positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return YES;
    }
    
    NSInteger totalLenght = 0;
    NSInteger curIndex = -10;
    
    for (NSInteger i=0; i<self.text.length; i++) {
        NSString* subStr= [self.text substringWithRange:NSMakeRange(i, 1)];
        NSInteger changedLenhgt = subStr.length;
        
        if ((totalLenght == lenght*2-1) && (changedLenhgt == 2)) {
            curIndex = i;
        }
        
        totalLenght += subStr.length;
        
        if (totalLenght == lenght*2) {
            curIndex = i+1;
        } else if (totalLenght > lenght*2) {
            curIndex = i;
        }
        
        if (curIndex != -10) {
            break;
        }
        
    }
    if (curIndex != -10) {
        NSRange range = {0,curIndex};
        self.text = [self.text substringWithRange:range];
    }
    
    return NO;
    
}

@end
