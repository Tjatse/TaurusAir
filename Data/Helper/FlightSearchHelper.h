//
//  FlightSearchHelper.h
//  TaurusClient
//
//  Created by Simon on 13-1-12.
//  Copyright (c) 2013年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreeCharCode;

@interface FlightSearchHelper : NSObject

+ (void)performFlightSearchWithDepartureCity:(ThreeCharCode*)aDepartureCity
							  andArrivalCity:(ThreeCharCode*)aArrivalCity
							andDepartureDate:(NSDate*)aDepartureDate
								  andSuccess:(void (^)(NSDictionary* respObj))success
								  andFailure:(void (^)(NSString *errorMsg))failure;

@end
