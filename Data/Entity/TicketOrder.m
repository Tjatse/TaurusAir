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

@synthesize fromCityFullName;
@synthesize toCityFullName;
@synthesize customerName;
@synthesize departureTime;
@synthesize flightNumber;
@synthesize orderId;

//===========================================================
// - (id)initWith:
//
//===========================================================
- (id)initWithFromCityFullName:(NSString*)aFromCityFullName toCityFullName:(NSString*)aToCityFullName customerName:(NSString*)aCustomerName departureTime:(NSDate*)aDepartureTime flightNumber:(NSString*)aFlightNumber orderId:(NSString*)anOrderId
{
    self = [super init];
    if (self) {
        self.fromCityFullName = aFromCityFullName;
        self.toCityFullName = aToCityFullName;
        self.customerName = aCustomerName;
        self.departureTime = aDepartureTime;
        self.flightNumber = aFlightNumber;
        self.orderId = anOrderId;
    }
    return self;
}


//===========================================================
// dealloc
//===========================================================
- (void)dealloc
{
    self.fromCityFullName = nil;
    self.toCityFullName = nil;
    self.customerName = nil;
    self.departureTime = nil;
    self.flightNumber = nil;
    self.orderId = nil;
	
    [super dealloc];
}



@end
