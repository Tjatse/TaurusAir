#import <UIKit/UIKit.h>

@interface NSString (pinyin) 

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string;
+ (NSString*)pinyinFirstCharFromChineseString:(NSString*)string;

@end
