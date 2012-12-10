//
//  FSCommonJsonParser.m
//  FelixSDK
//
//  Created by Yang Felix on 12-4-17.
//  Copyright (c) 2012年 deep. All rights reserved.
//

#import "FSCommonJsonParser.h"
#import "JSONKit.h"

@implementation FSCommonJsonParser

@synthesize root;

- (void)dealloc
{
	self.root = nil;
	[super dealloc];
}

- (BOOL)parse:(NSString *)data
{
	if ([data length] <= 0)
		return NO;
	
	self.root = nil;
	self.root = [data objectFromJSONString];

	return YES;
}

@end
