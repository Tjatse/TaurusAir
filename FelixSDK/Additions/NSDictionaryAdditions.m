//
//  NSDictionaryAdditions.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-6.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "NSDictionaryAdditions.h"

@implementation NSDictionary (Additions)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    return ([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == nil) ? defaultValue
						: [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
	return [self objectForKey:key] == [NSNull null]
				? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
	NSString *stringTime   = [self objectForKey:key];
    if (![stringTime isKindOfClass:[NSString class]] && ![stringTime isKindOfClass:[NSNull class]]) {
        stringTime = [NSString stringWithFormat:@"%@",[(NSNumber*)stringTime stringValue]];
    }
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue
{
	return [self objectForKey:key] == [NSNull null] 
		? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] 
				? defaultValue : [self objectForKey:key];
}

- (CGFloat) getFloatValueForKey:(NSString*)key defaultValue:(CGFloat)defaultValue
{
	return [self objectForKey:key] == [NSNull null] 
	? defaultValue : [[self objectForKey:key] floatValue];
}

- (id)getValueForKey:(NSString*)key defaultValue:(id)defaultValue
{
	return [self objectForKey:key] == [NSNull null]
	? defaultValue : [self objectForKey:key];
}

- (BOOL)getBoolValueForKeyPath:(NSString *)key defaultValue:(BOOL)defaultValue
{
    return ([self valueForKeyPath:key] == [NSNull null] || [self valueForKeyPath:key] == nil) ? defaultValue
	: [[self valueForKeyPath:key] boolValue];
}

- (int)getIntValueForKeyPath:(NSString *)key defaultValue:(int)defaultValue
{
	return [self valueForKeyPath:key] == [NSNull null]
	? defaultValue : [[self valueForKeyPath:key] intValue];
}

- (time_t)getTimeValueForKeyPath:(NSString *)key defaultValue:(time_t)defaultValue
{
	NSString *stringTime   = [self valueForKeyPath:key];
    if (![stringTime isKindOfClass:[NSString class]] && ![stringTime isKindOfClass:[NSNull class]]) {
        stringTime = [NSString stringWithFormat:@"%@",[(NSNumber*)stringTime stringValue]];
    }
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKeyPath:(NSString *)key defaultValue:(long long)defaultValue
{
	return [self valueForKeyPath:key] == [NSNull null]
	? defaultValue : [[self valueForKeyPath:key] longLongValue];
}

- (NSString *)getStringValueForKeyPath:(NSString *)key defaultValue:(NSString *)defaultValue
{
	return [self valueForKeyPath:key] == nil || [self valueForKeyPath:key] == [NSNull null]
	? defaultValue : [self valueForKeyPath:key];
}

- (CGFloat) getFloatValueForKeyPath:(NSString*)key defaultValue:(CGFloat)defaultValue
{
	return [self valueForKeyPath:key] == [NSNull null]
	? defaultValue : [[self valueForKeyPath:key] floatValue];
}

- (id)getValueForKeyPath:(NSString*)key defaultValue:(id)defaultValue
{
	return [self valueForKeyPath:key] == [NSNull null]
	? defaultValue : [self valueForKeyPath:key];
}

@end
