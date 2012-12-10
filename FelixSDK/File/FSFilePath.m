//
//  NSFilePath.m
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import "FSFilePath.h"


@implementation FSFilePath
@synthesize iFilePath;

-(void)dealloc
{
	[iFilePath release];
	[super dealloc];
}

-(NSString*)pushPathNode:(NSString*)pathNode//添加目录节点。返回的是添加之后的目录路径
{
	NSFileManager *file = [NSFileManager defaultManager];
	NSString *fullPath = [self fullFilePath];
	if(pathNode && ![pathNode isEqualToString:@""])
	{
		fullPath = [NSString stringWithFormat:@"%@/%@",fullPath,pathNode];
		if (![file fileExistsAtPath:fullPath]) {
			[file createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		return fullPath;
	}
	else {
		return nil;
	}

}

-(BOOL)deletePathNode:(NSString*)pathNode//删除目录节点，返回是否删除成功。
{
	NSFileManager *file = [NSFileManager defaultManager];
	NSString *fullPath = [self fullFilePath];
	if(pathNode && ![pathNode isEqualToString:@""])
	{
		fullPath = [NSString stringWithFormat:@"%@/%@",fullPath,pathNode];
		if (![file fileExistsAtPath:fullPath]) {
			return [file removeItemAtPath:fullPath error:nil];
		}
		return NO;
	}
	else {
		return NO;
	}
}

-(NSString*)addFileName:(NSString*)fileName//添加文件名称。返回的是整个文件路径。
{
	NSFileManager *file = [NSFileManager defaultManager];
	NSString *fullPath = [self fullFilePath];
	if(fileName && ![fileName isEqualToString:@""])
	{
		fullPath = [NSString stringWithFormat:@"%@/%@",fullPath,fileName];
		if (![file fileExistsAtPath:fullPath]) {
			//[file createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
			[file createFileAtPath:fullPath contents:nil attributes:nil];
		}
		return fullPath;
	}
	else {
		return nil;
	}
}

-(NSString*)fullFilePath//获取整个文件的路径。返回的是整个文件路径
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *fullPath = nil;
	fullPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
	if(iFilePath && ![iFilePath isEqualToString:@""])
	{
		fullPath = [NSString stringWithFormat:@"%@/%@",fullPath,iFilePath];
	}
	return fullPath;
}

@end
