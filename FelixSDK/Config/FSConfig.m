//
//  NSConfig.m
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import "FSConfig.h"

#define CONFIG_FILE_NAME @"config"

static FSConfig* gConfig = nil;

@implementation FSConfig

@synthesize serverURL;

- (id)init
{
	self = [super init];
	if (self) {
		NSString* pathName = [FSConfig getConfigPath];
		NSString* frompath = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
		NSFileManager* file = [NSFileManager defaultManager];
		NSError* error = nil;
		
		if (![file fileExistsAtPath:pathName]) {
			[file copyItemAtPath:frompath toPath:pathName error:&error];
			if (error) {
				NSLog(@"%@",error);
			}
		}
		
		serverURL = [FSConfig readValueWithKey:Domain_Key];
	}
	
	return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (gConfig == nil) {
			gConfig = [super allocWithZone:zone];
			return gConfig;
		}
	}
	
	return nil;
}

+ (FSConfig*)engine
{
    @synchronized(self) {
		if (gConfig == nil) 
			gConfig = [[self alloc] init];
	}
	
	return gConfig;
}

+ (NSString*)getConfigPath
{
	NSFileManager *file = [NSFileManager defaultManager];
	NSString* pathName = [FSConfig readMainValueWithKey:configPath_Key];
	NSString* pathType = [FSConfig readMainValueWithKey:configType_Key];
	NSArray* paths = nil;
	
	if ([pathType intValue] == 1) {
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		pathName = [NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],pathName];
		if (![file fileExistsAtPath:pathName])
			[file createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];

		pathName = [NSString stringWithFormat:@"%@%@.plist",pathName,CONFIG_FILE_NAME];
	}
	else if([pathType intValue] == 2) {
		paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
		pathName = [NSString stringWithFormat:@"%@%@",[paths objectAtIndex:0],pathName];
		if (![file fileExistsAtPath:pathName])
			[file createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];

		pathName = [NSString stringWithFormat:@"%@%@.plist",pathName,CONFIG_FILE_NAME];
	}
	else if([pathType intValue] == 3) {
		paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* pathtemp = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
		NSRange rang = [pathtemp rangeOfString:@"/" options:NSBackwardsSearch];
		pathtemp = [pathtemp substringToIndex:rang.location];
		pathName = [NSString stringWithFormat:@"%@/tmp/",pathtemp];
		
		if (![file fileExistsAtPath:pathName])
			[file createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];

		pathName = [NSString stringWithFormat:@"%@/%@/%@.plist",pathtemp,pathName,CONFIG_FILE_NAME];
	}
	return pathName;
}

+ (BOOL)setArray:(NSArray*)array withKey:(NSString*)key
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary * dict = [[NSMutableDictionary  alloc] initWithContentsOfFile:path];
	[dict setObject:array forKey:key];

	BOOL result = [dict writeToFile:path atomically:YES];
	[dict release];
	
	return result;
}

+ (NSArray*)readArrayWithKey:(NSString*)key
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSArray* object = [dict objectForKey:key];
	return object;
}

+ (NSObject*) readObjectWithKey:(NSString*)key 
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSObject *object = [dict objectForKey:key];
	
	return object;
}

+ (NSArray*)readArrayWithKey:(NSString*)key defaultValue:(NSArray*)defValue
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSArray* object = [dict objectForKey:key];
	return object == nil ? defValue : object;
}

+ (NSObject*)readObjectWithKey:(NSString*)key defaultValue:(NSObject*)defValue
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSObject *object = [dict objectForKey:key];
	
	return object == nil ? defValue : object;
}

+ (NSString*)readValueWithKey:(NSString*)key defaultValue:(NSString*)defValue
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSString* object = [dict objectForKey:key];
	return object == nil ? defValue : object;
}

+ (NSString*)readMainValueWithKey:(NSString*)key defaultValue:(NSString*)defValue
{
	NSString* path = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSString* object=[dict objectForKey:key];
	
	return object == nil ? defValue : object;
}

+ (int)readIntegerWithKey:(NSString*)key defaultValue:(int)defValue
{
	NSString* resultStr = [self readValueWithKey:key];
	int result = resultStr == nil ? defValue : [resultStr intValue];
	return result;
}

+ (BOOL)readBoolWithKey:(NSString*)key defaultValue:(BOOL)defValue
{
	NSString* resultStr = [self readValueWithKey:key];
	BOOL result = resultStr == nil ? defValue : ([resultStr intValue] > 0);
	return result;
}

+ (BOOL)setValue:(NSString*)value withKey:(NSString*)key
{
	if (value == nil) { return NO; }
	
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	[dict setObject:value forKey:key];
	
	BOOL result = [dict writeToFile:path atomically:YES];
	[dict release];
	
	return result;
}

+ (BOOL) setObject:(NSObject*)object withKey:(NSString*)key {
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	[dict setObject:object forKey:key];
	
	BOOL result = [dict writeToFile:path atomically:YES];
	[dict release];
	
	return result;
}

+ (NSString*)readValueWithKey:(NSString*)key
{
	NSString* path = [FSConfig getConfigPath];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSString* object = [dict objectForKey:key];
	return object;
}

+ (NSString*)readMainValueWithKey:(NSString*)key
{
	NSString* path = [[NSBundle mainBundle] pathForResource:CONFIG_FILE_NAME ofType:@"plist"];
	NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
	NSString* object=[dict objectForKey:key];
	
	return object;
}

+ (int)readIntegerWithKey:(NSString*)key 
{
	NSString* resultStr = [self readValueWithKey:key];
	int result = [resultStr intValue];
	return result;
}

+ (BOOL) setIntegerValue:(int)value withKey:(NSString*)key 
{
	NSString* valueStr = [NSString stringWithFormat:@"%d", value];
	BOOL result = [self setValue:valueStr withKey:key];
	
	return result;
}

+ (BOOL) readBoolWithKey:(NSString*)key 
{
	NSString* resultStr = [self readValueWithKey:key];
	BOOL result = [resultStr intValue] > 0;
	return result;
}

+ (BOOL) setBoolValue:(BOOL)value withKey:(NSString*)key 
{
	return [[self class] setIntegerValue:(value ? 1 : 0) withKey:key];
}

@end
