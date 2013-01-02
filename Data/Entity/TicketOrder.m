//
//  TicketOrder.m
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import "TicketOrder.h"
#import "ThreeCharCode.h"

@implementation TicketOrder

@synthesize fromCity;
@synthesize toCity;
@synthesize customerName;
@synthesize departureTime;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithFromCity:(ThreeCharCode*)aFromCity toCity:(ThreeCharCode*)aToCity customerName:(NSString*)aCustomerName departureTime:(NSDate*)aDepartureTime
{
    self = [super init];
    if (self) {
        self.fromCity = aFromCity;
        self.toCity = aToCity;
        self.customerName = aCustomerName;
        self.departureTime = aDepartureTime;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.fromCity = nil;
    self.toCity = nil;
    self.customerName = nil;
    self.departureTime = nil;
	
    [super dealloc];
}

@end
