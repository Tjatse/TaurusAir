//
//  NSDictionaryAdditions.h
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (CGFloat)getFloatValueForKey:(NSString*)key defaultValue:(CGFloat)defaultValue;
- (id)getValueForKey:(NSString*)key defaultValue:(id)defaultValue;

- (BOOL)getBoolValueForKeyPath:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKeyPath:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)getTimeValueForKeyPath:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)getLongLongValueValueForKeyPath:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKeyPath:(NSString *)key defaultValue:(NSString *)defaultValue;
- (CGFloat) getFloatValueForKeyPath:(NSString*)key defaultValue:(CGFloat)defaultValue;
- (id)getValueForKeyPath:(NSString*)key defaultValue:(id)defaultValue;

@end
