//
//  ThreeCharCode.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "ThreeCharCode.h"

@implementation ThreeCharCode

@synthesize charCode;
@synthesize cityName;
@synthesize airportName;
@synthesize airportAbbrName;
@synthesize flightAreaCode;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithCharCode:(NSString*)aCharCode cityName:(NSString*)aCityName airportName:(NSString*)anAirportName airportAbbrName:(NSString*)anAirportAbbrName flightAreaCode:(int)aFlightAreaCode
{
    self = [super init];
    if (self) {
        self.charCode = aCharCode;
        self.cityName = aCityName;
        self.airportName = anAirportName;
        self.airportAbbrName = anAirportAbbrName;
        self.flightAreaCode = aFlightAreaCode;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
	self.charCode = nil;
	self.cityName = nil;
	self.airportName = nil;
	self.airportAbbrName = nil;
	[super dealloc];
}

@end
