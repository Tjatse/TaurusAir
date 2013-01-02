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

@property (nonatomic, retain) ThreeCharCode *fromCity;
@property (nonatomic, retain) ThreeCharCode *toCity;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSDate *departureTime;
@property (nonatomic, retain) NSString *flightNumber;
- (id)initWithFromCity:(ThreeCharCode*)aFromCity toCity:(ThreeCharCode*)aToCity customerName:(NSString*)aCustomerName departureTime:(NSDate*)aDepartureTime flightNumber:(NSString*)aFlightNumber;
@end
