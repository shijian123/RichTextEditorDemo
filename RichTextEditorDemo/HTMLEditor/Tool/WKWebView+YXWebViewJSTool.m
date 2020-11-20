//
//  WKWebView+YXWebViewJSTool.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import "WKWebView+YXWebViewJSTool.h"
#import "WKWebView+YXHideAccessoryView.h"

@implementation WKWebView (YXWebViewJSTool)

#pragma mark 标题、内容

- (void)contentHtmlTextHandler:(void(^)(id))success {
    [self evaluateJavaScript:@"RE.getHtml();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)titleTextHandler:(void(^)(id))success {
    [self evaluateJavaScript:@"RE.getTitle();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)setupTitle:(NSString *)title{
    NSString *trigger = [NSString stringWithFormat:@"RE.setTitle(\"%@\");",title];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)contentTextHandler:(void(^)(id))success {
    
    [self evaluateJavaScript:@"RE.getText();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            NSString *str = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            success(str);
        }
    }];
}

- (void)setupContent:(NSString *)content{
    NSString *html = [content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *trigger = [NSString stringWithFormat:@"RE.setHtml(\"%@\");",html];
    
    [self evaluateJavaScript:trigger completionHandler:nil];
    
}

/**
 :初始化文章
 */
- (void)setupHtmlContent:(NSString *)content {
    
    NSString *html = [content stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *trigger = [NSString stringWithFormat:@"RE.setHtmlStr(\"%@\",\"%@\");",html,[self deleteImageBase64String]];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

/// 清除占位符内容
- (void)clearContentPlaceholder{
    [self evaluateJavaScript:@"RE.clearBackTxt();" completionHandler:nil];
}

- (void)showContentPlaceholder{
    [self evaluateJavaScript:@"RE.showBackTxt();" completionHandler:nil];
}

/// 动态更改占位符内容
- (void)changePlaceholder:(NSString *)placeholder {
    if (placeholder && placeholder.length > 0) {
        NSString *trigger = [NSString stringWithFormat:@"RE.changePlaceholder(\"%@\");",placeholder];
        [self evaluateJavaScript:trigger completionHandler:nil];
    }
}

#pragma mark - Utilities

- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    return html;
}

- (void)tidyHTML:(NSString *)html success:(void(^)(id))success {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    
    [self evaluateJavaScript:[NSString stringWithFormat:@"style_html(\"%@\");", html] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)undo{
    [self evaluateJavaScript:@"RE.undo();" completionHandler:nil];
}

- (void)redo{
    [self evaluateJavaScript:@"RE.redo();" completionHandler:nil];
}
- (void)bold{
    [self evaluateJavaScript:@"RE.setBold();" completionHandler:nil];
}
- (void)italic{
    [self evaluateJavaScript:@"RE.setItalic();" completionHandler:nil];
}
- (void)underline{
    [self evaluateJavaScript:@"RE.setUnderline();" completionHandler:nil];
}
- (void)justifyLeft{
    [self evaluateJavaScript:@"RE.setJustifyLeft();" completionHandler:nil];
}

- (void)justifyCenter{
    [self evaluateJavaScript:@"RE.setJustifyCenter();" completionHandler:nil];
}

- (void)justifyRight{
    [self evaluateJavaScript:@"RE.setJustifyRight();" completionHandler:nil];
}
- (void)blockQuote{
    [self evaluateJavaScript:@"RE.setBlockquote();" completionHandler:nil];
    
}
- (void)indent{
    [self evaluateJavaScript:@"RE.setIndent();" completionHandler:nil];
}

- (void)outdent{
    [self evaluateJavaScript:@"RE.setOutdent();" completionHandler:nil];
}
- (void)unorderlist{
    [self evaluateJavaScript:@"RE.setBullets();" completionHandler:nil];
}
- (void)orderlist{
    [self evaluateJavaScript:@"RE.setNumbers();" completionHandler:nil];
}

- (void)insertLinkUrl:(NSString *)url title:(NSString*)title content:(NSString *)content{
    NSString *trigger= [NSString stringWithFormat:@"RE.insertLink(\"%@\", \"%@\",\"%@\",);",url,title,content];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)heading1 {
    [self evaluateJavaScript:@"RE.setHeading('1');" completionHandler:nil];
}

- (void)heading2 {
    [self evaluateJavaScript:@"RE.setHeading('2');" completionHandler:nil];
}

- (void)heading3 {
    [self evaluateJavaScript:@"RE.setHeading('3');" completionHandler:nil];
}

//唤醒键盘
- (void)focusTextEditor{
    [self evaluateJavaScript:@"RE.focusEditor();" completionHandler:nil];
}

- (void)normalFontSize{
    NSString *trigger = [NSString stringWithFormat:@"RE.setFontSize(\"%@\");", @"3"];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

/**
 :正常插入图片
 */
- (void)insertImageUrl:(NSString *)imageUrl alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.insertImage(\"%@\", \"%@\");", imageUrl, alt];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

/**
 :插入图片 有删除按钮
 */
- (void)insertImageUrl:(NSString *)imageUrl delUrl:(NSString *)delUrl alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"RE.insertImage2(\"%@\", \"%@\", \"%@\");", imageUrl,delUrl, alt];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)getSelectStringHandler:(void(^)(id))success {
    
    [self evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)getSelectionHandler:(void(^)(id))success {
    [self evaluateJavaScript:@"window.getSelection().anchorNode.parentNode.tagName.toString()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            NSString *str = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            success(str);
        }
    }];
}

- (void)clearLink{
    [self evaluateJavaScript:@"RE.clearLink();" completionHandler:nil];
}

- (void)showKeyboardTitle{
    [self evaluateJavaScript:@"document.getElementById(\"article_title\").focus()" completionHandler:nil];
}

- (void)showKeyboardContent{
    [self evaluateJavaScript:@"document.getElementById(\"article_content\").focus()" completionHandler:nil];
}

//退出键盘
- (void)hiddenKeyboard{
    [self evaluateJavaScript:@"document.activeElement.blur()" completionHandler:nil];
}

- (void)calculateEditorHeightWithCaretPositionHandler:(void(^)(id))success {
    [self evaluateJavaScript:@"RE.calculateEditorHeightWithCaretPosition();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)getCaretYPositionHandler:(void(^)(id))success {
    [self evaluateJavaScript:@"RE.getCaretYPosition();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result) {
            success(result);
        }
    }];
}

