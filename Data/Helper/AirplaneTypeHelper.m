//
//  AirplaneTypeHelper.m
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "AirplaneTypeHelper.h"
#import "CharCodeHelper.h"
#import "AirplaneType.h"

@interface AirplaneTypeHelper ()

@end

@implementation AirplaneTypeHelper

+ (id)sharedHelper
{
	@synchronized (self) {
		static AirplaneTypeHelper* instance = nil;
		if (instance == nil) {
			instance = [[AirplaneTypeHelper alloc] init];
		}
		
		return instance;
	}
}

- (void)dealloc
{
	self.allAirplaneType = nil;
	
	[super dealloc];
}

- (NSDictionary *)allAirplaneType
{
	if (_allAirplaneType == nil) {
		_allAirplaneType = [[NSMutableDictionary dictionary] retain];
		
		NSString* filePath = [[NSBundle mainBundle] pathForResource:@"airplane_type_code" ofType:@"csv"];
		NSArray* csvPureLines = [CharCodeHelper parseContentOfCSVFile:filePath];
		
		for (NSArray* line in csvPureLines) {
			NSString* tid = [line objectAtIndex:0];
			NSString* shortModel = [line objectAtIndex:1];
			NSString* remark = [line objectAtIndex:2];
			NSString* planeType = [line objectAtIndex:3];
			
			AirplaneType* item = [[AirplaneType alloc] initWithTid:tid
														shortModel:shortModel
															remark:remark
														 planeType:planeType];
			
			[_allAirplaneType setValue:item forKey:shortModel];
			SAFE_RELEASE(item);
		}
	}

	return _allAirplaneType;
}

@end

@implementation AirplaneType (FriendlyPlaneType)

- (NSString *)friendlyPlaneType
{
	if ([self.planeType isEqualToString:@"1"])
		return @"大型机";
	else if ([self.planeType isEqualToString:@"2"])
		return @"中型机";
	else
		return @"小型机";
}

@end
