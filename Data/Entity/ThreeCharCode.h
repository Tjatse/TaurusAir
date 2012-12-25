//
//  ThreeCharCode.h
//  TaurusClient
//
//  Created by Simon on 12-12-25.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeCharCode : NSObject

@property (nonatomic, retain) NSString *charCode;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *airportName;
@property (nonatomic, retain) NSString *airportAbbrName;
@property (nonatomic, assign) int flightAreaCode;
- (id)initWithCharCode:(NSString*)aCharCode cityName:(NSString*)aCityName airportName:(NSString*)anAirportName airportAbbrName:(NSString*)anAirportAbbrName flightAreaCode:(int)aFlightAreaCode;

@end
