//
//  NSDateAdditions.h
//  sepeople
//
//  Created by Yang Felix on 12-5-21.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Additions)

- (NSString *)getFormatYearMonthDay;
- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;
- (NSDate*)dateAfterHours:(int)hours;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateafterMonth:(int)month;
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
- (int )getHour;
- (int)getMinute;
- (int )getHour:(NSDate *)date;
- (int)getMinute:(NSDate *)date;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)string;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

@end
