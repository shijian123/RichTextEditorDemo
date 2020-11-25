//
//  YXEmojiDataManager.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/25.
//

#import <Foundation/Foundation.h>
#import "YXEmojiModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXEmojiDataManager : NSObject

@property (nonatomic, strong) NSArray<YXEmojiGroupModel *> *emojiPackages;
@property (nonatomic) NSInteger currentPackage;

+ (YXEmojiDataManager *)manager;

- (NSMutableAttributedString *)replaceEmojiWithPlanString:(NSString *)planString attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes;

- (NSMutableAttributedString *)replaceEmojiWithAttributedString:(NSAttributedString *)attributedString attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes;

- (NSString *)plainStringWith:(nonnull UITextView *)textView;

- (NSString *)plainStringWith:(NSAttributedString *)attributedString range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
