//
//  YXHtmlUploadPictureModel.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
  YXUploadImageModelTypeNone,     //上传中
  YXUploadImageModelTypeError,    //上传失败
  YXUploadImageModelTypeSuccess,  //上传成功
} YXUploadImageModelType;

@interface YXHtmlUploadPictureModel : NSObject
@property (nonatomic) YXUploadImageModelType type;
//图片域名
@property (nonatomic, copy) NSString *host;
//命名
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *key;
//服务器返回的
@property (nonatomic, copy) NSString *token;
//本地的地址
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, copy) UIImage *image;

@end

NS_ASSUME_NONNULL_END