- (void)autoScrollTop:(CGFloat)offsetY{
    
    NSString *trigger = [NSString stringWithFormat:@"RE.autoScroll(\"%f\");",offsetY];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)setFontSize:(NSString *)size{
    NSString *trigger = [NSString stringWithFormat:@"RE.setFontSize(\"%@\");", size];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

//插入编码图片
- (void)insertImage:(NSData *)imageData key:(NSString *)key{
    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:0];
    NSString *trigger = [NSString stringWithFormat:@"RE.insertImageBase64String(\"%@\", \"%@\");",imageBase64String,key];
    [self evaluateJavaScript:trigger completionHandler:nil];
    
}

//图片上传中
- (void)insertImageKey:(NSString *)imageKey progress:(CGFloat)progress{
    NSString *trigger = [NSString stringWithFormat:@"RE.uploadImg(\"%@\", \"%.2f\");",imageKey, progress];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

//- (void)inserSuccessImageKey:(NSString *)imageKey imgUrl:(NSString *)imgUrl{
//    NSString *trigger = [NSString stringWithFormat:@"RE.insertSuccessReplaceImg(\"%@\", \"%@\");",imageKey, imgUrl];
//    [self stringByEvaluatingJavaScriptFromString:trigger];
//}
- (void)insertSuccessImageKey:(NSString *)imageKey imgUrl:(NSString *)imgUrl {
    NSString *trigger = [NSString stringWithFormat:@"RE.insertSuccessReplaceImg2(\"%@\",\"%@\", \"%@\");",imageKey, imgUrl, [self deleteImageBase64String]];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)insertUpdateImg:(NSString *)imageKey imgUrl:(NSString *)imgUrl {
    NSString *trigger = [NSString stringWithFormat:@"insertUpdateImg(\"%@\", \"%@\");",imageKey, imgUrl];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)deleteImageKey:(NSString *)key{
    NSString *trigger = [NSString stringWithFormat:@"RE.removeImg(\"%@\");",key];
    
    [self evaluateJavaScript:trigger completionHandler:nil];
    //可编辑
    [self evaluateJavaScript:@"RE.canFocus(true);" completionHandler:nil];
}


- (void)setupEditEnable:(BOOL)enable {
    //可编辑
    [self evaluateJavaScript:enable ? @"RE.canFocus(true);" : @"RE.canFocus(false);" completionHandler:nil];
}

- (void)setupContentDisable:(BOOL)disable{
    NSString *trigger = [NSString stringWithFormat:@"RE.canFocus(\"%@\");",disable?@"true":@"false"];
    [self evaluateJavaScript:trigger completionHandler:nil];
    [self evaluateJavaScript:@"RE.restorerange();" completionHandler:nil];
}

- (void)uploadErrorKey:(NSString *)key{
    NSString *trigger = [NSString stringWithFormat:@"RE.uploadError(\"%@\");",key];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

- (void)removeBtnErrorKey:(NSString *)key isHide:(BOOL)isHide{
    NSString *trigger = [NSString stringWithFormat:@"RE.removeErrorBtn(\"%@\",\"%@\");",key,isHide?@"true":@"false"];
    [self evaluateJavaScript:trigger completionHandler:nil];
}

/**
 * 删除按钮图
 */
- (NSString *)deleteImageBase64String {
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"imagedelete"],1.0f);
    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:0];
    return imageBase64String;
}

@end

@implementation NSString (UUID)

+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidRef);
    NSString *uuid = (__bridge NSString *)uuidString;
    CFRelease(uuidString);
    CFRelease(uuidRef);
    
    return uuid;
}

- (id)jsonObject{
    NSError *error = nil;
    if (!self) {
        return nil;
    }
    id result = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error || [NSJSONSerialization isValidJSONObject:result] == NO){
        return nil;
    }
    return result;
}

- (NSString*)stringByAppendingUrlComponent:(NSString*)string{
    NSString* urlhost = [self toTrim];
    if([string isBeginWith:@"/"]){
        if([urlhost isEndWith:@"/"]){
            urlhost = [urlhost substringToIndex:urlhost.length - 1];
        }
    }else{
        if([urlhost isEndWith:@"/"] == NO){
            urlhost = [urlhost stringByAppendingString:@"/"];
        }
    }
    return [urlhost stringByAppendingString:string];
}

- (BOOL)isBeginWith:(NSString *)string{
    return ([self hasPrefix:string]) ? YES : NO;
}

- (BOOL)isEndWith:(NSString *)string{
    return ([self hasSuffix:string]) ? YES : NO;
}

- (NSString*)toTrim{
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

@end
