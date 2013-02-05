//
//  TicketOrder.h
//  TaurusClient
//
//  Created by Simon on 13-1-2.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreeCharCode;

@interface TicketOrder : NSObject

@property (nonatomic, retain) NSString *fromCityFullName;
@property (nonatomic, retain) NSString *toCityFullName;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSDate *departureTime;
@property (nonatomic, retain) NSString *flightNumber;
@property (nonatomic, retain) NSString *orderId;
- (id)initWithFromCityFullName:(NSString*)aFromCityFullName toCityFullName:(NSString*)aToCityFullName customerName:(NSString*)aCustomerName departureTime:(NSDate*)aDepartureTime flightNumber:(NSString*)aFlightNumber orderId:(NSString*)anOrderId;@end
