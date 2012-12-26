//
//  City.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "City.h"

@implementation City

@synthesize cityName;
@synthesize threeCharCodes;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithCityName:(NSString*)aCityName threeCharCodes:(NSArray*)aThreeCharCodes
{
    self = [super init];
    if (self) {
        self.cityName = aCityName;
        self.threeCharCodes = aThreeCharCodes;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.cityName = nil;
    self.threeCharCodes = nil;
	
    [super dealloc];
}

- (void)appendThreeCharCode:(ThreeCharCode*)item
{
	if (self.threeCharCodes == nil)
		self.threeCharCodes = [NSMutableArray array];
	
	[(NSMutableArray*)self.threeCharCodes addObject:item];
}

@end
