//
//  NSFileIO.m
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import "FSFileIO.h"


@implementation FSFileIO

+(NSInteger)read:(NSString*)fileFullPath withBuf:(NSData*)data atPos:(NSInteger)pos withSize:(NSInteger)size withSkip:(NSInteger)skip
{
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fileFullPath];
	NSInteger num = pos+skip;
	if (num<0) {
		return -1;
	}
	[file seekToFileOffset:num];
	data = [file readDataOfLength:size];
	return [data length];
}
+(NSInteger)readAll:(NSString*)fileFullPath withBuf:(NSData*)data
{
	NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:fileFullPath];
	data = [file readDataToEndOfFile];
	return [data length];
}

+(BOOL)write:(NSString*)fileFullPath withBuf:(NSData*)data atPos:(NSInteger)pos withSize:(NSInteger)size withSkip:(NSInteger)skip
{
	NSFileHandle *file = [NSFileHandle fileHandleForWritingAtPath:fileFullPath];
	NSInteger num = pos+skip;
	if (num<0) {
		return NO;
	}
	[file seekToFileOffset:num];
	if ([data length] > size) {
		NSRange rang = NSMakeRange(0,size);
		data = [data subdataWithRange:rang];
	}
	[file writeData:data];
	return YES;
}

+(NSInteger)getSize:(NSString*)fileFullPath
{
	NSFileManager *file = [NSFileManager defaultManager];
	NSDictionary *fileAttributes = [file attributesOfItemAtPath:fileFullPath error:nil];
	if(fileAttributes != nil)
	{
		NSString *fileSize = [fileAttributes objectForKey:NSFileSize];
		return [fileSize intValue];
	}
	return -1;
}

+(BOOL)fileExist:(NSString*)fileFullPath
{
	NSFileManager *file = [NSFileManager defaultManager];
	return [file fileExistsAtPath:fileFullPath];
}

+(BOOL)delFile:(NSString*)fileFullPath
{
	NSFileManager *file = [NSFileManager defaultManager];
	return [file removeItemAtPath:fileFullPath error:nil];
}

+(BOOL)createDirectory:(NSString*)fileFullPath
{
	NSFileManager *file = [NSFileManager defaultManager];
	
	if (![file fileExistsAtPath:fileFullPath])
		return [file createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return YES;
}

+(NSArray*)getDirectory:(NSString*)filePath
{
	NSFileManager *file = [NSFileManager defaultManager];
	
	return [file subpathsOfDirectoryAtPath:filePath error:nil];
}
@end
