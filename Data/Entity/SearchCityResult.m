//
//  SearchCityResult.m
//  TaurusClient
//
//  Created by Simon on 12-12-29.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "SearchCityResult.h"

@implementation SearchCityResult

@synthesize city;
@synthesize reason;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithCity:(City*)aCity reason:(NSString*)aReason
{
    self = [super init];
    if (self) {
        self.city = aCity;
        self.reason = aReason;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.city = nil;
    self.reason = nil;
	
    [super dealloc];
}

@end
