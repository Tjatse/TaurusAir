//
//  NSObject+Serialize.m
//  FelixSDK
//
//  Created by Yang Felix on 12-5-7.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "NSObject+Serialize.h"

@implementation NSObject (Serialize)

- (void)serializeObjectToFile:(NSString*)fileName 
				 serializeKey:(NSString*)serializeKey
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:fileName])
		[[NSFileManager defaultManager] createFileAtPath:fileName 
												contents:nil 
											  attributes:nil];
	
	NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* vdArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [vdArchiver encodeObject:self forKey:serializeKey];
    [vdArchiver finishEncoding];
    [data writeToFile:fileName atomically:YES];
    [vdArchiver release];
    [data release];
}

+ (id)deserializeObjectFromFile:(NSString*)fileName
				   serializeKey:(NSString*)serializeKey
{
	id result = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {	
		NSData* data = [[NSData alloc] initWithContentsOfFile:fileName];
		NSKeyedUnarchiver* vdUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		result = [vdUnarchiver decodeObjectForKey:serializeKey];

		[vdUnarchiver finishDecoding];
		[vdUnarchiver release];
		[data release];
	}

	if (result == nil)
		result = [[[self alloc] init] autorelease];
	
	return result;
}

@end
