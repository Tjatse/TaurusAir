//
//  TwoCharCode.m
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "TwoCharCode.h"

@implementation TwoCharCode

@synthesize charCode;
@synthesize corpFullName;
@synthesize corpAbbrName;
@synthesize flightAreaCode;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithCharCode:(NSString*)aCharCode corpFullName:(NSString*)aCorpFullName corpAbbrName:(NSString*)aCorpAbbrName flightAreaCode:(int)aFlightAreaCode
{
    self = [super init];
    if (self) {
        self.charCode = aCharCode;
        self.corpFullName = aCorpFullName;
        self.corpAbbrName = aCorpAbbrName;
        self.flightAreaCode = aFlightAreaCode;
    }
    return self;
}


//===========================================================
// + (id)objectWith:
//
//===========================================================
+ (id)objectWithCharCode:(NSString*)aCharCode corpFullName:(NSString*)aCorpFullName corpAbbrName:(NSString*)aCorpAbbrName flightAreaCode:(int)aFlightAreaCode
{
    id result = [[[self class] alloc] initWithCharCode:aCharCode corpFullName:aCorpFullName corpAbbrName:aCorpAbbrName flightAreaCode:aFlightAreaCode];
	
    return [result autorelease];
}

//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
	self.charCode = nil;
	self.corpFullName = nil;
	self.corpAbbrName = nil;
	
	[super dealloc];
}



@end
