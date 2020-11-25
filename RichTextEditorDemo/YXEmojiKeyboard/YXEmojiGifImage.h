//
//  YXEmojiGifImage.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//  拷贝的 YLGifImage 源码

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiGifImage : UIImage
///-----------------------
/// @name Image Attributes
///-----------------------

/**
 A C array containing the frame durations.
 
 The number of frames is defined by the count of the `images` array property.
 */
@property (nonatomic, readonly) NSTimeInterval *frameDurations;

/**
 Total duration of the animated image.
 */
@property (nonatomic, readonly) NSTimeInterval totalDuration;

/**
 Number of loops the image can do before it stops
 */
@property (nonatomic, readonly) NSUInteger loopCount;

- (UIImage*)getFrameWithIndex:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
