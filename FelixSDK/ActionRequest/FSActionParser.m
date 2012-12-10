//
//  NSBaseParse.m
//  SalesUnion
//
//  Created by J on 11-11-5.
//  Copyright 2011 deep. All rights reserved.
//

#import "FSActionParser.h"

@implementation FSActionParser

@synthesize busi = _busi;

- (id)initParse:(ParseType)type
{
	self = [self init];
	if (self)
		parseType = type;

	return self;
}

- (BOOL)parse:(NSString*)data {
	return YES;
}

- (void) dealloc {
	_busi = nil;
	
	[super dealloc];
}

@end
